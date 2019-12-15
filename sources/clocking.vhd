-- file: clocking.vhd
-- 
-- (c) copyright 2008 - 2011 xilinx, inc. all rights reserved.
-- 
-- this file contains confidential and proprietary information
-- of xilinx, inc. and is protected under u.s. and
-- international copyright and other intellectual property
-- laws.
-- 
-- disclaimer
-- this disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. except as
-- otherwise provided in a valid license issued to you by
-- xilinx, and to the maximum extent permitted by applicable
-- law: (1) these materials are made available "as is" and
-- with all faults, and xilinx hereby disclaims all warranties
-- and conditions, express, implied, or statutory, including
-- but not limited to warranties of merchantability, non-
-- infringement, or fitness for any particular purpose; and
-- (2) xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or xilinx had been advised of the
-- possibility of the same.
-- 
-- critical applications
-- xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, class iii medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "critical
-- applications"). customer assumes the sole risk and
-- liability of any use of xilinx products in critical
-- applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- this copyright notice and disclaimer must be retained as
-- part of this file at all times.
-- 
------------------------------------------------------------------------------
-- user entered comments
------------------------------------------------------------------------------
-- none
--
------------------------------------------------------------------------------
-- "output    output      phase     duty      pk-to-pk        phase"
-- "clock    freq (mhz) (degrees) cycle (%) jitter (ps)  error (ps)"
------------------------------------------------------------------------------
-- clk_out1____50.000______0.000______50.0______151.636_____98.575
-- clk_out2____25.000______0.000______50.0______175.402_____98.575
--
------------------------------------------------------------------------------
-- "input clock   freq (mhz)    input jitter (ui)"
------------------------------------------------------------------------------
-- __primary_________100.000____________0.010

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity clocking is
    port( 
        -- clock in ports
        clk_100         : in    std_logic;
        -- clock out ports
        clk_50          : out   std_logic;
        clk_25          : out   std_logic
    );

end clocking;

architecture xilinx of clocking is
    attribute core_generation_info : string;
    attribute core_generation_info of xilinx : architecture is "clocking,clk_wiz_v3_6,{component_name=clocking,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,feedback_source=fdbk_auto,primtype_sel=mmcm_adv,num_out_clk=2,clkin1_period=10.000,clkin2_period=10.000,use_power_down=false,use_reset=false,use_locked=false,use_inclk_stopped=false,use_status=false,use_freeze=false,use_clk_valid=false,feedback_type=single,clock_mgr_type=manual,manual_override=false}";
    -- input clock buffering / unused connectors
    signal clkin1      : std_logic;
    -- output clock buffering / unused connectors
    signal clkfbout         : std_logic;
    signal clkfbout_buf     : std_logic;
    signal clkfboutb_unused : std_logic;
    signal clkout0          : std_logic;
    signal clkout0b_unused  : std_logic;
    signal clkout1          : std_logic;
    signal clkout1b_unused  : std_logic;
    signal clkout2_unused   : std_logic;
    signal clkout2b_unused  : std_logic;
    signal clkout3_unused   : std_logic;
    signal clkout3b_unused  : std_logic;
    signal clkout4_unused   : std_logic;
    signal clkout5_unused   : std_logic;
    signal clkout6_unused   : std_logic;
    -- dynamic programming unused signals
    signal do_unused        : std_logic_vector(15 downto 0);
    signal drdy_unused      : std_logic;
    -- dynamic phase shift unused signals
    signal psdone_unused    : std_logic;
    -- unused status signals
    signal locked_unused    : std_logic;
    signal clkfbstopped_unused : std_logic;
    signal clkinstopped_unused : std_logic;
begin


    -- input buffering
    --------------------------------------
    clkin1_buf : ibufg
    port map(
        o => clkin1,
        i => clk_100
    );
    
    
    -- clocking primitive
    --------------------------------------
    -- instantiation of the mmcm primitive
    --    * unused inputs are tied off
    --    * unused outputs are labeled unused
    mmcm_adv_inst : mmcme2_adv
    generic map (
        bandwidth            => "optimized",
        clkout4_cascade      => false,
        compensation         => "zhold",
        startup_wait         => false,
        divclk_divide        => 1,
        clkfbout_mult_f      => 10.000,
        clkfbout_phase       => 0.000,
        clkfbout_use_fine_ps => false,
        clkout0_divide_f     => 20.000,
        clkout0_phase        => 0.000,
        clkout0_duty_cycle   => 0.500,
        clkout0_use_fine_ps  => false,
        clkout1_divide       => 40,
        clkout1_phase        => 0.000,
        clkout1_duty_cycle   => 0.500,
        clkout1_use_fine_ps  => false,
        clkin1_period        => 10.000,
        ref_jitter1          => 0.010
    ) port map (
        -- output clocks
        clkfbout            => clkfbout,
        clkfboutb           => clkfboutb_unused,
        clkout0             => clkout0,
        clkout0b            => clkout0b_unused,
        clkout1             => clkout1,
        clkout1b            => clkout1b_unused,
        clkout2             => clkout2_unused,
        clkout2b            => clkout2b_unused,
        clkout3             => clkout3_unused,
        clkout3b            => clkout3b_unused,
        clkout4             => clkout4_unused,
        clkout5             => clkout5_unused,
        clkout6             => clkout6_unused,
        -- input clock control
        clkfbin             => clkfbout_buf,
        clkin1              => clkin1,
        clkin2              => '0',
        -- tied to always select the primary input clock
        clkinsel            => '1',
        -- ports for dynamic reconfiguration
        daddr               => (others => '0'),
        dclk                => '0',
        den                 => '0',
        di                  => (others => '0'),
        do                  => do_unused,
        drdy                => drdy_unused,
        dwe                 => '0',
        -- ports for dynamic phase shift
        psclk               => '0',
        psen                => '0',
        psincdec            => '0',
        psdone              => psdone_unused,
        -- other control and status signals
        locked              => locked_unused,
        clkinstopped        => clkinstopped_unused,
        clkfbstopped        => clkfbstopped_unused,
        pwrdwn              => '0',
        rst                 => '0'
    );
    
    -- output buffering
    -------------------------------------
    clkf_buf : bufg
    port map (
        o => clkfbout_buf,
        i => clkfbout
    );
    
    
    clkout1_buf : bufg
    port map (
        o   => clk_50,
        i   => clkout0
    );
    
    
    
    clkout2_buf : bufg
    port map (
        o   => clk_25,
        i   => clkout1
    );

end xilinx;
