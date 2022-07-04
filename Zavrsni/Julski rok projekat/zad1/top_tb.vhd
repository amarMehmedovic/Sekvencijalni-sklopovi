library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

	component top is
		port(
		fclk:in std_logic;
		dir:in std_logic;
		io: inout std_logic_vector (3 downto 0):="0000";
		stpcnt:in integer;
		pos:inout integer:=0;
		cflag:in std_logic;
		speed:in integer
			);
	end component;

signal fclk:std_logic;
-- '0' CW, '1' CCW
signal io:std_logic_vector(3 downto 0);
signal dir:std_logic:='0';
signal stpcnt: integer:=0;
signal pos:integer;
signal cflag:std_logic:='0';
signal speed:integer:=1000;

signal endsim: std_logic := '0';
signal endsim1: std_logic := '0';
signal endsim2: std_logic := '0';

begin
	top_map: top port map(fclk=>fclk,dir=>dir,stpcnt=>stpcnt,pos=>pos,cflag=>cflag,speed=>speed,io=>io);
    endsim <= endsim1 or endsim2;

	main:process

	begin 
		assert false report "start simulation";
		stpcnt<=23; --CW smjer 23 koraka 
		cflag<='1';
		wait for 92 us;
		cflag<='0';
		stpcnt<=0;
		wait for 10 us; --pauza 10 us
		speed<=200; --CCW smjer 10 koraka
		stpcnt<=10;
		cflag<='1';
		dir<='1';
		wait for 8 us;
		cflag<='0';
		stpcnt<=0;
		wait for 2 us;
		endsim1<='1';
assert false report "test completed";
		wait;
	end process;


	-- clk generation process for 100 MHz clock
clk:	process
		variable fclk_end: integer:= 13000;
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
