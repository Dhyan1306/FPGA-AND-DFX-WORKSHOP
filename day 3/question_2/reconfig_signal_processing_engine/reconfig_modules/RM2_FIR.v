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


reg [7:0] x1,x2,x3;

reg [9:0] acc;


always @(posedge clk)
begin

    if(rst)
    begin
        x1<=0;
        x2<=0;
        x3<=0;

        sample_out<=0;
        sample_out_valid<=0;
    end


    else
    begin

        sample_out_valid<=0;


        if(sample_valid)
        begin

            acc = sample_in+x1+x2+x3;


            sample_out <= acc >> 2;


            sample_out_valid<=1;


            x3<=x2;
            x2<=x1;
            x1<=sample_in;

        end

    end

end


endmodule