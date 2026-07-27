module accumulator
#(
    parameter WIDTH = 16
)
(
    input clk,
    input rst,
    input clear,
    input enable,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] sum
);
always @(posedge clk)
begin
    if(rst)
        sum <= 0;
    else if(clear)
        sum <= 0;
    else if(enable)
        sum <= sum + data_in;
end
endmodule