library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
	port (led: out std_logic := '0';
		  dtx: out std_logic;
		  par: inout unsigned(1 downto 0):="00";
		  fclk: in  std_logic);
end top;

architecture arctop of top is
signal data: unsigned (7 downto 0) := x"28";
signal tled: std_logic := '0';

begin
	process (fclk)
		variable state:integer:=0;
		variable pause:integer:=9;
		variable cnt:integer:=0;
		variable idx:integer:=0;
		variable cnter_parity:integer:=0;
		variable stop_idle:boolean:=false;
		variable baudrate:integer:=6; --> 921600 Bauds -> 54 clocks of 50MHz 108->100MHz
		--variable baudrate:integer:=434;				--> 115200 Bauds -> 434 clocks of 50MHz 
		
		begin
			if fclk'event and fclk='1' then
				if(stop_idle=false)then
				dtx<='1';
					end if;
							cnt := cnt + 1;
				if(state = 0) then						-- generate start bit
					if(cnt = pause) then				-- ? can we remove this and unify?
						cnt := 0;
						state := state + 1;
						pause := baudrate; 
						-- start bit
						dtx <= '0';
						stop_idle:=true;
						tled <= tled  xor '1';
						led <= tled;
					end if;
				elsif(state <= 8) then					-- data
					if(cnt = pause) then
						cnt := 0;
						state := state + 1;
						pause := baudrate;
						
						-- data
						dtx <= data(idx);
						if(data(idx)='1')then
							cnter_parity:=cnter_parity+1;
						end if;
						idx := idx + 1;
					end if;
				elsif(state = 9) then					--parity
					if(cnt=pause)then
						cnt:=0;
						state:=state+1;	
						pause:=baudrate;
						if(cnter_parity mod 2)=0 then
						par<="01";
						else
						par<="10";
					end if;
				dtx<='1';
				end if;
				elsif(state=10)then
					if(cnt = pause) then
						cnt := 0;
						state := state + 1;
						pause := baudrate;
						
						-- stop bit
						dtx <= '1';
					end if;	
				else
					if(cnt = pause) then
						cnt := 0;
						state := 0;
						pause := 9;
						dtx <= '1';
						idx:=0;
						data <= data - x"01";
						par<="00";
						cnter_parity:=0;
						tled<='0';
						stop_idle:=false;
						if(to_integer(data) < 5) then
							data <= x"28";
						end if;
					end if;	
				end if;
			end if;
	end process;	

end arctop;



