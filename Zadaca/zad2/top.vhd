library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
	port(
			sig:in std_logic;
			level:in std_logic;
			time_r: out unsigned(31 downto 0);
			bflag:in std_logic;
			eflag:out std_logic;
			fclk:in std_logic
		);
end timer;
architecture behave of timer is
signal time_r_t : unsigned(31 downto 0):=x"00000000";
begin
	process(fclk)
	variable stop_proc :boolean:=false;
	-- detects if there is a change of level 
	variable first:integer:=0;
	variable cnting:boolean:=false;
	begin
		if(rising_edge(fclk)) then
			eflag<='0';
			--Detection of 0 
			if(level='0')then
                if(stop_proc=true)then
					eflag<='1';
				end if;

				if(cnting=true)then
					if(stop_proc=false)then
						time_r_t<=unsigned(time_r_t)+1;
					end if;
				end if;
				if(sig='0' and level='0' )then
					cnting:=true;
					first:=1;
				end if;

				if(sig='1' and level='0' and first=1)then
					stop_proc:=true;
				end if;
			end if;
            -- Detection of 1
			if(level='1')then
				if(stop_proc=true)then
					eflag<='1';
				end if;
				if(cnting=true)then
					if(stop_proc=false)then
						time_r_t<=unsigned(time_r_t)+1;
					end if;
				end if;
				if(sig='1' and level='1' )then
					cnting:=true;
					first:=1;
				end if;
					--detects if there is a change of level from 1 to 0
					--if there is it stops the counting process
					if(sig='0' and level='1' and first=1)then
					stop_proc:=true;
				end if;
			end if;
		time_r<=time_r_t;
		end if;
	end process;
	end behave;

