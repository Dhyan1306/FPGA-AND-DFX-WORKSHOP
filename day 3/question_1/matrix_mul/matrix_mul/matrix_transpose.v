module rm_compute (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire signed [399:0] matA,
    input  wire signed [399:0] matB,
    output reg  signed [399:0] result,
    output reg          done
);
    reg [4:0] row, col;
    reg [2:0] k;
    reg signed [31:0] acc;
    reg busy;

    localparam IDLE = 0, CALC = 1, FIN = 2;
    reg [1:0] state;

    wire signed [15:0] a_el = matA[(row*5 + k)*16 +: 16];
    wire signed [15:0] b_el = matB[(k*5 + col)*16 +: 16];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done  <= 0;
            busy  <= 0;
            row   <= 0;
            col   <= 0;
            k     <= 0;
            acc   <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: begin
                    if (start && !busy) begin
                        row   <= 0;
                        col   <= 0;
                        k     <= 0;
                        acc   <= 0;
                        busy  <= 1;
                        state <= CALC;
                    end else if (!start) begin
                        busy <= 0;
                    end
                end
                CALC: begin
                    acc <= acc + a_el * b_el;
                    if (k == 4) begin
                        result[(row*5 + col)*16 +: 16] <= acc + a_el * b_el;
                        k   <= 0;
                        acc <= 0;
                        if (col == 4) begin
                            col <= 0;
                            if (row == 4) begin
                                state <= FIN;
                            end else begin
                                row <= row + 1;
                            end
                        end else begin
                            col <= col + 1;
                        end
                    end else begin
                        k <= k + 1;
                    end
                end
                FIN: begin
                    done  <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule