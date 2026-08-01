`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 14:40:05
// Design Name: 
// Module Name: uart_tx
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

module uart_tx(

input clk,
input rst,

input baud_tick,

input [7:0] data_in,
input data_valid,

output reg tx

);

reg [9:0] shift;
reg [3:0] bit_index;
reg busy;

always @(posedge clk)

begin

if(rst)

begin

tx<=1;
busy<=0;

end

else

begin

if(data_valid && !busy)

begin

shift<={1'b1,data_in,1'b0};

busy<=1;

bit_index<=0;

end

if(busy && baud_tick)

begin

tx<=shift[0];

shift<={1'b1,shift[9:1]};

if(bit_index==9)

begin

busy<=0;

tx<=1;

end

else

bit_index<=bit_index+1;

end

end

end

endmodule
