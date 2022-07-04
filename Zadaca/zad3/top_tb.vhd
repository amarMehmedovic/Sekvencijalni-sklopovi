library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is
	component top
	port (led: out std_logic := '0';
		  dtx: out std_logic;
		  par: inout unsigned(1 downto 0):="00";
		  fclk: in  std_logic);
	end component;


signal fclk:std_logic:='0';
signal led:std_logic:='0';
signal dtx:std_logic;
signal endsim:std_logic:='0';
signal par:unsigned(1 downto 0):="00";

begin 
	uart: top port map(fclk=>fclk,led=>led,dtx=>dtx,par=>par);

	clk: process
		variable fclk_end: integer:=200;
		variable fclk_cnt: integer:=0;
	begin
		fclk<='1';
		wait for 5 ns;
		fclk <='0';
		wait for 5 ns;
		fclk_cnt:=fclk_cnt+1;
		if(fclk_cnt=fclk_end)then
			report "fpga clock exhausted";
			endsim<='1';
			wait;
		end if;

		if(endsim='1')then
			report "fpga clock shutdown";
			wait;
		end if;
	end process;
end arctop_tb;
