----------------------------------------------------------------------------------
-- engineer: Amir Ghanbari Bavarsad <amir.b@oirima.com>
-- 
-- description: A Simple Dual-Port Block RAM for Xilinx 7-series and Zynq-7000
--              chips. See UG953 for more details.
--
----------------------------------------------------------------------------------

library xpm;
use xpm.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdpram is
    generic (
        clocking_mode   : string    := "independent_clock"; -- common_clock, independent_clock
        addr_width      : integer   := 12;                  -- 1 to 20
        data_width      : integer   := 8 
    );
    port (
        -- Write port
        clka  : in  std_logic;
        rsta  : in  std_logic;
        wea   : in  std_logic_vector(0 downto 0);
        addra : in  std_logic_vector(addr_width-1 downto 0);
        dina  : in  std_logic_vector(data_width-1 downto 0);

        -- Read port
        clkb  : in  std_logic;
        rstb  : in  std_logic;
        addrb : in  std_logic_vector(addr_width-1 downto 0);
        doutb : out std_logic_vector(data_width-1 downto 0)
    );
end entity;

architecture macro_block of sdpram is
    constant memory_size : integer := data_width * (2**addr_width); -- memory size in bits

begin
    -- xpm_memory_sdpram: Simple Dual Port RAM
    -- Xilinx Parameterized Macro, version 2019.2
    xpm_memory_sdpram_inst : xpm_memory_sdpram
        generic map (
            ADDR_WIDTH_A                    => addr_width,        -- DECIMAL
            ADDR_WIDTH_B                    => addr_width,        -- DECIMAL
            AUTO_SLEEP_TIME                 => 0,                 -- DECIMAL
            BYTE_WRITE_WIDTH_A              => data_width,        -- DECIMAL
            CASCADE_HEIGHT                  => 0,                 -- DECIMAL
            CLOCKING_MODE                   => clocking_mode,     -- String
            ECC_MODE                        => "no_ecc",          -- String
            MEMORY_INIT_FILE                => "none",            -- String
            MEMORY_INIT_PARAM               => "0",               -- String
            MEMORY_OPTIMIZATION             => "true",            -- String
            MEMORY_PRIMITIVE                => "block",           -- String
            MEMORY_SIZE                     => memory_size,       -- DECIMAL
            MESSAGE_CONTROL                 => 0,                 -- DECIMAL
            READ_DATA_WIDTH_B               => data_width,        -- DECIMAL
            READ_LATENCY_B                  => 2,                 -- DECIMAL
            READ_RESET_VALUE_B              => "0",               -- String
            RST_MODE_A                      => "SYNC",            -- String
            RST_MODE_B                      => "SYNC",            -- String
            SIM_ASSERT_CHK                  => 0,                 -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            USE_EMBEDDED_CONSTRAINT         => 0,                 -- DECIMAL
            USE_MEM_INIT                    => 1,                 -- DECIMAL
            WAKEUP_TIME                     => "disable_sleep",   -- String
            WRITE_DATA_WIDTH_A              => data_width,        -- DECIMAL
            WRITE_MODE_B                    => "no_change"        -- String
        )
        port map (
            dbiterrb        => open,            -- 1-bit output: Status signal to indicate double bit error occurrence
                                                -- on the data output of port B.
            doutb           => doutb,           -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
            sbiterrb        => open,            -- 1-bit output: Status signal to indicate single bit error occurrence
                                                -- on the data output of port B.
            addra           => addra,           -- ADDR_WIDTH_A-bit input: Address for port A write operations.
            addrb           => addrb,           -- ADDR_WIDTH_B-bit input: Address for port B read operations.
            clka            => clka,            -- 1-bit input: Clock signal for port A. Also clocks port B when
                                                -- parameter CLOCKING_MODE is "common_clock".
            clkb            => clkb,            -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                                -- "independent_clock". Unused when parameter CLOCKING_MODE is 
                                                -- "common_clock".
            dina            => dina,            -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
            ena             => '1',             -- 1-bit input: Memory enable signal for port A. Must be high on clock
                                                -- cycles when write operations are initiated. Pipelined internally.
            enb             => '1',             -- 1-bit input: Memory enable signal for port B. Must be high on clock
                                                -- cycles when read operations are initiated. Pipelined internally.
            injectdbiterra  => '0',             -- 1-bit input: Controls double bit error injection on input data when
                                                -- ECC enabled (Error injection capability is not available in
                                                -- "decode_only" mode).
            injectsbiterra  => '0',             -- 1-bit input: Controls single bit error injection on input data when
                                                -- ECC enabled (Error injection capability is not available in
                                                -- "decode_only" mode).
            regceb          => '1',             -- 1-bit input: Clock Enable for the last register stage on the output
                                                -- data path.
            rstb            => rstb,            -- 1-bit input: Reset signal for the final port B output register
                                                -- stage. Synchronously resets output port doutb to the value specified
                                                -- by parameter READ_RESET_VALUE_B.
            sleep           => '0',             -- 1-bit input: sleep signal to enable the dynamic power saving feature.
            wea             => wea              -- WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                                -- for port A input data port dina. 1 bit wide when word-wide writes
                                                -- are used. In byte-wide write configurations, each bit controls the
                                                -- writing one byte of dina to address addra. For example, to
                                                -- synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                                -- is 32, wea would be 4'b0010.
    );
    -- End of xpm_memory_sdpram_inst instantiation

end macro_block;
