`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/08/2024 10:27:03 AM
// Design Name: 
// Module Name: testbench
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

module testbench();
reg clk;
reg reset;
reg [3:0] switch;
wire [7:0] led_out;
Matrix_Multiplier_top mmt1(clk,reset,led_out,switch );

initial
begin
    clk = 0;
    forever #50 clk = ~clk;
end

initial
begin
    reset = 1;
    switch = 0;
    #400 begin reset = 0; switch = 0; end
    #6000 begin switch = 4'd0;  end 
    #100 begin switch = 4'd1;  end 
    #100 begin switch = 4'd2;  end 
    #100 begin switch = 4'd3;  end 
    #100 begin switch = 4'd4;  end 
    #100 begin switch = 4'd5;  end 
    #100 begin switch = 4'd6;  end 
    #100 begin switch = 4'd7;  end 
    #100 begin switch = 4'd8;  end 
    #100 begin switch = 4'd0;  end 
    #100 begin switch = 4'd1;  end 
    #100 $stop;

end
endmodule
