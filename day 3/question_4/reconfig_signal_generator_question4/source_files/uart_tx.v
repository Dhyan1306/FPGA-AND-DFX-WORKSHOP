`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 12:12:45
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_tx #(
    parameter CLKS_PER_BIT = 868   // 100 MHz / 115200 baud
)
(
    input clk,
    input rst,

    input tx_start,
    input [7:0] tx_data,

    output reg tx,
    output reg tx_busy,
    output reg tx_done
);

localparam IDLE      = 3'd0;
localparam START_BIT = 3'd1;
localparam DATA_BITS = 3'd2;
localparam STOP_BIT  = 3'd3;
localparam CLEANUP   = 3'd4;

reg [2:0] state;
reg [15:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 1'b0;
        tx_done <= 1'b0;
        clk_count <= 16'd0;
        bit_index <= 3'd0;
        data_reg <= 8'd0;
    end
    else
    begin
        case(state)

        //------------------------------------------------
        IDLE:
        begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            tx_done <= 1'b0;
            clk_count <= 16'd0;
            bit_index <= 3'd0;

            if(tx_start)
            begin
                tx_busy <= 1'b1;
                data_reg <= tx_data;
                state <= START_BIT;
            end
        end

        //------------------------------------------------
        START_BIT:
        begin
            tx <= 1'b0;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= DATA_BITS;
            end
        end

        //------------------------------------------------
        DATA_BITS:
        begin
            tx <= data_reg[bit_index];

            if(clk_count < CLKS_PER_BIT-1)
            begin
                clk_count <= clk_count + 1;
            end
            else
            begin
                clk_count <= 0;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                begin
                    bit_index <= 0;
                    state <= STOP_BIT;
                end
            end
        end

        //------------------------------------------------
        STOP_BIT:
        begin
            tx <= 1'b1;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= CLEANUP;
            end
        end

        //------------------------------------------------
        CLEANUP:
        begin
            tx_done <= 1'b1;
            tx_busy <= 1'b0;
            state <= IDLE;
        end

        //------------------------------------------------
        default:
            state <= IDLE;

        endcase
    end
end

endmodule