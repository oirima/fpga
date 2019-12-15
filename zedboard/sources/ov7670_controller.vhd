----------------------------------------------------------------------------------
-- engineer: mike field <hamster@snap.net.nz>
-- 
-- description: controller for the ov760 camera - transferes registers to the 
--              camera over an i2c like bus
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ov7670_controller is
    port (
        clk             : in    std_logic;
        resend          : in    std_logic;
        config_finished : out   std_logic;
        sioc            : out   std_logic;
        siod_out        : out   std_logic;
        siod_en         : out   std_logic;
        siod_in         : in    std_logic;
        reset           : out   std_logic;
        pwdn            : out   std_logic;
        xclk            : out   std_logic
    );
end ov7670_controller;

architecture behavioral of ov7670_controller is
    component ov7670_registers
        port(
            clk         : in    std_logic;
            advance     : in    std_logic;          
            resend      : in    std_logic;
            command     : out   std_logic_vector(15 downto 0);
            finished    : out   std_logic
            );
    end component;

    component i2c_sender
        port(
            clk     : in    std_logic;
            send    : in    std_logic;
            taken   : out   std_logic;
            id      : in    std_logic_vector(7 downto 0);
            reg     : in    std_logic_vector(7 downto 0);
            value   : in    std_logic_vector(7 downto 0);    
            siod_out: out   std_logic;      
            siod_en : out   std_logic;      
            siod_in : in    std_logic;      
            sioc    : out   std_logic
            );
    end component;

    signal sys_clk  : std_logic := '0';    
    signal command  : std_logic_vector(15 downto 0);
    signal finished : std_logic := '0';
    signal taken    : std_logic := '0';
    signal send     : std_logic;

    constant camera_address : std_logic_vector(7 downto 0) := x"42"; -- 42"; -- device write id - see top of page 11 of data sheet
begin
    config_finished <= finished;
    send            <= not finished;

    inst_i2c_sender: i2c_sender 
        port map(
            clk     => clk,
            taken   => taken,
            sioc    => sioc,
            siod_out=> siod_out,
            siod_en => siod_en,
            siod_in => siod_in,
            send    => send,
            id      => camera_address,
            reg     => command(15 downto 8),
            value   => command(7 downto 0)
        );

    reset <= '1';                         -- normal mode
    pwdn  <= '0';                         -- power device up
    xclk  <= sys_clk;
    
    inst_ov7670_registers: ov7670_registers port map(
        clk      => clk,
        advance  => taken,
        command  => command,
        finished => finished,
        resend   => resend
    );

    process(clk)
    begin
        if rising_edge(clk) then
            sys_clk <= not sys_clk;
        end if;
    end process;
end behavioral;

