`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 12:09:47
// Design Name: 
// Module Name: sample_tick_gen
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

module sample_tick_gen
#(
    parameter DIV = 8
)
(
    input clk,
    input rst,

    output reg sample_tick
);

reg [31:0] counter;

always @(posedge clk)
begin

    if(rst)
    begin
        counter <= 0;
        sample_tick <= 0;
    end

    else
    begin

        if(counter == DIV-1)
        begin
            counter <= 0;
            sample_tick <= 1;
        end

        else
        begin
            counter <= counter + 1;
            sample_tick <= 0;
        end

    end

end

endmodule
