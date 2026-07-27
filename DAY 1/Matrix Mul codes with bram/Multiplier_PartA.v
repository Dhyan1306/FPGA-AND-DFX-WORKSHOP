`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 19:50:45
// Design Name: 
// Module Name: Multiplier_PartA
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


module Multiplier_PartA(clk,reset,mul_output,out_delayed,bypass_counter_reset );
input clk;
input reset;
output [31:0] mul_output;
//wire [31:0] mul_output_copy;
output out_delayed;
output bypass_counter_reset;
wire [3:0] addressAcounter,addressBcounter;
wire [31:0] mul_input1,mul_input2;
readABTop readInstance(clk,reset,addressAcounter,addressBcounter );
bramAB bramAinstance(.clka(clk),.wea(1'd0),.addra(addressAcounter),.dina(0),.douta(mul_input1));
bramAB bramBinstance(.clka(clk),.wea(1'd0),.addra(addressBcounter),.dina(0),.douta(mul_input2));
mult_gen_0 mulInstance(.CLK(clk),.A(mul_input1),.B(mul_input2),.P(mul_output)); // Pipelined Version
defparam instance1.N=2+4+1; //Version 2 Pipelined
//mult_gen_0 mulInstance(.A(mul_input1),.B(mul_input2),.P(mul_output)); //Version 1 Unpipelined
//defparam instance1.N=2;  //Version 1 Unpipelined
delayEnableGenerator instance1( clk,~(reset), out_delayed);
defparam instance2.N=1+4+1; //Version 2 Pipelined
//defparam instance2.N = 1; //Version 1 Unpipelined
delayEnableGenerator instance2( clk,~(reset), bypass_counter_reset);
//assign  mul_output = mul_output_copy[3:0];
endmodule
