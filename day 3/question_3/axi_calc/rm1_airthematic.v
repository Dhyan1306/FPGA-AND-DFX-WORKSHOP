module rm_core (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    input  wire [1:0]  opcode,
    input  wire        start,
    output reg  [31:0] result,
    output reg          done
);
    reg [31:0] result_next;

    always @(*) begin
        case (opcode)
            2'b00: result_next = operand_a + operand_b;
            2'b01: result_next = operand_a - operand_b;
            2'b10: result_next = operand_a * operand_b;
            2'b11: result_next = (operand_b == 32'd0) ? 32'hFFFFFFFF
                                    : ($signed(operand_a) / $signed(operand_b));
            default: result_next = 32'd0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 32'd0;
            done   <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start) begin
                result <= result_next;
                done   <= 1'b1;
            end
        end
    end
endmodule