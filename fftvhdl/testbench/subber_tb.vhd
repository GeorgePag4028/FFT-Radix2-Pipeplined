library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.common.all;

entity subber_tb is
    end entity; 

architecture bench of subber_tb is
    component subber is 
    port(
      clock         : in std_logic;
      input_sub_1 : in complex_type;
      input_sub_2 : in complex_type;
      twiddle       : in complex_type;
      output_sub  : out complex_type
    );
    end component;

constant TIME_DELAY : time := 40 ns;
constant clock_period : time := 10 ns;
signal  input_clock   : std_logic;

signal  input_sub_1 : complex_type;
signal  input_sub_2 : complex_type;
signal  twiddle       : complex_type;
signal  output_sub  : complex_type;

begin
    subber_module1 : subber
        port map(
        clock => input_clock,
        input_sub_1=>input_sub_1,
        input_sub_2=>input_sub_2,
        twiddle=>twiddle,
        output_sub=>output_sub);
    
    simulation : process
        begin 
            input_sub_1 <= (others => (others=>'0'));
            input_sub_2 <= (others => (others=>'0'));
            twiddle <= (others => (others=>'0'));
            
            wait for TIME_DELAY;
            
            input_sub_1.re <= "0000000000000000";
            input_sub_1.im <= "0000000000000000";
            
            input_sub_2.re <= "0100000000000000";
            input_sub_2.im <= "0100000000000000";
            
            twiddle.re       <= "0111111111111111";
            twiddle.im       <= "0000000000000000";

            
            wait for TIME_DELAY;
            
            input_sub_1.re <= "1000000000000000";
            input_sub_1.im <= "1000000000000000";
            
            input_sub_2.re <= "0110000000000000";
            input_sub_2.im <= "0110000000000000";
            
            twiddle.re       <= "0111111111111111";
            twiddle.im       <= "0000000000000000";
         
            
            wait for TIME_DELAY;
            
            input_sub_1.re <= "1000000000000000";
            input_sub_1.im <= "1000000000000000";
            
            input_sub_2.re <= "0110000000000000";
            input_sub_2.im <= "0110000000000000";
            
            twiddle.re       <= "0111111111111111";
            twiddle.im       <= "0000000000000000";
         
            
            wait for TIME_DELAY;
            
            input_sub_1.re <= "0010000000000000";
            input_sub_1.im <= "0010000000000000";
            
            input_sub_2.re <= "1111000000000000";
            input_sub_2.im <= "1111000000000000";
            
            twiddle.re       <= "0111111111111111";
            twiddle.im       <= "0000000000000000";
         
            
            wait for TIME_DELAY;
            
            input_sub_1.re <= "1110000000000000";
            input_sub_1.im <= "1110000000000000";
            
            input_sub_2.re <= "1001000000000000";
            input_sub_2.im <= "1001000000000000";
            
            twiddle.re       <= "0000000000000000";
            twiddle.im       <= "1000000000000000";
         
            
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