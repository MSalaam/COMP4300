use work.bv_arithmetic.all;
use work.dlx_types.all; 

entity dlx_register is
	generic(prop_delay: Time := 5 ns);
	port(in_val: in dlx_word; clock: in bit; out_val: out dlx_word
	);
end entity dlx_register;

architecture behavior01 of dlx_register is
begin
	dlx_register: process(in_val, clock) is
	begin 
		if (clock = '1') then 
			out_val <= in_val after prop_delay;
		end if;
	end process dlx_register;
end architecture behavior01;

use work.bv_arithmetic.all;
use work.dlx_types.all;

entity regfile is
	generic( prop_delay: Time := 5 ns);
	port (
		read_notwrite, clock 	: in bit;
		regA,rebB		: in register_index;
		data_in			: in dlx_word;
		dataA_out,dataB_out	: out dlx_word
	);
end entity regfile;


architecture behavior02 of regfile is
	type arr is array (0 to 31) of dlx_word;
	signal arr2 : arr;

begin
	reg: process(read_notwrite, clock, regA, rebB, data_in) is
	begin
		if (clock = '1') then
			if (read_notwrite = '1') then
				dataA_out <= arr2(bv_to_integer(regA)) after prop_delay;
				dataB_out <= arr2(bv_to_integer(rebB)) after prop_delay;
			else
				arr2(bv_to_integer(regA)) <= data_in after prop_delay;
			end if;
		end if;
	end process reg;
end architecture behavior02;

use work.bv_arithmetic.all;
use work.dlx_types.all;

entity mux is
	generic(prop_delay : Time := 5 ns);
	port (
		input_1,input_0 : in dlx_word;
		which: in bit;
		output: out dlx_word
	);
end entity mux;

architecture behavior03 of mux is
begin
	process(input_1,input_0,which)
	begin
		if which = '0' then
			output <= input_0 after prop_delay;
		else
			output <= input_1 after prop_delay;
		end if;
	end process;
end architecture behavior03;

use work.bv_arithmetic.all;
use work.dlx_types.all;

entity add4 is
	generic(prop_delay: time:= 5 ns);
	port(input: in dlx_word;
		clock: in bit;
		output: out dlx_word
		);
end entity add4;

architecture behavior04 of add4 is
begin
	process(input, clock) is
	variable newpcplus: dlx_word;
	variable error: boolean;
	begin
		if clock 'event and clock = '1' then
			bv_addu(input,
				"00000000000000000000000000000100",
				newpcplus,
				error);
				output <= newpcplus after prop_delay;
		end if;
	end process;
end architecture behavior04;


use work.bv_arithmetic.all;
use work.dlx_types.all;

entity sign_extend is
	generic (prop_delay: Time := 5ns);
	port (input: in half_word; output: out dlx_word
	);
end entity sign_extend;

architecture behavior05 of sign_extend is
begin
	sign_extend: process(input) is
	begin 	
		if (input(12) = '1') then
			output <= "1111111111111111" & input after prop_delay;
		else
			output <= "0000000000000000" & input after prop_delay;
		end if;
	end process sign_extend;
end architecture behavior05;