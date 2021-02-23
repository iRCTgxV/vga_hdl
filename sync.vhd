library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync is
port( 
	clk: in std_logic;
	hsync, vsync: out std_logic;
	r,g,b : out std_logic_vector(3 downto 0);
	
	led: out std_logic
);

end sync;

architecture main of sync is
	signal hpos: integer range 0 to 800:=0; --- hpos = 96 + 48 +640 + 16 (clock: 25Mhz)
	signal vpos: integer range 0 to 525:=0; --- vpos = 2 + 33 + 480 + 10
	
	signal blinker : std_logic := '0';
begin 
process(clk)
	begin
		if (rising_edge(clk)) then --- http://martin.hinner.info/vga/timing.html
		
			blinker <= not blinker;
		
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
			r<=(others =>'0');
			g<=(others =>'0');
			b<=(others =>'0');
		else
			r<=(others =>'1');
			g<=(others =>'1');
			b<=(others =>'1');
		end if;
		
		----------------------------------------------------
		-- draw stuff
		
		--adressable range (hmin,hmax) (vmin,vmax) :  (144,783) - (36, 514)
		
		if((hpos > 170 and hpos < 700) and (vpos > 170 and vpos < 700)) then
			r<=(others =>'0');
			g<=(others =>'0');
			b<=(others =>'0');
		end if;
		----------------------------------------------------
		end if;
	end process;
	led <= blinker;
end main;
		
		
		
		
		
		
		
		
		
		
		
		