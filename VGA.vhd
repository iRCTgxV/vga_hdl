library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.r_edge_d_flip_sync_reset; -- for dividing 50Mhz clock to 25Mhz clock

entity vga is
port(
	clk: in std_logic;
	vga_hs, vga_vs: out std_logic;
	vga_r,vga_g,vga_b: out std_logic_vector(3 downto 0);
	led, led2 : out std_logic;
	vga_clk : out std_logic
);
end vga;



architecture main of vga is
	signal hpos: integer range 0 to 800:=0; --- hpos = 96 + 48 +640 + 16 (clock: 25Mhz)
	signal vpos: integer range 0 to 525:=0; --- vpos = 2 + 33 + 480 + 10
	
	signal hsync, vsync: std_logic;
	signal blinker : std_logic := '1';
	
	signal blinker_clk, blinker_clk2: natural range 0 to 50000000 := 0;
	signal blinker1, blinker2 : std_logic := '0';
	
	signal sg_clk_out : std_logic;
	
	
	component r_edge_d_flip_sync_reset is 
		port(
			clk_in: in std_logic;
			clk_out: out std_logic
		);
	end component;

	begin 
	
		flip_flop: r_edge_d_flip_sync_reset
		port map(
			clk_in => clk,
			clk_out => sg_clk_out
		);
	process(sg_clk_out,blinker_clk,blinker_clk2)
		begin
			if(rising_edge(clk)) then
				blinker_clk <= blinker_clk +1;
				if(blinker_clk >= 50000000) then
					blinker_clk <= 0;
					blinker1 <= not blinker1;
				end if;
			end if;
		
			if (rising_edge(sg_clk_out)) then --- http://martin.hinner.info/vga/timing.html
				blinker_clk2 <= blinker_clk2 +1;
				if(blinker_clk2 >= 25000000) then
					blinker_clk2 <= 0;
					blinker2 <= not blinker2;
				end if;
			
								
			------------------ Scanning screen ---------------------------
				if(hpos < 800) then --move pixel by pixel on line
					hpos <= hpos +1;
				else 
					hpos <= 0;
					if(vpos < 525) then --move one line down when horizontal finished
						vpos <= vpos + 1;
					else
						vpos <= 0;		
					end if;
				end if;
				
			-------------------------------------------
				  
				-- hsync 
				if(hpos < 96) then
					hsync <= '1';
					else 
						hsync <= '0';
				end if;
			
			---------------------------------------------------
			
				--vsync
				if(vpos < 2) then
					vsync <= '1';
					else
					vsync <= '0';
				end if;
			
			
			---------------------------------------------------
			
			--RGB off when not in color adressable range
			
				if((hpos >143 and hpos < 784) or (vpos > 35 and vpos < 515))then
					vga_r<=(others =>'0');
					vga_g<=(others =>'0');
					vga_b<=(others =>'0');
				else
					vga_r<=(others =>'1');
					vga_g<=(others =>'1');
					vga_b<=(others =>'1');
				end if;
			
			----------------------------------------------------
			-- draw stuff
			
			--adressable range (hmin,hmax) (vmin,vmax) :  (144,783) - (36, 514)
			
				if((hpos > 170 and hpos < 700) and (vpos > 170 and vpos < 700)) then
					vga_r<=(others =>'0');
					vga_g<=(others =>'0');
					vga_b<=(others =>'0');
				end if;
			----------------------------------------------------
			
			

				
				
			end if;
	end process;
	led <= blinker1;
	led2 <= blinker2;
	vga_hs <= hsync;
	vga_vs <= vsync;
	vga_clk <= sg_clk_out;
end main;