`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 11:43:10
// Design Name: 
// Module Name: rm_symmetry_checker_even
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


import rm_pkg::*;

module rm_symmetry_checker (
    input  logic                          clk,
    input  logic                          rst_n,
    input  logic                          start,
    input  logic [ADDR_WIDTH-1:0]         seq_len,

    output logic [ADDR_WIDTH-1:0]         bram_addr,
    input  logic signed [DATA_WIDTH-1:0]  bram_dout,
    output logic                          bram_en,

    output logic                          done,
    output logic                          result,
    output logic [2:0]                    led
);

    typedef enum logic [2:0] {IDLE, RD_LO, RD_HI, WAIT_HI, CMP, FINISH, HOLD} state_t;
    state_t state;

    logic [ADDR_WIDTH-1:0] n_lo, n_hi;
    logic signed [DATA_WIDTH-1:0] x_lo, x_hi;
    logic pass;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            n_lo     <= '0;
            n_hi     <= '0;
            pass     <= 1'b1;
            done     <= 1'b0;
            result   <= 1'b0;
            bram_en  <= 1'b0;
            bram_addr<= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        done  <= 1'b0;     // clear only when starting a new run
                        n_lo  <= 0;
                        n_hi  <= seq_len - 1;
                        pass  <= 1'b1;
                        state <= RD_LO;
                    end
                end

                // x[n] check against x[N-1-n]  (finite-length mapping of x[-n])
                RD_LO: begin
                    bram_addr <= n_lo;
                    bram_en   <= 1'b1;
                    state     <= RD_HI;
                end

                RD_HI: begin
                    x_lo      <= bram_dout;   // capture x[n_lo]
                    bram_addr <= n_hi;
                    state     <= WAIT_HI;
                end

                WAIT_HI: begin
                    x_hi  <= bram_dout;       // capture x[n_hi]
                    state <= CMP;
                end

                CMP: begin
                    if (x_lo != x_hi)
                        pass <= 1'b0;

                    if (n_lo >= n_hi) begin
                        state <= FINISH;
                    end else begin
                        n_lo  <= n_lo + 1;
                        n_hi  <= n_hi - 1;
                        state <= RD_LO;
                    end
                end

                FINISH: begin
                    bram_en <= 1'b0;
                    result  <= pass;
                    done    <= 1'b1;
                    state   <= HOLD;      // new state - stay here, don't auto-return to IDLE
                end
                
                HOLD: begin
                    // done and result stay latched here
                    if (!start)            // wait for user to release the switch
                        state <= IDLE;
                end
            endcase
        end
    end

    // LED[0]=Even, LED[1]=Odd(unused here), LED[2]=Done
    assign led = {1'b0, 1'b0, (done & result)};

endmodule
