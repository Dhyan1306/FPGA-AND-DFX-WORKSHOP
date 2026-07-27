module matrix_top(
    input clk,
    input rst,
    input start,
    output done,
    output [15:0] result
);
reg [7:0] mult_a;
reg [7:0] mult_b;
wire [15:0] mult_out;
wire [15:0] acc_sum;
wire acc_clear;
wire acc_enable;
wire [2:0] state;

matrix_fsm fsm_inst(
    .clk(clk),
    .rst(rst),
    .start(start),
    .acc_clear(acc_clear),
    .acc_enable(acc_enable),
    .done(done),
    .state(state)
);

multiplier mul_inst(
    .a(mult_a),
    .b(mult_b),
    .p(mult_out)
);
accumulator acc_inst(
    .clk(clk),
    .rst(rst),
    .clear(acc_clear),
    .enable(acc_enable),
    .data_in(mult_out),
    .sum(acc_sum)
);
always @(*)
begin
    case(state)
        3'd2:
        begin
            mult_a = 8'd1; // A00
            mult_b = 8'd5; // B00
        end
        3'd3:
        begin
            mult_a = 8'd2; // A01
            mult_b = 8'd7; // B10
        end
        default:
        begin
            mult_a = 0;
            mult_b = 0;
        end
    endcase
end
assign result = acc_sum;
endmodule