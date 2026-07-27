`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2024 16:45:08
// Design Name: 
// Module Name: Acounter
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


module Acounter(clk,reset,addressBcounter,addressAcounter );
input clk;
input reset;
input [3:0]addressBcounter;
output reg [3:0] addressAcounter;


always @(posedge clk ) begin
    if (reset) begin
        addressAcounter <= 4'b1111; // Reset counter to 0 when reset is active high
    end else begin
        if ((addressBcounter == 4'b0010)||(addressBcounter == 4'b0101)) begin
            addressAcounter <= addressAcounter - 2; 
        end else if (addressBcounter == 4'b1000) begin
            if (addressAcounter == 4'b1000) begin
                addressAcounter <=0;
            end
            else begin
            addressAcounter <= addressAcounter + 1;
            end
        end
        else begin
            addressAcounter <= addressAcounter + 1;
        end
    end
end
endmodule
