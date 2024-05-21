`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2024 05:49:19 PM
// Design Name: 
// Module Name: branch_decider
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


module branch_decider2 import RISCV::*; (
    input wire is_jump,
    input wire is_branch,
    
    input wire [31:0] operand1,
    input wire [31:0] operand2,
    input wire [2:0] funct3,
    
    output branch_taken
);

    localparam [2:0] BEQ  = 3'h0;
    localparam [2:0] BNE  = 3'h1;
    localparam [2:0] BLT  = 3'h4;
    localparam [2:0] BGE  = 3'h5;
    localparam [2:0] BLTU = 3'h6;
    localparam [2:0] BGEU = 3'h7;
    
    reg branch_taken_reg;

    always_comb
        case (funct3)
            BEQ  : branch_taken_reg = operand1 == operand2;
            BNE  : branch_taken_reg = operand1 != operand2;
            BLT  : branch_taken_reg = $signed(operand1) < $signed(operand2);
            BGE  : branch_taken_reg = $signed(operand1) >= $signed(operand2);
            BLTU : branch_taken_reg = operand1 < operand2;
            BGEU : branch_taken_reg = operand1 >= operand2;
            default : branch_taken_reg = 1'b0;
        endcase
        
    assign branch_taken = is_jump || (is_branch && branch_taken_reg);

endmodule
