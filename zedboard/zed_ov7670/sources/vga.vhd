----------------------------------------------------------------------------------
-- engineer: mike field <hamster@snap.net.nz>
-- 
-- description: generate analog 640x480 vga, double-doublescanned from 19200 bytes of ram
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
    port ( 
        clk25           : in    std_logic;
        vga_red         : out   std_logic_vector(3 downto 0);
        vga_green       : out   std_logic_vector(3 downto 0);
        vga_blue        : out   std_logic_vector(3 downto 0);
        vga_hsync       : out   std_logic;
        vga_vsync       : out   std_logic;
        frame_addr      : out   std_logic_vector(18 downto 0);
        frame_pixel     : in    std_logic_vector(11 downto 0)
     );
end vga;

architecture behavioral of vga is
    -- timing constants
    constant hrez           : natural := 640;
    constant hstartsync     : natural := 640+16;
    constant hendsync       : natural := 640+16+96;
    constant hmaxcount      : natural := 800;
     
    constant vrez           : natural := 480;
    constant vstartsync     : natural := 480+10;
    constant vendsync       : natural := 480+10+2;
    constant vmaxcount      : natural := 480+10+2+33;
    
    constant hsync_active   : std_logic := '0';
    constant vsync_active   : std_logic := '0';

    signal hcounter         : unsigned( 9 downto 0) := (others => '0');
    signal vcounter         : unsigned( 9 downto 0) := (others => '0');
    signal address          : unsigned(18 downto 0) := (others => '0');
    signal blank            : std_logic := '1';

begin
    frame_addr <= std_logic_vector(address);
    
   process (clk25) 
   begin
        if rising_edge(clk25) then
            -- count the lines and rows      
            if hcounter = hmaxcount-1 then
                hcounter <= (others => '0');
                if vcounter = vmaxcount-1 then
                    vcounter <= (others => '0');
                else
                    vcounter <= vcounter+1;
                end if;
            else
                hcounter <= hcounter+1;
            end if;

            if blank = '0' then
                vga_red   <= frame_pixel(11 downto 8);
                vga_green <= frame_pixel( 7 downto 4);
                vga_blue  <= frame_pixel( 3 downto 0);
            else
                vga_red   <= (others => '0');
                vga_green <= (others => '0');
                vga_blue  <= (others => '0');
            end if;
    
            if vcounter  >= vrez then
                address <= (others => '0');
                blank <= '1';
            else 
                if hcounter  < 640 then
                    blank <= '0';
                    address <= address+1;
                else
                    blank <= '1';
                end if;
            end if;
    
            -- are we in the hsync pulse? (one has been added to include frame_buffer_latency)
            if hcounter > hstartsync and hcounter <= hendsync then
                vga_hsync <= hsync_active;
            else
                vga_hsync <= not hsync_active;
            end if;

            -- are we in the vsync pulse?
            if vcounter >= vstartsync and vcounter < vendsync then
                vga_vsync <= vsync_active;
            else
                vga_vsync <= not vsync_active;
            end if;
        end if;
    end process;
end behavioral;
