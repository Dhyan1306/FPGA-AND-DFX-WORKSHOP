`timescale 1ns / 1ps

module led_pattern_rm (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    output reg  [7:0] led_out
);

    always @(posedge clk) begin
        if (rst) begin
            led_out <= 8'd0;
        end else if (tick) begin
            led_out <= led_out + 1'b1; // Increment counter
        end
    end

endmodule