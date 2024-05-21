`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2024 04:59:21 PM
// Design Name: 
// Module Name: register_file
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


module register_file #(parameter N = 32, n = 32, localparam M = $clog2(N)) 
(
    input clk,
    input [n-1:0] data_in,
    input write_enable,
    input [M-1:0] write_addr,
    input [M-1:0] read_addr1, read_addr2,
    output [n-1:0] data_out1, data_out2,
    output reg [N-1:0][n-1:0] registers  
);  
    reg [n-1:0] data [N-1:0];
     
    integer i;     
    initial
        for (i = 0; i < N; i = i + 1) data[i] = {n{1'b0}};
        
     always @ (*) 
        for (i = 0; i < N; i = i + 1) registers[i] = data[i];
    
    always @(posedge clk)
        if (write_enable && write_addr) data[write_addr] = data_in; 
    
    assign data_out1 = (write_enable && read_addr1 == write_addr) ? data_in : data[read_addr1];
    assign data_out2 = (write_enable && read_addr2 == write_addr) ? data_in : data[read_addr2];
endmodule