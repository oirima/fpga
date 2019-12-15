----------------------------------------------------------------------------------
-- company: 
-- engineer: mike field <hamster@sanp.net.nz> 
-- 
-- description: register settings for the ov7670 caamera (partially from ov7670.c
--              in the linux kernel
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ov7670_registers is
    port ( clk      : in  std_logic;
           resend   : in  std_logic;
           advance  : in  std_logic;
           command  : out  std_logic_vector(15 downto 0);
           finished : out  std_logic);
end ov7670_registers;

architecture behavioral of ov7670_registers is
    signal sreg     : std_logic_vector(15 downto 0);
    signal address  : std_logic_vector(7 downto 0) := (others => '0');
begin
    command <= sreg;
    with sreg select finished  <=
        '1' when x"ffff",
        '0' when others;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if resend = '1' then 
                address <= (others => '0');
            elsif advance = '1' then
                address <= std_logic_vector(unsigned(address)+1);
            end if;

            case address is
                when x"00" => sreg <= x"1280"; -- com7   reset
                when x"01" => sreg <= x"1280"; -- com7   reset
                when x"02" => sreg <= x"1204"; -- com7   size & rgb output
                when x"03" => sreg <= x"1100"; -- clkrc  prescaler - fin/(1+1)
                when x"04" => sreg <= x"0c00"; -- com3   lots of stuff, enable scaling, all others off
                when x"05" => sreg <= x"3e00"; -- com14  pclk scaling off
                
                when x"06" => sreg <= x"8c00"; -- rgb444 set rgb format
                when x"07" => sreg <= x"0400"; -- com1   no ccir601
                when x"08" => sreg <= x"4010"; -- com15  full 0-255 output, rgb 565
                when x"09" => sreg <= x"3a04"; -- tslb   set uv ordering,  do not auto-reset window
                when x"0a" => sreg <= x"1438"; -- com9  - agc celling
                when x"0b" => sreg <= x"4fb3"; -- mtx1  - colour conversion matrix
                when x"0c" => sreg <= x"50b3"; -- mtx2  - colour conversion matrix
                when x"0d" => sreg <= x"5100"; -- mtx3  - colour conversion matrix
                when x"0e" => sreg <= x"523d"; -- mtx4  - colour conversion matrix
                when x"0f" => sreg <= x"53a7"; -- mtx5  - colour conversion matrix
                when x"10" => sreg <= x"54e4"; -- mtx6  - colour conversion matrix
                when x"11" => sreg <= x"589e"; -- mtxs  - matrix sign and auto contrast
                when x"12" => sreg <= x"3dc0"; -- com13 - turn on gamma and uv auto adjust
                when x"13" => sreg <= x"1100"; -- clkrc  prescaler - fin/(1+1)
                
                when x"14" => sreg <= x"1711"; -- hstart href start (high 8 bits)
                when x"15" => sreg <= x"1861"; -- hstop  href stop (high 8 bits)
                when x"16" => sreg <= x"32a4"; -- href   edge offset and low 3 bits of hstart and hstop
                
                when x"17" => sreg <= x"1903"; -- vstart vsync start (high 8 bits)
                when x"18" => sreg <= x"1a7b"; -- vstop  vsync stop (high 8 bits) 
                when x"19" => sreg <= x"030a"; -- vref   vsync low two bits
            
--                when x"10" => sreg <= x"703a"; -- scaling_xsc
--                when x"11" => sreg <= x"7135"; -- scaling_ysc
--                when x"12" => sreg <= x"7200"; -- scaling_dcwctr  -- zzz was 11 
--                when x"13" => sreg <= x"7300"; -- scaling_pclk_div
--                when x"14" => sreg <= x"a200"; -- scaling_pclk_delay  must match com14
--                when x"15" => sreg <= x"1500"; -- com10 use href not hsync
--                
--                when x"1d" => sreg <= x"b104"; -- ablc1 - turn on auto black level
--                when x"1f" => sreg <= x"138f"; -- com8  - agc, white balance
--                when x"21" => sreg <= x"ffff"; -- spare
--                when x"22" => sreg <= x"ffff"; -- spare
--                when x"23" => sreg <= x"0000"; -- spare
--                when x"24" => sreg <= x"0000"; -- spare
--                when x"25" => sreg <= x"138f"; -- com8 - agc, white balance
--                when x"26" => sreg <= x"0000"; -- spare
--                when x"27" => sreg <= x"1000"; -- aech exposure
--                when x"28" => sreg <= x"0d40"; -- comm4 - window size
--                when x"29" => sreg <= x"0000"; -- spare
--                when x"2a" => sreg <= x"a505"; -- aecgmax banding filter step
--                when x"2b" => sreg <= x"2495"; -- aew agc stable upper limite
--                when x"2c" => sreg <= x"2533"; -- aeb agc stable lower limi
--                when x"2d" => sreg <= x"26e3"; -- vpt agc fast mode limits
--                when x"2e" => sreg <= x"9f78"; -- hrl high reference level
--                when x"2f" => sreg <= x"a068"; -- lrl low reference level
--                when x"30" => sreg <= x"a103"; -- dspc3 dsp control
--                when x"31" => sreg <= x"a6d8"; -- lph lower prob high
--                when x"32" => sreg <= x"a7d8"; -- upl upper prob low
--                when x"33" => sreg <= x"a8f0"; -- tpl total prob low
--                when x"34" => sreg <= x"a990"; -- tph total prob high
--                when x"35" => sreg <= x"aa94"; -- nalg aec algo select
--                when x"36" => sreg <= x"13e5"; -- com8 agc settings
                when others => sreg <= x"ffff";
            end case;
        end if;
    end process;
end behavioral;

