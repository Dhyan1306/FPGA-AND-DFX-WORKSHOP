module uart_controller (
    input  wire clk,
    input  wire rst,
    input  wire [7:0] rx_data,
    input  wire       rx_valid,
    output reg  [7:0] tx_data,
    output reg         tx_start,
    input  wire        tx_busy,
    output reg         wr_en,
    output reg  [1:0]  wr_matrix,
    output reg  [4:0]  wr_addr,
    output reg  signed [15:0] wr_data,
    output reg  [1:0]  rd_matrix,
    output reg  [4:0]  rd_addr,
    input  wire signed [15:0] rd_data,
    output reg  [1:0]  op_select,
    output reg          start_compute,
    input  wire          compute_done
);
    localparam S_IDLE      = 0,
               S_RX_A      = 1,
               S_RX_B      = 2,
               S_COMPUTE   = 3,
               S_TX_RESULT = 4;

    reg [3:0] state = S_IDLE;
    reg [4:0] elem_idx;
    reg       byte_phase;
    reg [7:0] high_byte;
    reg [4:0] tx_elem_cnt;
    reg       tx_phase;
    reg       tx_wait;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= S_IDLE;
            wr_en         <= 0;
            tx_start      <= 0;
            start_compute <= 0;
            elem_idx      <= 0;
            byte_phase    <= 0;
            tx_wait       <= 0;
        end else begin
            wr_en    <= 0;
            tx_start <= 0;
            start_compute <= 0;

            case (state)
                S_IDLE: begin
                    elem_idx   <= 0;
                    byte_phase <= 0;
                    if (rx_valid) begin
                        case (rx_data)
                            8'h01: op_select <= 2'd1;
                            8'h02: op_select <= 2'd2;
                            8'h03: op_select <= 2'd3;
                            default: op_select <= 2'd0;
                        endcase
                        state <= S_RX_A;
                    end
                end

                S_RX_A: begin
                    if (rx_valid) begin
                        if (byte_phase == 0) begin
                            high_byte  <= rx_data;
                            byte_phase <= 1;
                        end else begin
                            wr_en      <= 1;
                            wr_matrix  <= 2'd0;
                            wr_addr    <= elem_idx;
                            wr_data    <= {high_byte, rx_data};
                            byte_phase <= 0;
                            if (elem_idx == 24) begin
                                elem_idx <= 0;
                                state    <= S_RX_B;
                            end else
                                elem_idx <= elem_idx + 1;
                        end
                    end
                end

                S_RX_B: begin
                    if (rx_valid) begin
                        if (byte_phase == 0) begin
                            high_byte  <= rx_data;
                            byte_phase <= 1;
                        end else begin
                            wr_en      <= 1;
                            wr_matrix  <= 2'd1;
                            wr_addr    <= elem_idx;
                            wr_data    <= {high_byte, rx_data};
                            byte_phase <= 0;
                            if (elem_idx == 24) begin
                                elem_idx      <= 0;
                                state         <= S_COMPUTE;
                                start_compute <= 1;
                            end else
                                elem_idx <= elem_idx + 1;
                        end
                    end
                end

                S_COMPUTE: begin
                    if (compute_done) begin
                        tx_elem_cnt <= 0;
                        tx_phase    <= 0;
                        rd_matrix   <= 2'd2;
                        rd_addr     <= 0;
                        tx_wait     <= 0;
                        state       <= S_TX_RESULT;
                    end
                end

                S_TX_RESULT: begin
                    if (tx_start) begin
                        tx_wait <= 1;
                    end else if (tx_wait && tx_busy) begin
                        tx_wait <= 0;
                    end else if (!tx_busy && !tx_wait) begin
                        if (tx_phase == 0) begin
                            tx_data  <= rd_data[15:8];
                            tx_start <= 1;
                            tx_phase <= 1;
                        end else begin
                            tx_data  <= rd_data[7:0];
                            tx_start <= 1;
                            tx_phase <= 0;
                            if (tx_elem_cnt == 24) begin
                                state <= S_IDLE;
                            end else begin
                                tx_elem_cnt <= tx_elem_cnt + 1;
                                rd_addr     <= rd_addr + 1;
                            end
                        end
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end
endmodule