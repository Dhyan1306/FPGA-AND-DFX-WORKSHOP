`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 12:08:29
// Design Name: 
// Module Name: top
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

module top(

    input clk,
    input rst,

    output tx

);

wire sample_tick;
wire [7:0] sample;

wire tx_busy;
wire tx_done;

reg tx_start;

/////////////////////////////////////////////////////////
// Sample Tick Generator
/////////////////////////////////////////////////////////

sample_tick_gen #(
    .DIV(50000)
)
tick_gen
(
    .clk(clk),
    .rst(rst),
    .sample_tick(sample_tick)
);

/////////////////////////////////////////////////////////
// Reconfigurable Partition
/////////////////////////////////////////////////////////

waveform_rp waveform
(
    .clk(clk),
    .rst(rst),
    .sample_tick(sample_tick),
    .sample(sample)
);

/////////////////////////////////////////////////////////
// UART
/////////////////////////////////////////////////////////

uart_tx #(
    .CLKS_PER_BIT(868)
)
uart
(
    .clk(clk),
    .rst(rst),

    .tx_start(tx_start),
    .tx_data(sample),

    .tx(tx),
    .tx_busy(tx_busy),
    .tx_done(tx_done)
);

/////////////////////////////////////////////////////////
// Controller
/////////////////////////////////////////////////////////

always @(posedge clk)
begin

    if(rst)
        tx_start <= 0;

    else
    begin

        if(sample_tick && !tx_busy)
            tx_start <= 1;

        else
            tx_start <= 0;

    end

end

endmodule