library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is
	
component timer
port	(	
		sig:in std_logic;
		level:in std_logic;
		time_r: out unsigned(31 downto 0);
		bflag:in std_logic;
		eflag:out std_logic;
		fclk:in std_logic);
end component;

signal sig: std_logic:='0';
signal level:std_logic:='1';
signal time_r: unsigned(31 downto 0);
signal bflag: std_logic;
signal eflag: std_logic;
signal fclk:std_logic:='0';
signal endsim1: std_logic:='0';
signal endsim2: std_logic:='0';
signal endsim: std_logic:='0';


begin
	itimer: timer port map(sig=>sig,level=>level,time_r=>time_r,bflag=>bflag,eflag=>eflag,fclk=>fclk);
	endsim<=endsim1 or endsim2;

main: process
	begin
		assert false report "start simulation";
		bflag<='1';
		wait for 10 ns;
		bflag<='0';
		wait for 90 ns;
		--Signal changes to state 1
		sig <='1';
		wait for 50 ns;
		--Signal changes to state 0
		sig<='0';
		wait for 30 ns;
		endsim1<='1';
		assert false report "test completed";
		wait;

	end process;

	clk: process
		variable fclk_end: integer:=30;
		variable fclk_cnt: integer:=0;
	begin
		fclk <= '1';
		wait for 5 ns;
		fclk <= '0';
		wait for 5 ns;
		fclk_cnt:=fclk_cnt+1;
		if(fclk_cnt=fclk_end)then
			report "fpga clock exhausted";
			endsim2<='1';
			wait;
		end if;

		if(endsim ='1') then
			report "fpga clock shutdown";
			wait;
		end if;

	end process;


end arctop_tb;


		

