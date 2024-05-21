`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 08:05:39 PM
// Design Name: 
// Module Name: adder_subtractor
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


module adder_subtractor #(N = 8)
(
    input [N-1:0] A, B,
    output [N-1:0] R,
    input sub
);    
    // TODO: switch to hierarchical CLA
    assign R = sub ? A - B : A + B;
endmodule
