`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.08.2026 10:29:28
// Design Name: 
// Module Name: rm_pkg
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


// rm_pkg.sv
// Shared parameters for the Reconfigurable Partition (RP).
// RM1 and RM2 both import this package so their port widths
// stay identical - required for DFX boundary matching.

package rm_pkg;
    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 8;
endpackage
