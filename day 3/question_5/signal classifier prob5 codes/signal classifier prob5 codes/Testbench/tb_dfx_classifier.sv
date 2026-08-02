`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 10:34:07
// Design Name: 
// Module Name: tb_dfx_classifier
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

module tb_dfx_classifier;

    logic clk = 0, rst_n = 0, start_btn = 0;
    logic [ADDR_WIDTH-1:0] seq_len_sw = 8'd5;
    logic [2:0] led;

    top_dfx_classifier dut (.*);

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        #20 rst_n = 1;
        #10 start_btn = 1;
        #10 start_btn = 0;

        wait (dut.done);
        #10 $display("DONE=%b RESULT=%b LED=%b", dut.done, dut.result, led);
        $finish;
    end
endmodule
