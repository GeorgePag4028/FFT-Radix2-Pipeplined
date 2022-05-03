library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


library work;
use work.common.all;

-- Return the correct orientation of the inputs to start the fft process 
-- Reverse the order of bits
-- 0 => 00 -> 00 => 0 
-- 1 => 01 -> 10 => 2
-- 2 => 10 -> 01 => 1
-- 3 => 11 -> 11 => 3

entity scrambler_module is
port( 
    scrambler_input : in butterfly_type(0 to input_size-1);
    scrambler_output : out butterfly_type(0 to input_size-1)
    );
end entity;

architecture rtl of scrambler_module is
    
    begin 
        main : process(scrambler_input)
        begin 
            for ii in 0 to input_size-1 loop
                scrambler_output(reverse(ii)) <= scrambler_input(ii);
            end loop;
        end process;
        
end architecture;