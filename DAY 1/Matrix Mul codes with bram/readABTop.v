`timescale 1ns / 1ps

module readABTop(clk,reset,addressAcounter,addressBcounter );
input clk,reset;
output [3:0]addressAcounter,addressBcounter;
Bcounter ins1(clk,reset,addressBcounter);
Acounter ins2(clk,reset,addressBcounter,addressAcounter);

endmodule
