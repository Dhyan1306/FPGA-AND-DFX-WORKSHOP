module Bcounter (
    input wire clk,       // Clock input
    input wire rst,       // Reset input (active high)
    output reg [3:0] count // 4-bit output representing the counter value (0 to 8)
);

always @(posedge clk ) begin
    if (rst) begin
        count <= 4'b1111; // Reset counter to 0 when reset is active high
    end else begin
        if (count == 4'b1000) begin
            count <= 4'b0000; // Reset counter to 0 when it reaches 8
        end else begin
            count <= count + 1; // Increment counter on each clock cycle
        end
    end
end

endmodule
