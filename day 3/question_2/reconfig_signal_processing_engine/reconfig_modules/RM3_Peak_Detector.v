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


reg [7:0] previous_sample;


always @(posedge clk)
begin

    if(rst)
    begin
        previous_sample <= 0;

        sample_out <= 0;
        sample_out_valid <= 0;
    end


    else
    begin

        sample_out_valid <= 0;


        if(sample_valid)
        begin

            if(sample_in > previous_sample)
                sample_out <= sample_in;

            else
                sample_out <= 0;


            sample_out_valid <= 1;


            previous_sample <= sample_in;

        end

    end

end


endmodule