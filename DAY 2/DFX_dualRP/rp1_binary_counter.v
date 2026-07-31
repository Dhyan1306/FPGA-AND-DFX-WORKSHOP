`timescale 1ns / 1ps

module rp1_module (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    output reg  [3:0] led_out   // 4 bits for LED[3:0]
);

    always @(posedge clk) begin
        if (rst) begin
            led_out <= 4'd0;
        end else if (tick) begin
            led_out <= led_out + 1'b1;
        end
    end

endmodule