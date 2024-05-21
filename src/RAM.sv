`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 05:12:21 PM
// Design Name: 
// Module Name: RAM
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


module RAM #(parameter RAM_DEPTH = 256)
(
    input clk, re, we,
    input wire [31:0] w_data,
    input wire [31:0] addr,
    
    output reg [31:0] r_data // 8*NUM_BANKS-1
);
    reg [31:0] ram[RAM_DEPTH-1:0];
    initial $readmemh ("data.mem", ram);
    
    integer i;
    
    always @ (posedge clk)
        if (we) ram[addr] <= w_data;
        
    always @ (*)
        if (re) r_data <= ram[addr];
        else r_data <= '0;
        
endmodule
