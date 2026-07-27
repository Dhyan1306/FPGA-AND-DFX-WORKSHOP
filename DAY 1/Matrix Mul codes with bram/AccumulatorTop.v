`timescale 1ns / 1ps
module AccumulatorTop(clk,adder2B,accumulator_reset,added_result,adder_bypass,bypass_counter_reset );
input clk;
input [31:0] adder2B;
output [31:0]added_result;
output adder_bypass;
input accumulator_reset;
input bypass_counter_reset;
adder_top adder_instance( clk,accumulator_reset,adder_bypass,added_result,adder2B,added_result );
bypass_counter bypass_counter_instance(clk,bypass_counter_reset,adder_bypass);
endmodule
