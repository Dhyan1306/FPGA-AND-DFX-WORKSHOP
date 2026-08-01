module waveform_rp(

    input clk,
    input rst,
    input sample_tick,

    output reg [7:0] sample

);

always @(posedge clk)
begin

    if(rst)
        sample <= 8'd0;

    else if(sample_tick)
        sample <= sample + 8'd1;

end

endmodule