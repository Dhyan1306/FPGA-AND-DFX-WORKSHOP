module matrix_fsm(
    input clk,
    input rst,
    input start,
    output reg acc_clear,
    output reg acc_enable,
    output reg done,
    output reg [2:0] state
);

localparam IDLE      = 3'd0;
localparam CLEAR_ACC = 3'd1;
localparam MUL_1     = 3'd2;
localparam MUL_2     = 3'd3;
localparam STORE     = 3'd4;
localparam DONE      = 3'd5;

always @(posedge clk)
begin
    if(rst)
    begin
        state      <= IDLE;
        acc_clear  <= 0;
        acc_enable <= 0;
        done       <= 0;
    end
    else
    begin
        case(state)

        //-----------------------------------
        IDLE:
        //-----------------------------------
        begin
            acc_clear  <= 0;
            acc_enable <= 0;
            done       <= 0;
            if(start)
                state <= CLEAR_ACC;
        end
        //-----------------------------------
        CLEAR_ACC:
        //-----------------------------------
        begin
            acc_clear  <= 1;
            acc_enable <= 0;
            state <= MUL_1;
        end
        //-----------------------------------
        MUL_1:
        //-----------------------------------
        begin
            acc_clear  <= 0;
            acc_enable <= 1;
            state <= MUL_2;
        end
        //-----------------------------------
        MUL_2:
        //-----------------------------------
        begin
            acc_enable <= 1;

            state <= STORE;
        end
        //-----------------------------------
        STORE:
        //-----------------------------------
        begin
            acc_enable <= 0;

            state <= DONE;
        end
        //-----------------------------------
        DONE:
        //-----------------------------------
        begin
            done <= 1;
        end
        default:
            state <= IDLE;
        endcase
    end
end
endmodule