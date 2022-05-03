library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common.all;

entity adder_tb is
    end entity; 

architecture bench of adder_tb is
    component adder is 
    port(
      clock         : in std_logic;
      input_adder_1 : in complex_type;
      input_adder_2 : in complex_type;
      twiddle       : in complex_type;
      output_adder  : out complex_type
    );
    end component;

constant TIME_DELAY : time := 40 ns;
constant clock_period : time := 10 ns;
signal  input_clock   : std_logic;

signal  input_adder_1 : complex_type;
signal  input_adder_2 : complex_type;
signal  twiddle       : complex_type;
signal  output_adder  : complex_type;

begin
    adder_module1 : adder
        port map(
        clock => input_clock,
        input_adder_1=>input_adder_1,
        input_adder_2=>input_adder_2,
        twiddle=>twiddle,
        output_adder=>output_adder);
    
    simulation : process
        begin 
            input_adder_1.re <= (others=>'0');
            input_adder_2.re <= (others=>'0');
            twiddle.re <= (others=>'0');
            
            input_adder_1.im <= (others=>'0');
            input_adder_2.im <= (others=>'0');
            twiddle.im <= (others=>'0');
            
             wait for TIME_DELAY;
            
             input_adder_1.re <= "0000000000000000";
             input_adder_1.im <= "0000000000000000";
            
             input_adder_2.re <= "0100000000000000";
             input_adder_2.im <= "0100000000000000";
            
             twiddle.re       <= "0111111111111111";
             twiddle.im      <= "0000000000000000";

            
             wait for TIME_DELAY;
            
             input_adder_1.re <= "1000000000000000";
             input_adder_1.im <= "1000000000000000";
            
             input_adder_2.re <= "0110000000000000";
             input_adder_2.im <= "0110000000000000";
            
             twiddle.re       <= "0111111111111111";
             twiddle.im       <= "0000000000000000";
         
            
             wait for TIME_DELAY;
            
             input_adder_1.re <= "1000000000000000";
             input_adder_1.im <= "1000000000000000";
            
             input_adder_2.re <= "0110000000000000";
             input_adder_2.im <= "0110000000000000";
            
             twiddle.re       <= "0111111111111111";
             twiddle.im      <= "0000000000000000";
         
            
             wait for TIME_DELAY;
            
             input_adder_1.re <= "0010000000000000";
             input_adder_1.im <= "0010000000000000";
            
             input_adder_2.re <= "1111000000000000";
             input_adder_2.im <= "1111000000000000";
            
             twiddle.re       <= "0111111111111111";
             twiddle.im       <= "0000000000000000";
         
            
             wait for TIME_DELAY;
            
             input_adder_1.re <= "1110000000000000";
             input_adder_1.im <= "1110000000000000";
            
             input_adder_2.re <= "1001000000000000";
             input_adder_2.im <= "1001000000000000";
            
             twiddle.re       <= "0000000000000000";
             twiddle.im      <= "1000000000000000";
         
            
            wait for TIME_DELAY;
         
            wait;
        end process;
    
    generate_clock : process
        begin
            input_clock <= '0';
            wait for clock_period/2;
            input_clock <= '1';
            wait for clock_period/2;
        end process;
end architecture;