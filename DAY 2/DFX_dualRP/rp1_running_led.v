`timescale 1ns / 1ps

module rp1_module (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    output reg  [3:0] led_out
);

    always @(posedge clk) begin
        if (rst) begin
            led_out <= 4'b1000;
        end else if (tick) begin
            led_out <= {led_out[0], led_out[3:1]}; // Right shift with wrap-around
        end
    end

endmodule
