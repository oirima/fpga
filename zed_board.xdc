# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
set_property    PACKAGE_PIN             Y9          [get_ports {clk100                  }]; # GCLK

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ---------------------------------------------------------------------------- 
set_property    PACKAGE_PIN             Y21         [get_ports {vga_blue[0]             }]; # VGA-B1
set_property    PACKAGE_PIN             Y20         [get_ports {vga_blue[1]             }]; # VGA-B2
set_property    PACKAGE_PIN             AB20        [get_ports {vga_blue[2]             }]; # VGA-B3
set_property    PACKAGE_PIN             AB19        [get_ports {vga_blue[3]             }]; # VGA-B4
set_property    PACKAGE_PIN             AB22        [get_ports {vga_green[0]            }]; # VGA-G1
set_property    PACKAGE_PIN             AA22        [get_ports {vga_green[1]            }]; # VGA-G2
set_property    PACKAGE_PIN             AB21        [get_ports {vga_green[2]            }]; # VGA-G3
set_property    PACKAGE_PIN             AA21        [get_ports {vga_green[3]            }]; # VGA-G4
set_property    PACKAGE_PIN             AA19        [get_ports {vga_hsync               }]; # VGA-HS
set_property    PACKAGE_PIN             V20         [get_ports {vga_red[0]              }]; # VGA-R1
set_property    PACKAGE_PIN             U20         [get_ports {vga_red[1]              }]; # VGA-R2
set_property    PACKAGE_PIN             V19         [get_ports {vga_red[2]              }]; # VGA-R3
set_property    PACKAGE_PIN             V18         [get_ports {vga_red[3]              }]; # VGA-R4
set_property    PACKAGE_PIN             Y19         [get_ports {vga_vsync               }]; # VGA-VS


# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property    PACKAGE_PIN             Y11         [get_ports {ov7670_pwdn             }]; # JA1
set_property    PACKAGE_PIN             AB11        [get_ports {ov7670_reset            }]; # JA7
set_property    PACKAGE_PIN             AA11        [get_ports {ov7670_d[0]             }]; # JA2
set_property    PACKAGE_PIN             AB10        [get_ports {ov7670_d[1]             }]; # JA8
set_property    PACKAGE_PIN             Y10         [get_ports {ov7670_d[2]             }]; # JA3
set_property    PACKAGE_PIN             AB9         [get_ports {ov7670_d[3]             }]; # JA9
set_property    PACKAGE_PIN             AA9         [get_ports {ov7670_d[4]             }]; # JA4
set_property    PACKAGE_PIN             AA8         [get_ports {ov7670_d[5]             }]; # JA10

# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property    PACKAGE_PIN             W12         [get_ports {ov7670_d[6]             }]; # JB1
set_property    PACKAGE_PIN             V12         [get_ports {ov7670_d[7]             }]; # JB7
set_property    PACKAGE_PIN             W11         [get_ports {ov7670_xclk             }]; # JB2
set_property    PACKAGE_PIN             W10         [get_ports {ov7670_pclk             }]; # JB8
set_property    PACKAGE_PIN             V10         [get_ports {ov7670_href             }]; # JB3
set_property    PACKAGE_PIN             V9          [get_ports {ov7670_vsync            }]; # JB9
set_property    PACKAGE_PIN             W8          [get_ports {ov7670_siod             }]; # JB4
set_property    PACKAGE_PIN             V8          [get_ports {ov7670_sioc             }]; # JB10

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ---------------------------------------------------------------------------- 
set_property    PACKAGE_PIN             T22         [get_ports {led[0]                  }]; # LD0
set_property    PACKAGE_PIN             T21         [get_ports {led[1]                  }]; # LD1
set_property    PACKAGE_PIN             U22         [get_ports {led[2]                  }]; # LD2
set_property    PACKAGE_PIN             U21         [get_ports {led[3]                  }]; # LD3
set_property    PACKAGE_PIN             V22         [get_ports {led[4]                  }]; # LD4
set_property    PACKAGE_PIN             W22         [get_ports {led[5]                  }]; # LD5
set_property    PACKAGE_PIN             U19         [get_ports {led[6]                  }]; # LD6
set_property    PACKAGE_PIN             U14         [get_ports {led[7]                  }]; # LD7

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
set_property    PACKAGE_PIN             P16         [get_ports {btn_center              }]; # BTNC
set_property    PACKAGE_PIN             R16         [get_ports {btn_down                }]; # BTND
set_property    PACKAGE_PIN             N15         [get_ports {btn_left                }]; # BTNL
set_property    PACKAGE_PIN             R18         [get_ports {btn_right               }]; # BTNR
set_property    PACKAGE_PIN             T18         [get_ports {btn_up                  }]; # BTNU


# Voltage levels
set_property    IOSTANDARD              LVTTL       [get_ports {btn_center              }];
set_property    IOSTANDARD              LVTTL       [get_ports {btn_down                }];
set_property    IOSTANDARD              LVTTL       [get_ports {btn_left                }];
set_property    IOSTANDARD              LVTTL       [get_ports {btn_right               }];
set_property    IOSTANDARD              LVTTL       [get_ports {btn_up                  }];
set_property    IOSTANDARD              LVTTL       [get_ports {led[*]                  }];

set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_pclk             }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_sioc             }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_vsync            }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_reset            }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_pwdn             }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_href             }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_xclk             }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_siod             }];
set_property    IOSTANDARD              LVTTL       [get_ports {ov7670_d[*]             }];
set_property    IOSTANDARD              LVCMOS33    [get_ports {vga_blue[*]             }];
set_property    IOSTANDARD              LVCMOS33    [get_ports {vga_green[*]            }];
set_property    IOSTANDARD              LVCMOS33    [get_ports {vga_red[*]              }];
set_property    IOSTANDARD              LVCMOS33    [get_ports {vga_hsync               }];
set_property    IOSTANDARD              LVCMOS33    [get_ports {vga_vsync               }];
set_property    IOSTANDARD              LVCMOS33    [get_ports {clk100                  }];

# Magic
set_property    CLOCK_DEDICATED_ROUTE   FALSE       [get_nets  ov7670_pclk_IBUF          ];
