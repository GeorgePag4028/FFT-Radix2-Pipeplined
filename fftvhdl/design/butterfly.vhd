library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common.all;

-- Performs the butterfly function 
-- y0 = x0 + x1*twiddle
-- y1 = x0 - x1*twiddle
-- Calls 2 module : adder - subber for each one of this operations
-- A stage represent the amount of inputs of each butterfly
-- stage = 1 -> inputs = 2^1
-- stage = 2 -> inputs = 2^2
entity butterfly is 
    generic(
        stage : integer := 1
    );
    port(
        clock                   : in std_logic;
        input_butterfly         : in butterfly_type(0 to 2**stage -1 ); 
        output_butterfly        : out butterfly_type(0 to 2**stage - 1 )
    );
end entity;

architecture rtl of butterfly is
    component adder is 
        port(
        clock         : in std_logic;
        input_adder_1 : in complex_type;
        input_adder_2 : in complex_type;
        twiddle       : in complex_type;
        output_adder  : out complex_type
        );
    end component;

    component subber is 
        port(
        clock       : in std_logic;
        input_sub_1 : in complex_type;
        input_sub_2 : in complex_type;
        twiddle     : in complex_type;
        output_sub  : out complex_type
        );
    end component;

    begin 
        -- For each stage we need specific number of adder and subber modules (2**stage)/2
        -- stage = 1 -> 2 inputs -> 1 adder and 1 subber
        -- stage = 2 -> 4 inputs -> 2 adder and 2 subber
        -- Each pair of inputs is combined to produce a pair of outputs
        -- Every input(i) is combined with input(i+#inputs/2) to produce a output (#inputs = 2**stage/2)
        -- This pair also outputs to output(i) [adder] and output(i+#inputs/2) [subber]

        -- As for the twiddle factors we have saved them at compiled time in a constant rom [rom_of_unity]
        -- Each pair of the adder and subber module uses exactly the same twiddle factor  
        -- So we need 2**stage/2 twiddle factors
        -- The formula of each twiddle is : twiddle((#input/2)*i/(2**stage)/2)
        -- #twiddle_factors*Σ(Α=0 to Α=stage-1) Α/#butterfly_inputs
        -- Example with #input = 16

        -- For stage = 1 we need twiddle(0) = twiddle(8*0/(2/2))

        -- For stage = 2 we need twiddle(0) = twiddle(8*0/(4/2)), twiddle(4) = twiddle(8*1(4/2))

        -- For stage = 3 we need twiddle(0) = twiddle(8*0/(8/2))
        --                       twiddle(2) = twiddle(8*1/(8/2))
        --                       twiddle(4) = twiddle(8*2/(8/2))
        --                       twiddle(6) = twiddle(8*3/(8/2))

        -- For stage = 4 we need twiddle(0) = twiddle(8*0/(16/2))
        --                       twiddle(1) = twiddle(8*1/(16/2))
        --                       twiddle(2) = twiddle(8*2/(16/2))
        --                       twiddle(3) = twiddle(8*3/(16/2))
        --                       twiddle(4) = twiddle(8*4/(16/2))
        --                       twiddle(5) = twiddle(8*5/(16/2))
        --                       twiddle(6) = twiddle(8*6/(16/2))
        --                       twiddle(7) = twiddle(8*7/(16/2))

        butter_1:for ii in 0 to (2**stage-1)/2 generate
                adder_module :adder
                port map (clock,input_butterfly(ii),input_butterfly(ii+(2**stage/2)),rom_of_unity((input_size/2)*ii/((2**stage)/2)),output_butterfly(ii));
    
                sub_module :subber
                port map (clock,input_butterfly(ii),input_butterfly(ii+(2**stage/2)),rom_of_unity((input_size/2)*ii/((2**stage)/2)),output_butterfly(ii+(2**stage/2)));
        end generate butter_1;
    
end architecture;