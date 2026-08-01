`timescale 1ns / 1ps

module processing_rp
(
    input wire clk,
    input wire rst,

    input wire [7:0] sample_in,
    input wire sample_valid,

    output reg [7:0] sample_out,
    output reg sample_out_valid
);


reg [7:0] sample1;
reg [7:0] sample2;
reg [7:0] sample3;


reg [9:0] sum;


always @(posedge clk)
begin

    if(rst)
    begin
        sample1 <= 0;
        sample2 <= 0;
        sample3 <= 0;

        sample_out <= 0;
        sample_out_valid <= 0;
    end


    else
    begin

        sample_out_valid <= 0;


        if(sample_valid)
        begin

            sum = sample_in + sample1 + sample2 + sample3;


            sample_out <= sum >> 2;


            sample_out_valid <= 1;


            sample3 <= sample2;
            sample2 <= sample1;
            sample1 <= sample_in;

        end

    end

end


endmodule