`timescale 1ns / 1ps

module dual_rp_top (
    input  wire       clk,      // 100MHz System Clock
    input  wire       rst,      // Reset button (BTNC)
    output wire [7:0] LED       // 8 LEDs total
);

    // --- Clock Divider: 1Hz Tick ---
    reg [26:0] count = 0;
    reg        tick  = 0;

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            tick  <= 1'b0;
        end else begin
            if (count == 100_000_000 - 1) begin
                count <= 0;
                tick  <= 1'b1;
            end else begin
                count <= count + 1'b1;
                tick  <= 1'b0;
            end
        end
    end

    // --- Reconfigurable Partition 1 (Controls LED[3:0]) ---
    rp1_module rp1_inst (
        .clk    (clk),
        .rst    (rst),
        .tick   (tick),
        .led_out(LED[3:0])
    );

    // --- Reconfigurable Partition 2 (Controls LED[7:4]) ---
    rp2_module rp2_inst (
        .clk    (clk),
        .rst    (rst),
        .tick   (tick),
        .led_out(LED[7:4])
    );

endmodule
