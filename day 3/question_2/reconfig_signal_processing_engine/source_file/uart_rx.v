`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 14:39:34
// Design Name: 
// Module Name: uart_rx
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

`timescale 1ns / 1ps

module uart_rx
(
    input  wire       clk,
    input  wire       rst,

    input  wire       rx,
    input  wire       baud_tick,

    output reg [7:0]  data_out,
    output reg        data_valid
);


localparam IDLE  = 3'd0;
localparam START = 3'd1;
localparam DATA  = 3'd2;
localparam STOP  = 3'd3;


reg [2:0] state;


// Bit counter
reg [2:0] bit_count;


// Half baud counter for start-bit sampling
reg sample_start;


// Data shift register
reg [7:0] rx_shift;



//--------------------------------------------------
// UART Receiver FSM
//--------------------------------------------------

always @(posedge clk)
begin

    if(rst)
    begin
        state       <= IDLE;
        bit_count   <= 0;
        rx_shift    <= 0;
        data_out    <= 0;
        data_valid  <= 0;
        sample_start<= 0;
    end


    else
    begin

        data_valid <= 0;


        case(state)



        //--------------------------------------------------
        // Waiting for start bit
        //--------------------------------------------------

        IDLE:
        begin

            bit_count <= 0;


            // UART line goes LOW for start bit
            if(rx == 1'b0)
            begin
                state <= START;
            end

        end



        //--------------------------------------------------
        // Confirm start bit
        //--------------------------------------------------

        START:
        begin

            if(baud_tick)
            begin

                // sample middle of start bit

                if(rx == 1'b0)
                begin
                    state <= DATA;
                    bit_count <= 0;
                end

                else
                begin
                    state <= IDLE;
                end

            end

        end




        //--------------------------------------------------
        // Receive 8 data bits
        //--------------------------------------------------

        DATA:
        begin

            if(baud_tick)
            begin

                rx_shift[bit_count] <= rx;


                if(bit_count == 3'd7)
                begin
                    bit_count <= 0;
                    state <= STOP;
                end

                else
                begin
                    bit_count <= bit_count + 1'b1;
                end

            end

        end




        //--------------------------------------------------
        // Stop bit
        //--------------------------------------------------

        STOP:
        begin

            if(baud_tick)
            begin

                if(rx == 1'b1)
                begin

                    data_out   <= rx_shift;
                    data_valid <= 1'b1;

                end

                state <= IDLE;

            end

        end



        default:
        begin
            state <= IDLE;
        end



        endcase

    end

end


endmodule