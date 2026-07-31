## Clock Signal (100 MHz Onboard Clock)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## Reset Button (Center Button BTNC)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## RP1 Output LEDs (Left 4 LEDs: LED[3:0])
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]

## RP2 Output LEDs (Right 4 LEDs: LED[7:4])
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]

create_pblock pblock_rp1_inst
add_cells_to_pblock [get_pblocks pblock_rp1_inst] [get_cells -quiet [list rp1_inst]]
resize_pblock [get_pblocks pblock_rp1_inst] -add {SLICE_X0Y110:SLICE_X31Y144}
resize_pblock [get_pblocks pblock_rp1_inst] -add {DSP48_X0Y44:DSP48_X0Y57}
resize_pblock [get_pblocks pblock_rp1_inst] -add {RAMB18_X0Y44:RAMB18_X0Y57}
resize_pblock [get_pblocks pblock_rp1_inst] -add {RAMB36_X0Y22:RAMB36_X0Y28}
create_pblock pblock_rp2_inst
add_cells_to_pblock [get_pblocks pblock_rp2_inst] [get_cells -quiet [list rp2_inst]]
resize_pblock [get_pblocks pblock_rp2_inst] -add {SLICE_X40Y60:SLICE_X65Y94}
resize_pblock [get_pblocks pblock_rp2_inst] -add {DSP48_X1Y24:DSP48_X1Y37}
resize_pblock [get_pblocks pblock_rp2_inst] -add {RAMB18_X1Y24:RAMB18_X2Y37}
resize_pblock [get_pblocks pblock_rp2_inst] -add {RAMB36_X1Y12:RAMB36_X2Y18}
