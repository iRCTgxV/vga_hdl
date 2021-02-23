
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is 
port (
	clk_in,reset: in std_logic;
	clkout : out std_logic
);
end clock_div;

architecture main of clock_div is 
	signal count: integer := 1;
	signal tmp: std_logic := '0';

	begin
	process(clk, rst)
		begin
			 if rst = '1' then
				  clk_out <= '0';
			 elsif rising_edge(clk) then
				  clk_out <= not(clk_out);
			 end if;
	end process;
end main;