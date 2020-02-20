set pclk_period 40

# data valid before rising edge of clock
set dv_bre 15 
# data valid after rising edge of clock
set dv_are 8

# HREF to clock falling edge max skew
set max_href_cfe 5
set min_href_cfe 0

# This is the OV7670 clock, input to the FPGA
create_clock -name pclk -period $pclk_period [get_ports ov7670_pclk]


# The following inputs are synchronous to pclk
set_input_delay -clock pclk -max [expr $pclk_period - $dv_bre]  [get_ports ov7670_d[*]  ]
set_input_delay -clock pclk -min $dv_are                        [get_ports ov7670_d[*]  ]

set_input_delay -clock pclk -max [expr $pclk_period/2 + $href_cfe]  [get_ports ov7670_href  ]
set_input_delay -clock pclk -min [expr $pclk_period/2 + $dv_are  ]  [get_ports ov7670_href  ]
