`timescale 1ns/1ps

module testbench;

reg clk;
reg rst;
reg start;

wire done;
wire [15:0] result;

matrix_top DUT(
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(done),
    .result(result)
);
always #5 clk = ~clk;
initial
begin
    clk = 0;
    rst = 1;
    start = 0;
    #20;
    rst = 0;
    #10;
    start = 1;
    #10;
    start = 0;
    #100;
    $display("Result = %d", result);
    $finish;
end
endmodule