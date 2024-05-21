`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 01:29:38 PM
// Design Name: 
// Module Name: pc_reg
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


module pc_reg #(n = 32) 
(
    input clk, rst, we,
    input [n-1:0] pc_in,
    output reg [n-1:0] pc_out,
    output reg ce
 );
    always @ (posedge clk)
        if (ce) begin if (we) pc_out = pc_in; end else pc_out = '0;
    always @ (posedge clk)
        if (rst) ce = 1'b0; else ce = 1'b1; 
endmodule
