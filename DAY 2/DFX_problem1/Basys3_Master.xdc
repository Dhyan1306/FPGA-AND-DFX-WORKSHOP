## Clock signal (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## LEDs: LED[7:0]
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]

## Reset Button (Center)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

create_pblock pblock_pattern_inst
add_cells_to_pblock [get_pblocks pblock_pattern_inst] [get_cells -quiet [list pattern_inst]]
resize_pblock [get_pblocks pblock_pattern_inst] -add {SLICE_X0Y115:SLICE_X27Y149}
resize_pblock [get_pblocks pblock_pattern_inst] -add {DSP48_X0Y46:DSP48_X0Y59}
resize_pblock [get_pblocks pblock_pattern_inst] -add {RAMB18_X0Y46:RAMB18_X0Y59}
resize_pblock [get_pblocks pblock_pattern_inst] -add {RAMB36_X0Y23:RAMB36_X0Y29}

