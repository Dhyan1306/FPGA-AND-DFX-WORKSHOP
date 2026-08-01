`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 12:11:42
// Design Name: 
// Module Name: waveform_rp
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

module waveform_rp(

    input clk,
    input rst,
    input sample_tick,

    output reg [7:0] sample

);

reg [7:0] counter;

always @(posedge clk)
begin

    if(rst)
    begin
        sample <= 0;
        counter <= 0;
    end

    else if(sample_tick)
    begin

        if(counter < 100)
            sample <= 8'hFF;
        else
            sample <= 8'h00;

        if(counter == 199)
            counter <= 0;
        else
            counter <= counter + 1;

    end

end

endmodule
