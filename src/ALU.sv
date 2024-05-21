`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 07:24:11 PM
// Design Name: 
// Module Name: ALU
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


module ALU import RISCV::*; #(n = 32)
(
    input alu_func_t func,
    input wire [n-1:0] op1, op2,
    output reg [n-1:0] result,
    output zero
);
    
    // TODO: when multiplying, pass more funct7 bits here
    // func = {funct7[5], funct3}

    wire [n-1:0] and_res = op1 & op2;
    wire [n-1:0] or_res  = op1 | op2;
    wire [n-1:0] xor_res = op1 ^ op2;
    
    wire [n-1:0] add_res;
    wire subtract = func[2];
    
    assign zero = result == '0;
    
    adder_subtractor #(n) adder
    (
        .A(op1),
        .B(op2),
        .sub(subtract),
        .R(add_res)
    );
    
    always_comb
    case (func)
        ADD, SUB: result = add_res;
        OR: result = or_res;
        AND: result = and_res;
        default: result = '0;
    endcase

endmodule
