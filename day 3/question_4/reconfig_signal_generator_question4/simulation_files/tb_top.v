`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 13:00:49
// Design Name: 
// Module Name: tb_top
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


`timescale 1ns/1ps

module tb_top;

    // Inputs
    reg clk;
    reg rst;

    // Output
    wire tx;

    //====================================================
    // DUT
    //====================================================

    top DUT
    (
        .clk(clk),
        .rst(rst),
        .tx(tx)
    );

    //====================================================
    // 100 MHz Clock
    //====================================================

    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //====================================================
    // Reset
    //====================================================

    initial
    begin
        rst = 1;

        #100;

        rst = 0;
    end

    //====================================================
    // Simulation Time
    //====================================================

    initial
    begin
        #100000;

        $finish;
    end

    //====================================================
    // Monitor UART
    //====================================================

    initial
    begin
        $display("------------------------------------------");
        $display(" Time\t\tReset\tTX");
        $display("------------------------------------------");

        $monitor("%0t\t%b\t%b",
                 $time,
                 rst,
                 tx);
    end

endmodule
