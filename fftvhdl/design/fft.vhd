library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.CONV_SIGNED;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library work;
use work.common.all;


-- Main module of fft process
-- Compines the starting scrambler module and each stage of butterfly modules to 
-- execute the FFT DIT - Radix 2 - Pipelined operation
-- Takes as a input centain number of complex numbers in time field and 
-- returns the same number of complex numbers in frequency field
-- The time it takes to compute the result is equal to the number of stages [log2(#inputs)]
entity fft is 
    port(
        clock : in std_logic;
        input_x_time : in butterfly_type(0 to input_size-1);
        output_x_freq : out butterfly_type(0 to input_size-1)
    );
end entity; 

architecture rtl of fft is 
    component scrambler_module is 
        port(
            scrambler_input : in butterfly_type(0 to input_size-1);
            scrambler_output : out butterfly_type(0 to input_size-1)
        );
    end component;

    component butterfly is 
    generic(
        stage: integer:=1
    );
    port(
        clock               : in std_logic;
        input_butterfly          : in butterfly_type(0 to 2**stage -1 ); 
        output_butterfly  : out  butterfly_type(0  to 2**stage -1)
    );
    end component;

    signal scrambler_out : butterfly_type(0 to input_size-1);
    
    signal butterfly_stage_1_out :butterfly_stage_type;
    signal butterfly_stage_1_in : butterfly_stage_type;
    
    signal rom_of_unity_1 :rom := rom_of_unity;
    
    begin
        -- First of all scramble the inputs to put them in correct form for the operation
        -- Check scrambler.vhd
        scrambler_module_1 : scrambler_module
            port map(input_x_time,scrambler_out);

        -- The first stage generates #input/2 butterflies as each butterfly is of stage = 1
        -- so it has 2 inputs
        -- Then the results of the first butterfly are combined in serial order 
        -- First 2 outputs , get the first 2 positions, the next 2 inputs, the next 2 outputs and so on.
        butterfly_stage: for II in 1 to 1 generate
            butterfly_1 : for JJ in 0 to input_size/(2**II)-1 generate
                butterfly_module : butterfly
                    generic map (stage =>II)
                    port map(
                        clock => clock,
                        input_butterfly => scrambler_out((2**II)*JJ to (2**II-1)+(2**II)*JJ),
                        output_butterfly => butterfly_stage_1_out(1)((2**II)*JJ to (2**II-1)+(2**II)*JJ)
                    );
            end generate butterfly_1;
        end generate butterfly_stage;
        
        -- For every next stage the butterflies changes in size and take as port 2**stage inputs
        -- So in every level we need fewer and fewer butterfly modules 
        -- In each stage we need #inputs/2**stage butterflys
        -- You can think it like a binary tree were the leafs have #input/2 nodes, their parent #input/4 nodes and so on
        -- until the root
        butterfly_stage_2: for II in 2 to input_length_size generate
           butterfly_2 : for JJ in 0 to input_size/(2**II)-1 generate
                butterfly_module : butterfly
                    generic map (stage =>II)
                    port map(
                        clock           => clock,
                        input_butterfly => butterfly_stage_1_in(II-1)((2**II)*JJ to (2**II-1)+(2**II)*JJ),
                        output_butterfly => butterfly_stage_1_out(II)((2**II)*JJ to (2**II-1)+(2**II)*JJ)
                    );
            end generate butterfly_2;
        end generate butterfly_stage_2;
        
        butterfly_stage_1_in <= butterfly_stage_1_out;
        output_x_freq <= butterfly_stage_1_out(input_length_size);

end architecture;