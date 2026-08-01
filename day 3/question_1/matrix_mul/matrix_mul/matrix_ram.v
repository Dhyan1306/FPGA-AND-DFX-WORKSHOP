module matrix_ram (
    input  wire        clk,
    input  wire        rst,
    input  wire        wr_en,
    input  wire [1:0]  wr_matrix,
    input  wire [4:0]  wr_addr,
    input  wire signed [15:0] wr_data,
    input  wire [1:0]  rd_matrix,
    input  wire [4:0]  rd_addr,
    output reg  signed [15:0] rd_data,
    output wire signed [399:0] matA,
    output wire signed [399:0] matB,
    input  wire signed [399:0] result_in,
    input  wire        result_wr_en
);
    reg signed [15:0] MA [0:24];
    reg signed [15:0] MB [0:24];
    reg signed [15:0] MR [0:24];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 25; i = i + 1) begin
                MA[i] <= 0;
                MB[i] <= 0;
                MR[i] <= 0;
            end
        end else begin
            if (wr_en) begin
                case (wr_matrix)
                    2'd0: MA[wr_addr] <= wr_data;
                    2'd1: MB[wr_addr] <= wr_data;
                    2'd2: MR[wr_addr] <= wr_data;
                    default: ;
                endcase
            end
            if (result_wr_en) begin
                for (i = 0; i < 25; i = i + 1) begin
                    MR[i] <= result_in[i*16 +: 16];
                end
            end
        end
    end

    always @(*) begin
        case (rd_matrix)
            2'd0: rd_data = MA[rd_addr];
            2'd1: rd_data = MB[rd_addr];
            2'd2: rd_data = MR[rd_addr];
            default: rd_data = 16'sd0;
        endcase
    end

    genvar g;
    generate
        for (g = 0; g < 25; g = g + 1) begin : EXPOSE
            assign matA[g*16 +: 16] = MA[g];
            assign matB[g*16 +: 16] = MB[g];
        end
    endgenerate
endmodule