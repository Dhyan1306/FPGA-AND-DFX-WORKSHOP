module dfx_wrapper (
    input  wire        clk,
    input  wire        rst,
    input  wire        start_compute,
    output wire         compute_done,
    input  wire signed [399:0] matA,
    input  wire signed [399:0] matB,
    output wire signed [399:0] result_out,
    output wire          result_wr_en
);

    rm_compute U_RM (
        .clk(clk),
        .rst(rst),
        .start(start_compute),
        .matA(matA),
        .matB(matB),
        .result(result_out),
        .done(compute_done)
    );

    assign result_wr_en = compute_done;

endmodule