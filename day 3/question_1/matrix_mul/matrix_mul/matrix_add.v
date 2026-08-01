module rm_compute (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire signed [399:0] matA,
    input  wire signed [399:0] matB,
    output reg  signed [399:0] result,
    output reg          done
);
    integer i;
    reg busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            busy <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                for (i = 0; i < 25; i = i + 1) begin
                    result[i*16 +: 16] <= matA[i*16 +: 16] + matB[i*16 +: 16];
                end
                done <= 1;
                busy <= 1;
            end else if (!start) begin
                busy <= 0;
            end
        end
    end
endmodule