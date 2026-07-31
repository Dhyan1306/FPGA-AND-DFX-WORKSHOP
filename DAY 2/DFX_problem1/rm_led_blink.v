`timescale 1ns / 1ps

module led_pattern_rm (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    output reg  [7:0] led_out
);

    always @(posedge clk) begin
        if (rst) begin
            led_out <= 8'h00;
        end else if (tick) begin
            led_out <= ~led_out; // Toggle all LEDs ON/OFF
        end
    end

endmodule