library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adder is
	port(
		  	ina: in std_logic_vector (7 downto 0);
			inb: in std_logic_vector (7 downto 0);
			sum: out std_logic_vector (7 downto 0);
			carry: out std_logic;
			bflag: in std_logic;
			eflag: out std_logic;
			fclk: in  std_logic
		);
end adder;
architecture behave of adder is
signal total:std_logic_vector(8 downto 0):=(others=>'0');
signal ina_t:std_logic_vector(7 downto 0);
signal inb_t:std_logic_vector(7 downto 0);
begin
	process(fclk)
variable stop_proc: boolean:=false;
	begin
		if(rising_edge(fclk))then
			ina_t<=ina;
			inb_t<=inb;
			eflag<='0';

			if(ina=ina_t and inb=inb_t)then
				eflag<='1';
			else
			total <=std_logic_vector(resize(unsigned(ina),9)+resize(unsigned(inb),9));

			end if;

			carry<=total(8);
			if(rising_edge(bflag))then
			carry<='0';
			end if;
			sum<= total(7 downto 0);
	end if;
	end process;
	    

end behave;

