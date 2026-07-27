`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 20:56:05
// Design Name: 
// Module Name: Matrix_Multiplier_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Matrix_Multiplier_top(clk,reset,led_out,switch );
input clk;
input reset;
input [3:0]switch;
output [7:0]led_out;
wire [31:0] mul_output;
wire [31:0] doutaC; 
wire out_delayed;
wire bypass_counter_reset;
Multiplier_PartA  MultiplierPortion(clk,reset,mul_output,out_delayed,bypass_counter_reset );
add_write_to_bram AdderPortion(clk,mul_output,~(out_delayed),doutaC,switch,~(bypass_counter_reset) );
assign led_out = doutaC[7:0];
endmodule
