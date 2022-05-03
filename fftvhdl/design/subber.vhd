library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.common.all;

-- library ieee_proposed;
-- use ieee_proposed.fixed_float_types.all;
-- use ieee_proposed.fixed_pkg.all;
-- use ieee_proposed.float_pkg.all;

-- Return the substraction part of the butterfly
entity subber is 
port(
  clock       : in std_logic;
  input_sub_1 : in complex_type;
  input_sub_2 : in complex_type;
  twiddle     : in complex_type;
  output_sub  : out complex_type
);
end entity;

architecture rtl of subber is 
  -- (1.re + 1.im) - (2.re + 2.im)*(3.re + 3.im)
  attribute USE_DSP : string;
  attribute USE_DSP of  output_sub : signal is "no";
  signal resizeable : std_logic_vector(x_size-2 downto 0) := (others=>'0');
  signal out_subber_re : std_logic_vector(2*x_size-1 downto 0);
  signal out_subber_im : std_logic_vector(2*x_size-1 downto 0);


  begin 
        output_sub.re <= out_subber_re(2*x_size-1 downto x_size);
        output_sub.im <= out_subber_im(2*x_size-1 downto x_size);
      main: process(clock)
      begin 
          if rising_edge(clock) then 
            -- 1.re - 2.re*3.re + 2.im*3.im
            --output_sub.re <= to_slv(to_sfixed(input_sub_1.re,0,-15) - to_sfixed(input_sub_2.re,0,-15) * to_sfixed(twiddle.re,0,-15) + to_sfixed(input_sub_2.im,0,-15)*to_sfixed(twiddle.im,0,-15))(2*x_size-1 downto x_size);
            out_subber_re <= std_logic_vector(resize(signed(input_sub_1.re & resizeable),2*x_size) - signed(input_sub_2.re)*signed(twiddle.re) + signed(input_sub_2.im)* signed(twiddle.im));
  
            -- 1.im - 2.re*3.im - 2.im*3.re
            --output_sub.im <= to_slv(to_sfixed(input_sub_1.im,0,-15) - to_sfixed(input_sub_2.re,0,-15) * to_sfixed(twiddle.im,0,-15) - to_sfixed(input_sub_2.im,0,-15)*to_sfixed(twiddle.re,0,-15))(2*x_size-1 downto x_size);
            out_subber_im <= std_logic_vector(resize(signed(input_sub_1.im & resizeable),2*x_size) - signed(input_sub_2.re)*signed(twiddle.im) - signed(input_sub_2.im)* signed(twiddle.re));
        end if;
      end process;

end architecture;