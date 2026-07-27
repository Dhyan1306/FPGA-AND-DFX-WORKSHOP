`timescale 1ns / 1ps

module bypass_counter(clk,reset,adder_bypass);
input clk;
input reset;
output reg adder_bypass;
reg [1:0] count;
always@(posedge clk )
begin
    if(reset)
    begin
        count<=0;
        adder_bypass<=0;
    end
    else
    begin
        if (count == 2)
        begin
            adder_bypass<=0;
            count<=0;
        end
        else if (count == 0)
        begin
            adder_bypass<=1;
            count<=count+1;
        end
        else
        begin
            adder_bypass<=0;
            count<=count+1;
        end
    end
end
endmodule
