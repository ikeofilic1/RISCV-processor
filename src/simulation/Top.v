`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2024 07:05:46 PM
// Design Name: 
// Module Name: Top
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


module Top(
    input clk,
    input [3:0] PB,
    output [15:0] led,
    output [3:0] an,
    output [7:0] seg
);
    // PB[0] => rst
    // PB[1] => onoff
    
    assign led = 16'h0000;
    
    reg on_off = 1;
    reg prev_pb;
    wire pb_edge = ~prev_pb & PB[1];
    
    always @ (posedge clk)
        prev_pb <= PB[1];
    
    always @ (posedge pb_edge)
        on_off <= ~on_off;
    
    inst_five_stage_pipelined ss_inst
    (
        .clk(clk & on_off), .seg_clk(clk), .rst(PB[0]), .seg(seg), .an(an)
    );
endmodule
