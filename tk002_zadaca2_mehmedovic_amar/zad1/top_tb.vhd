library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component adder 
	port(
			ina: in std_logic_vector(7 downto 0);
			inb: in std_logic_vector (7 downto 0);
			sum: out std_logic_vector (7 downto 0);
			carry: out std_logic;
			bflag: in std_logic;
			eflag: out std_logic;
			fclk: in  std_logic);
end component;

signal ina: std_logic_vector (7 downto 0):=x"00";
signal inb: std_logic_vector (7 downto 0):=x"00";
signal sum: std_logic_vector (7 downto 0);
signal carry: std_logic;
signal bflag: std_logic;
signal eflag: std_logic;
signal fclk: std_logic:='0';
signal endsim1: std_logic:='0';
signal endsim2: std_logic:='0';
signal endsim: std_logic:='0';


begin
	iadder: adder port map (ina=>ina, inb=>inb, sum=>sum, carry=>carry, bflag=>bflag, eflag=>eflag, fclk=>fclk);	
	endsim <= endsim1 or endsim2;

main: process

	begin
		assert false report "start simulation";
		ina <= x"1A";
		inb <= x"E1";
		bflag <= '1';
		wait for 10 ns;
		bflag <= '0';
		wait for 10 ns;
		
		ina <= x"F7";
		inb <= x"5A";
		bflag <= '1';
		wait for 10 ns;
		bflag <= '0';
		wait for 10 ns;
		
		ina <= x"FF";
		inb <= x"00";
		bflag <= '1';
		wait for 10 ns;
		bflag <= '0';
		wait for 10 ns;
		
		
		endsim1 <= '1';	
		assert false report "test completed";
		wait;
		
	end process;


-- clk generation process for 100 MHz clock
clk:	process
		variable fclk_end: integer:= 20; 
		variable fclk_cnt: integer:= 0;
		
		begin
			fclk <= '1';
			wait for 5 ns;
			fclk <= '0';
			wait for 5 ns;
			
			fclk_cnt := fclk_cnt + 1;
			-- stop clk generation if the simulation process hangs
			if(fclk_cnt = fclk_end) then
				report "fpga clock exhausted";
				endsim2 <= '1';
				wait;
			end if;
			
			-- stop the clock generation if simulation process completed
			if(endsim = '1') then
				report "fpga clock shutdown";
				wait;
			end if;
				
		end process;	
	
end arctop_tb;














