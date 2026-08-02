`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 13:19:42
// Design Name: 
// Module Name: top_dfx_classifier
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


import rm_pkg::*;

module top_dfx_classifier #(
    parameter int DEPTH = 256
)(
    input  logic clk,
    input  logic rst,              // active-high switch (V17)
    input  logic start,            // switch (V16)
    input  logic [ADDR_WIDTH-1:0] seq_len_sw,
    output logic [15:0] result,    // 16 LEDs
    output logic done              // W7 (borrowed 7-seg pin)
);

    logic rst_n;
    assign rst_n = ~rst;

    logic rm_done, rm_result;
    logic [2:0] rm_led;
    
    seq_bram u_seq_bram (
    .clka  (clk),
    .addra (bram_addr),
    .douta (bram_dout)
    );

    rm_symmetry_checker u_RP (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .seq_len   (seq_len_sw),
        .bram_addr (bram_addr),
        .bram_dout (bram_dout),
        .bram_en   (bram_en),
        .done      (rm_done),
        .result    (rm_result),
        .led       (rm_led)
    );

    assign done = rm_done;
    assign result = {13'b0, rm_led};   // rm_led[2:0] -> result[2:0]

endmodule
