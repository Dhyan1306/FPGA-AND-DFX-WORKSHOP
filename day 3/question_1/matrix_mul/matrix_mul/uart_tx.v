module uart_tx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] data_in,
    input  wire       tx_start,
    output reg        tx,
    output reg        tx_busy
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam IDLE=0, START=1, DATA=2, STOP=3;

    reg [1:0] state = IDLE;
    reg [15:0] clk_cnt = 0;
    reg [2:0] bit_idx = 0;
    reg [7:0] tx_shift = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            tx      <= 1'b1;
            tx_busy <= 0;
            clk_cnt <= 0;
            bit_idx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    if (tx_start) begin
                        tx_shift <= data_in;
                        tx_busy  <= 1;
                        state    <= START;
                        clk_cnt  <= 0;
                    end
                end
                START: begin
                    tx <= 1'b0;
                    if (clk_cnt < CLKS_PER_BIT-1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        state   <= DATA;
                    end
                end
                DATA: begin
                    tx <= tx_shift[bit_idx];
                    if (clk_cnt < CLKS_PER_BIT-1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        if (bit_idx < 7) begin
                            bit_idx <= bit_idx + 1;
                        end else begin
                            bit_idx <= 0;
                            state   <= STOP;
                        end
                    end
                end
                STOP: begin
                    tx <= 1'b1;
                    if (clk_cnt < CLKS_PER_BIT-1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt  <= 0;
                        tx_busy  <= 0;
                        state    <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule