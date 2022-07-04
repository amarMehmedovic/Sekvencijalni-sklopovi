library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture arctop_tb of top_tb is

component top 
	port(
			dtx: out std_logic;
			drx: in std_logic;
			led: inout std_logic_vector (7 downto 0) := x"00";
			fclk: in std_logic
		);
end component;

signal fclk: std_logic;
signal dtx: std_logic;
signal drx: std_logic:='1';
signal endsim: std_logic:='0';
signal endsim1: std_logic:='0';
signal endsim2: std_logic:='0';

begin
	inst_top: top port map (fclk => fclk, dtx => dtx, drx => drx);
	endsim <= endsim1 or endsim2;

main: 	process
			variable data: unsigned (7 downto 0);
		begin
			
			data := x"46"; -- podatak u opsegu za dodavanje x"20"
			drx <= '0';
			wait for 100 ns;
			for i in 0 to 7 loop 
				drx <= data(i);
				wait for 100 ns;
			end loop;
			wait for 100 ns;
			drx<='1';

			wait for 1200 ns;

			data := x"64"; -- podatak u opsegu za oduzimanje x"20"
			drx <= '0';
			wait for 100 ns;
			for i in 0 to 7 loop
				drx <= data(i);
				wait for 100 ns;
			end loop;
			wait for 100 ns;
			drx<='1';
			wait for 1200 ns;


			data := x"7D"; -- podatak izvan opsega za dodavanje i oduzimanje "
			drx <= '0';
			wait for 100 ns;
			for i in 0 to 7 loop
				drx <= data(i);
				wait for 100 ns;
			end loop;
			wait for 100 ns;
			drx<='1';

			wait for 1200 ns;
			assert false report "simulation ended";
			endsim2 <= '1';
			wait;
		end process;

-- clk generation process for 100 MHz clock
clk:	process
		variable fclk_end: integer:= 4000;
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
				endsim1 <= '1';
				wait;
			end if;
			
			-- stop the clock generation if simulation process completed
			if(endsim = '1') then
				report "fpga clock shutdown";
				wait;
			end if;
				
		end process;	
	
end arctop_tb;














