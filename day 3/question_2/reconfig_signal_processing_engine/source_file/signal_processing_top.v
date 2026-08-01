`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 14:25:17
// Design Name: 
// Module Name: signal_processing_top
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

module signal_processing_top(

    input  wire clk,
    input  wire rst,

    // Basys 3 UART pins
    input  wire uart_rx,
    output wire uart_tx

);


//////////////////////////////////////////////////////
// Baud Generator
//////////////////////////////////////////////////////

wire baud_tick;


baud_gen baud_inst
(
    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick)
);



//////////////////////////////////////////////////////
// UART RX
//////////////////////////////////////////////////////

wire [7:0] rx_data;
wire rx_valid;


uart_rx rx_inst
(
    .clk(clk),
    .rst(rst),

    .rx(uart_rx),
    .baud_tick(baud_tick),

    .data_out(rx_data),
    .data_valid(rx_valid)
);



//////////////////////////////////////////////////////
// FIFO between UART and RP
//////////////////////////////////////////////////////

wire [7:0] fifo_data;

wire fifo_empty;
wire fifo_full;


fifo fifo_inst
(
    .clk(clk),
    .rst(rst),

    // Write received UART bytes
    .wr_en(rx_valid),

    // Read whenever RP is ready
    .rd_en(!fifo_empty),

    .data_in(rx_data),

    .data_out(fifo_data),

    .full(fifo_full),
    .empty(fifo_empty)

);



//////////////////////////////////////////////////////
// Reconfigurable Partition
//////////////////////////////////////////////////////

wire [7:0] processed_data;
wire processed_valid;


processing_rp RP
(
    .clk(clk),
    .rst(rst),

    .sample_in(fifo_data),

    .sample_valid(!fifo_empty),

    .sample_out(processed_data),

    .sample_out_valid(processed_valid)

);



//////////////////////////////////////////////////////
// UART TX
//////////////////////////////////////////////////////

uart_tx tx_inst
(
    .clk(clk),
    .rst(rst),

    .baud_tick(baud_tick),

    .data_in(processed_data),

    .data_valid(processed_valid),

    .tx(uart_tx)

);



endmodule