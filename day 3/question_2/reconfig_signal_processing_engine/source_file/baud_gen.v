`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 14:38:21
// Design Name: 
// Module Name: baud_gen
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

module baud_gen #(
    parameter CLK_FREQ = 100000000,
    parameter BAUD_RATE = 115200
)
(
    input  wire clk,
    input  wire rst,

    output reg baud_tick
);

localparam integer COUNT_MAX = CLK_FREQ / BAUD_RATE;

reg [15:0] counter;


always @(posedge clk)
begin

    if(rst)
    begin
        counter   <= 0;
        baud_tick <= 0;
    end

    else
    begin

        if(counter == COUNT_MAX-1)
        begin
            counter   <= 0;
            baud_tick <= 1;
        end

        else
        begin
            counter   <= counter + 1;
            baud_tick <= 0;
        end

    end

end

endmodule