library ieee;

use ieee.std_logic_1164.all;

entity r_edge_d_flip_sync_reset is
port(
	
	clk_in: in std_logic;
	clk_out: out std_logic
);

end r_edge_d_flip_sync_reset;

architecture behavorial of r_edge_d_flip_sync_reset is
	signal count: integer := 1;
	signal tmp: std_logic := '0';
	begin
	process(clk_in,count)
		begin 
			if(rising_edge(clk_in)) then
				count <= count + 1;
				if(count = 2) then
					count <= 1;
					tmp <= not tmp;
				end if;
			end if;
	end process;
	clk_out <= tmp;
end behavorial;