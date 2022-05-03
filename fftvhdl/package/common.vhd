library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_signed.all;
use     ieee.std_logic_arith.CONV_SIGNED;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;


package common is
    constant input_size : integer := 8; -- # of complex inputs in fft
    constant input_length_size : integer := 3; -- 2^input_length_size = input_size
    constant x_size : integer :=16; -- length of each number. In this implementation Q1.15 fixed point arithmetic is used.
    
    constant address_width : integer := 4; 
    constant depth     : integer := 16;

    type complex_type is record -- Represent the complex number
        re : std_logic_vector(x_size-1 downto 0);
        im : std_logic_vector(x_size-1 downto 0);
    end record;
    
    type rom is array (0 to (input_size-1)/2) of complex_type; -- Used to store the twiddle factors 
    type butterfly_type is array (natural range <>) of complex_type; 
    type butterfly_stage_type is array(1 to input_length_size) of butterfly_type(0 to input_size-1);
    type fixed_flip_type is array(natural range <>) of butterfly_type(0 to input_size-1);

    
    type ram_type is array(0 to depth-1) of complex_type;

    function rom_tiddle return rom;
    function reverse(reverse_input : integer) return integer; 

    constant rom_of_unity :rom := rom_tiddle; -- contains the twiddle factors

end package;


package body common is 

    -- Return the twiddle factors in a rom constant
    -- Returns cos(-2piK/N) and sin(-2piK/N) for K in [0,N/2]
    -- re => cos
    -- im => sin
    function rom_tiddle return rom is
        variable theta  : real:=0.0;
        variable re_int : real:=0.0;
        variable im_int : real:=0.0;
        -- variable re_int : integer:=0;
        -- variable im_int : integer:=0;
        variable input_size_real : real:=real(input_size);

        variable rom_full : rom;
        begin
        for ii in 0 to (input_size-1)/2 loop
            theta := -2.0*MATH_PI*(real(ii)/input_size_real);
            re_int := COS(theta);
            im_int := SIN(theta);

            rom_full(ii).re := to_slv(to_sfixed(re_int,0,-15));
            rom_full(ii).im := to_slv(to_sfixed(im_int,0,-15));
        end loop;
        
        return rom_full;
    end function;

    -- Return the correct orientation of the inputs to start the fft process 
    -- Reverse the order of bits
    -- 0 => 00 -> 00 => 0 
    -- 1 => 01 -> 10 => 2
    -- 2 => 10 -> 01 => 1
    -- 3 => 11 -> 11 => 3
    function reverse(reverse_input : integer) return integer is 
        variable t1 : std_logic_vector(input_length_size-1 downto 0):= (others=>'0');
        variable t : std_logic_vector(0 to input_length_size-1 ):= (others=>'0');
        variable x : integer := 0;
        begin 
            t1 := std_logic_vector(to_unsigned(reverse_input,input_length_size));
                for i in 0 to input_length_size-1 loop
                    t(i) := t1(i);
                end loop;
            x := to_integer(unsigned(t));
            return x;
    end function;

end package body;