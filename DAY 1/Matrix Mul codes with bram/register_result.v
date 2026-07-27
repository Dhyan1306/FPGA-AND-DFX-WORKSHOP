module register_result (
    input wire clk,           // Clock input
    input wire [31:0] inp1,  // 32-bit input data
    input wire reset,
    output  [31:0] oup1  // Output data delayed by one clock cycle
);

reg [31:0] reg_data;  // Register to store input data

always @(posedge clk) begin
    if (reset)
    begin
        reg_data <=0;
    end
    else 
    begin
        reg_data <= inp1;  // Store input on every clock edge
    end
end

assign oup1 = reg_data;  // Output the stored data

endmodule
