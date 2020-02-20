# NOTE:  typical usage would be "vivado -mode batch -source run_zedboard_build.tcl" 

set outputDir ./output
file mkdir $outputDir

set partNumber "xc7z020clg484-1"
set boardName "em.avnet.com:zed:part0:1.4"

set_part $partNumber
set_property board_part $boardName [current_project]
#
# STEP#1: setup design sources and constraints
#
read_vhdl [glob ./sources/*.vhd]
read_vhdl ov7670_top.vhd
read_ip ./ip/blk_mem/blk_mem.xcix
read_xdc zed_board.xdc
read_xdc zed_timing.xdc

#
# STEP#2: Generate IPs
#
# set_property synth_checkpoint_mode None [get_files ./ip/blk_mem/blk_mem.xcix]
generate_target all [get_files ./ip/blk_mem/blk_mem.xcix]

#
# STEP#3:
#
synth_design -top ov7670_top
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt 
report_power -file $outputDir/post_synth_power.rpt 
report_clock_interaction -delay_type min_max -file $outputDir/post_synth_clock_interaction.rpt 
report_high_fanout_nets -fanout_greater_than 200 -max_nets 50 -file $outputDir/post_synth_high_fanout_nets.rpt 

# STEP#4: run placement and logic optimzation, report utilization and timing estimates, write checkpoint design

opt_design
place_design
phys_opt_design
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt

# STEP#5: run router, report actual utilization and timing, write checkpoint design, run drc, write verilog and xdc out

route_design
write_checkpoint -force $outputDir/post_route
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -max_paths 100 -path_type summary -slack_lesser_than 0 -file $outputDir/post_route_setup_timing_violations.rpt
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/ov7670_top_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/ov7670_top_impl.xdc

# STEP#6: generate a bitstream

write_bitstream -force $outputDir/ov7670_top.bit

