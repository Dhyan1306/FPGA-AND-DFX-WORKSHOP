`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 18:15:38
// Design Name: 
// Module Name: add_write_to_bram
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


module add_write_to_bram(clk,mul_output,reset,doutaC,switch,bypass_counter_reset );
input clk;
input reset,bypass_counter_reset;
//wire[31:0] mul_output_copy;
input [31:0] mul_output;
input [3:0] switch;
//wire [31:0] doutaC_copy;
output [31:0] doutaC;    
wire [31:0]  added_result;
wire address_gen_enable; 
wire [3:0] address_counter;
wire Cread_back_select;
wire weaCBramC;
wire [3:0] addraCBramC;
AccumulatorTop accumInstance(clk,mul_output,reset,added_result,address_gen_enable,bypass_counter_reset);
addressCcounter addressCcounterInstance((clk),(reset) ,address_gen_enable,address_counter); 
BRAM_C bramCinstance(.clka(clk),.wea(weaCBramC),.addra(addraCBramC),.dina(added_result),.douta(doutaC));
read_back_mux mux_instance(address_gen_enable,address_counter,switch,Cread_back_select,weaCBramC,addraCBramC );

assign Cread_back_select = (address_counter[1] && address_counter[3] && (~address_counter[0]) && (~address_counter[2]));
//assign mul_output_copy = {28'd0,mul_output[3:0]};
//assign doutaC = doutaC_copy[3:0];
/*
clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
*/   
endmodule
