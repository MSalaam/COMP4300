-- dlx_datapath.vhd

package dlx_types is
  subtype dlx_word is bit_vector(31 downto 0); 
  subtype half_word is bit_vector(15 downto 0); 
  subtype byte is bit_vector(7 downto 0); 

  subtype alu_operation_code is bit_vector(3 downto 0); 
  subtype error_code is bit_vector(3 downto 0); 
  subtype register_index is bit_vector(4 downto 0);

  subtype opcode_type is bit_vector(5 downto 0);
  subtype offset26 is bit_vector(25 downto 0);
  subtype func_code is bit_vector(5 downto 0);
end package dlx_types; 

use work.dlx_types.all; 
use work.bv_arithmetic.all;  

entity alu is 
    generic(prop_delay: Time := 5 ns);
    port(operand1, operand2: in dlx_word; operation: in alu_operation_code; 
          signed: in bit; result: out dlx_word; error: out error_code); 
end entity alu; 

architecture behaviour of alu is
	signal overFlow: boolean;
begin
	process(operand1, operand2, operation, signed)
		variable oper1: dlx_word;
		variable oper2: dlx_word;
		variable result_x: dlx_word;
		variable newOverFlow: boolean;
	begin
		oper1 := operand1;
		oper2 := operand2;

		-- Addition
		if(operation = "0000") then
			if(signed = '0') then
				bv_addu(oper1, oper2, result_x, newOverFlow);
			else
				bv_add(oper1, oper2, result_x, newOverFlow);
			end if;
		-- Subtraction
		elsif(operation = "0001") then
			if(signed = '0') then
				bv_subu(oper1, oper2, result_x, newOverFlow);
			else
				bv_sub(oper1, oper2, result_x, newOverFlow);
			end if;
		-- AND
		elsif(operation = "0010") then
			result_x := oper1 and oper2;
			newOverFlow := false;
		-- OR
		elsif(operation = "0011") then
			result_x := oper1 or oper2;
			newOverFlow := false;
		-- XOR
		elsif(operation = "0100") then
			result_x := oper1 xor oper2;
			newOverFlow := false;
		-- "<"
		elsif(operation = "1011") then
			if( bv_lt(oper1,oper2) = true ) then
				result_x := X"00000001";
			else
				result_x := X"00000000";
			end if;
		-- Multiplication
		elsif(operation = "1110") then
			if(signed = '0') then
				bv_multu(oper1, oper2, result_x, newOverFlow);
			else
				bv_mult(oper1, oper2, result_x, newOverFlow);
			end if;
		-- Default case
		else
			result_x := (others => '0');
			newOverFlow := false;
		end if;

		result <= result_x after prop_delay;

		--assign to the error code
		if( newOverFlow = true ) then
			error <= "0001" after prop_delay;
		else
			error <= "0000" after prop_delay;
		end if;

	end process;
end architecture behaviour;

use work.dlx_types.all;
use work.bv_arithmetic.all;


entity mips_zero is
  generic(prop_delay: Time := 5 ns);
  port (
    input  : in  dlx_word;
    output : out bit);
end mips_zero;
architecture behaviour of mips_zero is
begin
	combinational: process(input)
	begin
		if(input = "00000000000000000000000000000000") then
			output <= '1' after prop_delay;
		else
			output <= '0' after prop_delay;
		end if;
	end process combinational;
end architecture behaviour;

use work.dlx_types.all; 

entity mips_register is
    generic(prop_delay: Time := 5 ns);
    port(in_val: in dlx_word; clock: in bit; out_val: out dlx_word);
end entity mips_register;
library work;
use work.dlx_types.all;
use work.bv_arithmetic.all;

architecture behaviour of mips_register is
begin
	sequential: process(in_val,clock)
	begin
		if( clock = '1' ) then
			out_val <= in_val after prop_delay;
		end if;
	end process;
end architecture behaviour;

use work.dlx_types.all; 

entity mips_bit_register is
    generic(prop_delay: Time := 5 ns);
    port(in_val: in bit; clock: in bit; out_val: out bit);
end entity mips_bit_register;

architecture behaviour of mips_bit_register is
begin
	sequential: process(in_val,clock)
	begin
		if( clock = '1' ) then
			out_val <= in_val after prop_delay;
		end if;
	end process;
end architecture behaviour;

use work.dlx_types.all; 

entity mux is
    generic(prop_delay: Time := 5 ns);
    port (input_1,input_0 : in dlx_word; which: in bit; output: out dlx_word);
end entity mux;

use work.dlx_types.all;
use work.bv_arithmetic.all;

architecture behaviour of mux is
begin
	combinational: process(input_1, input_0, which)
	begin
		if(which = '0' ) then
			output <= input_0 after prop_delay;
		else
			output <= input_1 after prop_delay;
		end if;
	end process;
end architecture behaviour;

use work.dlx_types.all;
use work.bv_arithmetic.all;

entity index_mux is
    generic(prop_delay: Time := 5 ns);
    port (input_1,input_0 : in register_index; which: in bit; output: out register_index);
end entity index_mux;

architecture behaviour of index_mux is
begin
	combinational: process(input_1, input_0, which)
	begin
		if(which = '0' ) then
			output <= input_0 after prop_delay;
		else
			output <= input_1 after prop_delay;
		end if;
	end process;
end architecture behaviour;

use work.dlx_types.all;

entity sign_extend is
    generic(prop_delay: Time := 5 ns);
    port (input: in half_word; signed: in bit; output: out dlx_word);
end entity sign_extend;

use work.dlx_types.all;
use work.bv_arithmetic.all;

architecture behaviour of sign_extend is
	  signal x: half_word;
  begin
	  Combinational: process(input,signed) is
		begin
			if( signed = '0' ) then
				x <= (others => '0');	
			else
				x <= (others => input(input'left));
			end if;

			output <= x & input after prop_delay;
		end process;
end architecture behaviour;

use work.dlx_types.all; 
use work.bv_arithmetic.all; 

entity add4 is
    generic(prop_delay: Time := 5 ns);
    port (input: in dlx_word; output: out dlx_word);
end entity add4;

use work.dlx_types.all;
use work.bv_arithmetic.all;

architecture behaviour of add4 is
begin
	combinational: process(input) is
		variable y: std_logic_vector(input'range);
		variable x: integer;
		variable z: std_logic_vector(input'range);
	begin
		for i in input'range loop
			if( input(i) = '1') then
				y(i) := '1';
			else
				y(i) := '0';
			end if;
		end loop;
		x:= (conv_integer(y) + 4);
		z:= std_logic_vector(to_unsigned(x,z'length));

		for i in z'range loop
			if( z(i) = '1') then
				output(i) <= '1' after prop_delay;
			else
				output(i) <= '0' after prop_delay;
			end if;
		end loop;
	end process;
end architecture behaviour;

use work.dlx_types.all;
use work.bv_arithmetic.all;  

entity regfile is
    generic(prop_delay: Time := 5 ns);
    port (read_notwrite,clock : in bit; 
          regA,regB: in register_index; 
	   data_in: in  dlx_word; 
	   dataA_out,dataB_out: out dlx_word
	   );
end entity regfile; 

use work.dlx_types.all;
use work.bv_arithmetic.all;

architecture behaviour of regfile is
	type MEMORY is array(0 to (2**(register_index'length))) of dlx_word;
	signal MEM: MEMORY;
begin
	process(read_notwrite,clock,regA,regB)
		variable std_lv_a: std_logic_vector(regA'range);
		variable std_lv_b: std_logic_vector(regB'range);
		variable address_a: integer range 0 to (2**(register_index'length)-1);
		variable address_b: integer range 0 to (2**(register_index'length)-1);
	begin
		for i in regA'range loop
			if( regA(i) = '1') then
				std_lv_a(i) := '1';
			else
				std_lv_a(i) := '0';
			end if;
		end loop;


		for i in regB'range loop
			if( regB(i) = '1') then
				std_lv_b(i) := '1';
			else
				std_lv_b(i) := '0';
			end if;
		end loop;

		address_a := conv_integer(std_lv_a);
		address_b := conv_integer(std_lv_b);

		if( read_notwrite = '1' ) then
			dataA_out <= MEM(address_a) after prop_delay;
			dataB_out <= MEM(address_b) after prop_delay;
		elsif( clock = '1') then
			MEM(address_a) <= data_in after prop_delay;
		end if;
	end process;
end architecture behaviour;

use work.dlx_types.all;
use work.bv_arithmetic.all;

entity DM is
  generic(prop_delay: Time := 5 ns);
  port (
    address : in dlx_word;
    readnotwrite: in bit; 
    data_out : out dlx_word;
    data_in: in dlx_word; 
    clock: in bit); 
end DM;

architecture behaviour of DM is
type memtype is array (0 to 1024) of dlx_word;
signal data_memory : memtype;
signal init: bit :='0';
begin  -- behaviour

  DM_behav: process(address,clock) is
    --type memtype is array (0 to 1024) of dlx_word;
    --variable data_memory : memtype;
  begin
    if(init = '0' ) then
      -- fill this in by hand to put some values in there
      data_memory(1023) <= B"00000101010101010101010101010101";
      data_memory(0) <= B"00000000000000000000000000000001";
      data_memory(1) <= B"00000000000000000000000000000010";
      init <= '1';
    end if;
    if clock'event and clock = '1' then
      if readnotwrite = '1' then
        -- do a read
        data_out <= data_memory(bv_to_natural(address)/4);
      else
        -- do a write
        data_memory(bv_to_natural(address)/4) <= data_in; 
      end if;
    end if;


  end process DM_behav; 

end behaviour;

use work.dlx_types.all;
use work.bv_arithmetic.all;

entity IM is
  generic(prop_delay: Time := 5 ns);
  port (
    address : in dlx_word;
    instruction : out dlx_word;
    clock: in bit); 
end IM;

architecture behaviour of IM is

begin  -- behaviour

  IM_behav: process(address,clock) is
    type memtype is array (0 to 1024) of dlx_word;
    variable instr_memory : memtype;                   
  begin
    -- fill this in by hand to put some values in there
    -- first instr is 'LW R1,4092(R0)' 
    instr_memory(0) := B"10001100000000010000111111111100"; 
    -- next instr is 'ADD R1,R1,R2'
    instr_memory(1) := B"00000000001000010001000000100000"; 
    -- next instr is SW R2,8(R0)'
    instr_memory(2) := B"10101100000000100000000000001000";
    -- next instr is LW R3,8(R0)'
    instr_memory(3) := B"10001100000000110000000000001000"; 
    if clock'event and clock = '1' then
        -- do a read
        instruction <= instr_memory(bv_to_natural(address)/4);
    end if;
  end process IM_behav; 

end behaviour;