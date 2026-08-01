module waveform_rp(

    input clk,
    input rst,
    input sample_tick,

    output reg [7:0] sample

);

reg [7:0] counter;

always @(posedge clk)
begin

    if(rst)
    begin
        counter <= 8'd0;
        sample <= 8'd0;
    end

    else if(sample_tick)
    begin

        if(counter < 100)
            sample <= 8'hFF;
        else
            sample <= 8'h00;

        if(counter == 199)
            counter <= 8'd0;
        else
            counter <= counter + 1;

    end

end

endmodule