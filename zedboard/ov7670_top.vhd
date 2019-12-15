----------------------------------------------------------------------------------
-- engineer: mike field <hamster@snap.net.nz>
-- 
-- description: top level for the ov7670 camera project.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity ov7670_top is
    port ( 
        clk100       : in    std_logic;
        ov7670_sioc  : out   std_logic;
        ov7670_siod  : inout std_logic;
        ov7670_reset : out   std_logic;
        ov7670_pwdn  : out   std_logic;
        ov7670_vsync : in    std_logic;
        ov7670_href  : in    std_logic;
        ov7670_pclk  : in    std_logic;
        ov7670_xclk  : out   std_logic;
        ov7670_d     : in    std_logic_vector(7 downto 0);

        led          : out   std_logic_vector(7 downto 0);

        vga_red      : out   std_logic_vector(3 downto 0);
        vga_green    : out   std_logic_vector(3 downto 0);
        vga_blue     : out   std_logic_vector(3 downto 0);
        vga_hsync    : out   std_logic;
        vga_vsync    : out   std_logic;
        
        btn_center   : in    std_logic;
        btn_down     : in    std_logic;
        btn_left     : in    std_logic;
        btn_right    : in    std_logic;
        btn_up       : in    std_logic
     );
end ov7670_top;

architecture behavioral of ov7670_top is

    component debounce
        port (
            clk : in    std_logic;
            i   : in    std_logic;          
            o   : out   std_logic
        );
    end component;

    component clocking
        port (
            -- clock in ports
            clk_100         : in     std_logic;
            -- clock out ports
            clk_50          : out    std_logic;
            clk_25          : out    std_logic
        );
    end component;

    component ov7670_controller
        port(
            clk             : in    std_logic;    
            resend          : in    std_logic;    
            config_finished : out   std_logic;
            siod_out        : out   std_logic;      
            siod_en         : out   std_logic;      
            siod_in         : in    std_logic;      
            sioc            : out   std_logic;
            reset           : out   std_logic;
            pwdn            : out   std_logic;
            xclk            : out   std_logic
        );
    end component;

    -- component sdpram
    --     generic (
    --         clocking_mode   : string    := "independent_clock"; -- common_clock, independent_clock
    --         addr_width      : integer   := 12;                  -- 1 to 20
    --         data_width      : integer   := 8
    --     );
    --     port (
    --         -- Write port
    --         clka  : in  std_logic;
    --         rsta  : in  std_logic;
    --         wea   : in  std_logic_vector(0 downto 0);
    --         addra : in  std_logic_vector(addr_width-1 downto 0);
    --         dina  : in  std_logic_vector(data_width-1 downto 0);
    -- 
    --         -- Read port
    --         clkb  : in  std_logic;
    --         rstb  : in  std_logic;
    --         addrb : in  std_logic_vector(addr_width-1 downto 0);
    --         doutb : out std_logic_vector(data_width-1 downto 0)
    --     );
    -- end component sdpram;
    component blk_mem_gen_0
        port (
            -- Write port
            clka  : in  std_logic;
            wea   : in  std_logic_vector(0 downto 0);
            addra : in  std_logic_vector(18 downto 0);
            dina  : in  std_logic_vector(11 downto 0);
    
            -- Read port
            clkb  : in  std_logic;
            addrb : in  std_logic_vector(18 downto 0);
            doutb : out std_logic_vector(11 downto 0)
        );
    end component;

    component ov7670_capture
        port(
            pclk : in std_logic;
            vsync : in std_logic;
            href  : in std_logic;
            d     : in std_logic_vector(7 downto 0);          
            addr  : out std_logic_vector(18 downto 0);
            dout  : out std_logic_vector(11 downto 0);
            we    : out std_logic
        );
    end component;


    component vga
        port(
            clk25     : in std_logic;
            vga_red   : out std_logic_vector(3 downto 0);
            vga_green : out std_logic_vector(3 downto 0);
            vga_blue  : out std_logic_vector(3 downto 0);
            vga_hsync : out std_logic;
            vga_vsync : out std_logic;
            
            frame_addr  : out std_logic_vector(18 downto 0);
            frame_pixel : in  std_logic_vector(11 downto 0)         
        );
    end component;
    
    signal frame_addr      : std_logic_vector(18 downto 0);
    signal frame_pixel     : std_logic_vector(11 downto 0);

    signal capture_addr    : std_logic_vector(18 downto 0);
    signal capture_data    : std_logic_vector(11 downto 0);
    signal capture_we      : std_logic_vector(0 downto 0);
    signal resend          : std_logic;
    signal config_finished : std_logic;
    
    signal clk_feedback  : std_logic;
    signal clk50u        : std_logic;
    signal clk50         : std_logic;
    signal clk25u        : std_logic;
    signal clk25         : std_logic;
    signal buffered_pclk : std_logic;

    signal siod_out     : std_logic;
    signal siod_en      : std_logic;
    signal siod_in      : std_logic;
    
begin
  
    btn_debounce: debounce 
    port map (
        clk => clk50,
        i   => btn_up,
        o   => resend
    );

    inst_vga: vga 
    port map (
        clk25       => clk25,
        vga_red     => vga_red,
        vga_green   => vga_green,
        vga_blue    => vga_blue,
        vga_hsync   => vga_hsync,
        vga_vsync   => vga_vsync,
        frame_addr  => frame_addr,
        frame_pixel => frame_pixel
    );

    -- sdpram_inst : sdpram
    --     generic map (
    --         clocking_mode   => "independent_clock", -- common_clock, independent_clock
    --         addr_width      => capture_addr'length, -- 1 to 20
    --         data_width      => capture_data'length
    --     ) 
    blk_mem : blk_mem_gen_0
        port map (
            -- Write port
            clka  => ov7670_pclk,
            -- rsta  => '0',
            wea   => capture_we,
            addra => capture_addr,
            dina  => capture_data,
                                   
            -- Read port
            clkb  => clk50,
            -- rstb  => '0',
            addrb => frame_addr,
            doutb => frame_pixel
        );
  
    led <= "0000000" & config_finished;
  
    capture: ov7670_capture 
    port map(
        pclk  => ov7670_pclk,
        vsync => ov7670_vsync,
        href  => ov7670_href,
        d     => ov7670_d,
        addr  => capture_addr,
        dout  => capture_data,
        we    => capture_we(0)
    );

    siod_in     <= ov7670_siod;
    ov7670_siod <= siod_out when siod_en = '1' else
                   'Z';
    
    controller: ov7670_controller
    port map(
        clk             => clk50,
        sioc            => ov7670_sioc,
        resend          => resend,
        config_finished => config_finished,
        siod_out        => siod_out,
        siod_en         => siod_en,
        siod_in         => siod_in,
        pwdn            => ov7670_pwdn,
        reset           => ov7670_reset,
        xclk            => ov7670_xclk
    );

    clk_inst : clocking
    port map (
        -- clock in ports
        clk_100 => clk100,
        -- clock out ports
        clk_50 => clk50,
        clk_25 => clk25
    );

end behavioral;
