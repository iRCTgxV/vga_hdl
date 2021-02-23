	component clock_108Mhz is
		port (
			clk_in_clk         : in  std_logic := 'X'; -- clk
			rst_reset          : in  std_logic := 'X'; -- reset
			clk_out_108mhz_clk : out std_logic         -- clk
		);
	end component clock_108Mhz;

	u0 : component clock_108Mhz
		port map (
			clk_in_clk         => CONNECTED_TO_clk_in_clk,         --         clk_in.clk
			rst_reset          => CONNECTED_TO_rst_reset,          --            rst.reset
			clk_out_108mhz_clk => CONNECTED_TO_clk_out_108mhz_clk  -- clk_out_108mhz.clk
		);

