library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		fclk:in std_logic;
		dir:in std_logic;
		io:inout std_logic_vector(3 downto 0):="0000";
		stpcnt:in integer;
		pos:inout integer:=0;
		cflag:in std_logic;
		speed:in integer
		);
end top;

architecture arctop of top is

begin

process(fclk) is
variable start:boolean:=true;
variable speed_cnt1:integer:=0;
variable speed_cnt2:integer:=0;

variable cnt_pos:integer:=0;
variable cnt_phase:integer:=0;

	begin
		if(rising_edge(fclk))then
			if(start=true)then
				if(dir='0')then
					io<="0101";
				else
					io<="1001";
				end if;
			start:=false;
			end if;

			if(cflag='1')then
				if(dir='0')then -- CW smjer
					if(io="0101")then
						speed_cnt1:=speed_cnt1+1;
						if(speed_cnt1=speed/10)then
							cnt_phase:=cnt_phase+1;
							speed_cnt1:=0;
							io<="0110";

							end if;
					elsif(io="0110")then
						speed_cnt1:=speed_cnt1+1;
						if(speed_cnt1=speed/10)then
							cnt_phase:=cnt_phase+1;
							io<="1010";
							speed_cnt1:=0;
							end if;
					elsif(io="1010")then

						speed_cnt1:=speed_cnt1+1;
						if(speed_cnt1=speed/10)then
							cnt_phase:=cnt_phase+1;
							speed_cnt1:=0;
							io<="1001";
							if(cnt_pos=stpcnt-1)then

							cnt_pos:=0;
							speed_cnt2:=0;

							end if;
							end if;
					elsif(io="1001")then
						speed_cnt1:=speed_cnt1+1;
						if(cnt_phase=3)then
						pos<=pos+1;
						cnt_phase:=0;
						end if;


						if(speed_cnt1=speed/10)then
							io<="0101";
							speed_cnt1:=0;
							cnt_pos:=cnt_pos+1;

							end if;
					end if;
				end if;
				if(dir='1')then
							--CCW smjer
					if(io="1001")then
					speed_cnt2:=speed_cnt2+1;

						if(speed_cnt2=speed/10)then

							speed_cnt2:=0;
							io<="1010";
							end if;
					elsif(io="1010")then
						speed_cnt2:=speed_cnt2+1;
						if(speed_cnt2=speed/10)then

							io<="0110";
							speed_cnt2:=0;
							end if;
					elsif(io="0110")then

						speed_cnt2:=speed_cnt2+1;
						if(speed_cnt2=speed/10)then

							speed_cnt2:=0;
							io<="0101";

							end if;
					elsif(io="0101")then
					speed_cnt2:=speed_cnt2+1;
						if(cnt_pos=stpcnt-1)then

							cnt_pos:=0;
							speed_cnt1:=0;
							end if;

						if(speed_cnt2=speed/10)then

							pos<=pos+1;

							io<="1001";
							speed_cnt2:=0;
							cnt_pos:=cnt_pos+1;
							end if;
					end if;

end if;


					if(pos=360)then
					pos<=0;
					end if;
			end if;
		end if;

	end process;

	end arctop;


