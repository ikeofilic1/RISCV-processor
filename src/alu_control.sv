`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 10:34:28 AM
// Design Name: 
// Module Name: alu_control
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


module alu_control import RISCV::alu_func_t; (
    input wire [1:0] aluop,
    input wire [3:0] ctrl_code,
    output alu_func_t alu_func
);
    import RISCV::*;    
    
    always_comb
        casez ({ctrl_code, aluop})
            6'b????_01: alu_func = SUB;
            6'b????_00: alu_func = ADD;
            6'b1???_10: alu_func = SUB;
            6'b0000_10: alu_func = ADD;
            6'b0110_10: alu_func = OR;
            6'b0111_10: alu_func = AND;
            default: alu_func = NOP;
        endcase
endmodule
