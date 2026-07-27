`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 18:28:55
// Design Name: 
// Module Name: addressCcounter
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


module addressCcounter(clk,reset,address_gen_enable,address_counter );
input clk;
input reset;
input address_gen_enable;
output reg [3:0] address_counter;
always@(posedge clk)
begin
    if(reset)
    begin
        address_counter<=4'b1111;
    end
    else
    begin
        if (address_gen_enable == 1)
        begin
        if (address_counter != 4'b1010)
        begin
            address_counter <= address_counter + 1;
        end
        else
        begin
             address_counter <= address_counter;
        end
        end
        else
        begin
            address_counter <= address_counter;
        end
    end
    
end
endmodule
