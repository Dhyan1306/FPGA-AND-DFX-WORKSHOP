`timescale 1ns / 1ps

module dfx_pattern_top (
    input  wire       clk,      // 100MHz Basys 3 Clock
    input  wire       rst,      // Reset button (BTNC)
    output wire [7:0] LED       // 8 LEDs
);

    // --- Clock Divider: Generate 1Hz tick from 100MHz system clock ---
    reg [26:0] count = 0;
    reg        tick  = 0;

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            tick  <= 1'b1;
        end else begin
            if (count == 100_000_000 - 1) begin // 1 second interval
                count <= 0;
                tick  <= 1'b1;
            end else begin
                count <= count + 1'b1;
                tick  <= 1'b0;
            end
        end
    end

    // --- Reconfigurable Partition Instance ---
    led_pattern_rm pattern_inst (
        .clk    (clk),
        .rst    (rst),
        .tick   (tick),
        .led_out(LED)
    );

endmodule