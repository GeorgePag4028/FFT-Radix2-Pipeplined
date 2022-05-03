library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.CONV_SIGNED;
use IEEE.numeric_std.all;
use ieee.math_real.all;

library work;
use work.common.all;

entity fft_tb is 
end entity;

architecture bench of fft_tb is 
    component fft is 
    port(
        clock : in std_logic;
        input_x_time : in butterfly_type(0 to input_size-1);
        output_x_freq : out butterfly_type(0 to input_size-1)
    );
    end component; 

    constant TIME_DELAY : time := 50 ns;
    constant clock_period : time := 10 ns;

    signal clock : std_logic;
    signal input_x_time : butterfly_type(0 to input_size - 1 );
    signal output_x_freq : butterfly_type(0 to input_size -1);

    begin 
        fft_1 : fft
            port map(clock,input_x_time,output_x_freq);
            
        simulation: process
            begin 
                input_x_time <= (others=>(others=>(others=>'0')));
                wait for TIME_DELAY;
                -- input_x_time(0).re <= "0000000000000000";
                -- input_x_time(0).im <= "0000000000000000";
                
                -- input_x_time(1).re <= "1000000000000000";
                -- input_x_time(1).im <= "1000000000000000";
                
                -- input_x_time(2).re <= "0100000000000000";
                -- input_x_time(2).im <= "0100000000000000";
                
                -- input_x_time(3).re <= "0110000000000000";
                -- input_x_time(3).im <= "0110000000000000";
                input_x_time(0).re <= "1011000000000000";
                input_x_time(0).im <= "1001000000000000";
                
                input_x_time(1).re <= "1000100000000000";
                input_x_time(1).im <= "1000000000000000";
                
                input_x_time(2).re <= "0110000000000000";
                input_x_time(2).im <= "0101000000000000";
                
                input_x_time(3).re <= "0110010000000000";
                input_x_time(3).im <= "0110000000000000";
                
                input_x_time(4).re <= "1011000000000000";
                input_x_time(4).im <= "1001000000000000";
                
                input_x_time(5).re <= "1100000000000000";
                input_x_time(5).im <= "1010000000000000";
                
                input_x_time(6).re <= "1110000000000000";
                input_x_time(6).im <= "1101000000000000";
                
                input_x_time(7).re <= "0110000000000000";
                input_x_time(7).im <= "1110000000000000";
               

                wait;
            end process;

        generate_clock : process
            begin
                clock <= '0';
                wait for clock_period/2;
                clock <= '1';
                wait for clock_period/2;
            end process;
end architecture;
