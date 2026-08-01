`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 14:29:33
// Design Name: 
// Module Name: controller
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

`timescale 1ns / 1ps

module controller(

    input clk,
    input rst,

    input sample_valid,

    output reg enable_processing

);

always @(posedge clk)

begin

    if(rst)

        enable_processing <= 1'b0;

    else

        enable_processing <= sample_valid;

end

endmodule
