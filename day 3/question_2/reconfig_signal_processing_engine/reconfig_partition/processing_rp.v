`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 14:34:59
// Design Name: 
// Module Name: processing_rp
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

module processing_rp(

    input wire clk,
    input wire rst,

    input wire [7:0] sample_in,
    input wire sample_valid,

    output reg [7:0] sample_out,
    output reg sample_out_valid

);

always @(posedge clk)

begin

    if(rst)

    begin
        sample_out <= 8'd0;
        sample_out_valid <= 1'b0;
    end

    else

    begin
        sample_out <= sample_in;
        sample_out_valid <= sample_valid;
    end

end

endmodule
