`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 23:43:11
// Design Name: 
// Module Name: read_back_mux
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


module read_back_mux(weaC_address_gen,addraC_address_gen,switch,Cread_back_select,weaCBramC,addraCBramC );
input weaC_address_gen;
input [3:0] addraC_address_gen;
input [3:0] switch;
input Cread_back_select;
output weaCBramC;
output [3:0] addraCBramC;

assign weaCBramC = (Cread_back_select == 0) ? weaC_address_gen : 0;
assign addraCBramC = (Cread_back_select == 0) ? addraC_address_gen : switch;

endmodule
