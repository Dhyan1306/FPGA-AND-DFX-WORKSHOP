`timescale 1ns / 1ps

module led_pattern_rm (
    input  wire       clk,
    input  wire       rst,
    input  wire       tick,
    output reg  [7:0] led_out
);

    reg dir = 0; // 0 = Shift Left, 1 = Shift Right

    always @(posedge clk) begin
        if (rst) begin
            led_out <= 8'b0000_0001;
            dir     <= 1'b0;
        end else if (tick) begin
            if (!dir) begin
                led_out <= led_out << 1;
                if (led_out == 8'b0100_0000) dir <= 1'b1;
            end else begin
                led_out <= led_out >> 1;
                if (led_out == 8'b0000_0010) dir <= 1'b0;
            end
        end
    end

endmodule