`timescale 1ns / 1ps

module adder_top( clk,reset,adder_bypass,adder1,adder2,added_result );
input clk;
input reset;
input adder_bypass;
input [31:0] adder1;
input [31:0] adder2;
output [31:0] added_result;
wire [31:0] adder_output;

c_addsub_0 adderInstance(adder1,adder2,adder_bypass,adder_output);
register_result regresult(clk,adder_output,reset,added_result);
endmodule
