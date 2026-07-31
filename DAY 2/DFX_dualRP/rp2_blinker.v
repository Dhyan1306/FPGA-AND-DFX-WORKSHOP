`timescale 1ns / 1ps

module rp2_module (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    output reg  [3:0] led_out   // 4 bits for LED[7:4]
);

    always @(posedge clk) begin
        if (rst) begin
            led_out <= 4'b0000;
        end else if (tick) begin
            led_out <= ~led_out;
        end
    end

endmodule