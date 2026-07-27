module delayEnableGenerator (
    input wire clk,      // Clock input
    input wire rst_n,    // Reset input (active low)
    output reg out_delayed  // Output delayed signal
);

parameter integer N = 10;  // Number of cycles after which output should be '1'

reg [31:0] counter;  // 32-bit counter to count clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;  // Reset counter
        out_delayed <= 0;  // Reset output
    end else begin
        if (counter < N) begin
            counter <= counter + 1;  // Increment counter
        end else begin
            out_delayed <= 1;  // Output '1' after N cycles
        end
    end
end

endmodule
