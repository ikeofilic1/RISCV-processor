`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 05:49:47 PM
// Design Name: 
// Module Name: instruction_fetch_stage
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


module execution_stage (
    // Global Inputs
    //input clk,                          // Clock input
    
    // Inputs from instruction_decode_stage
    input [31:0] reg_out1,        // Data output 1 from register file in ID stage
    input [31:0] reg_out2,        // Data output 2 from register file in ID stage
    input [31:0] immediate_value, // Immediate value from ID stage
    
//    // Forwarding inputs
    input [31:0] EX_MEM_result,
    input [31:0] MEM_WB_result,
    input [1:0] op1_fwd_src,
    input [1:0] op2_fwd_src,
    
    output [31:0] reg_out2_fwd_o,
    
    // ALU inputs
    input alu_src,                // ALU source selection from ID stage
    input [1:0] aluop,            // ALU operation code from ID stage
    input [3:0] alu_ctrl_code,    // ALU control code from ID stage
    
    output [31:0] alu_result,
    output alu_zero,
    
    // Branch decider
    input is_branch,
    input is_jump,
    output branch_taken  
);
    import RISCV::alu_func_t;
    
    reg [31:0] reg_out2_fwd, reg_out1_fwd;
    wire [31:0] operand1, operand2;
    alu_func_t alu_func;
    
    assign operand1 = reg_out1_fwd;
    assign operand2 = alu_src ? immediate_value : reg_out2_fwd;
    assign reg_out2_fwd_o = reg_out2_fwd;
    
    always_comb
        case (op1_fwd_src)
            2'b00, 2'b01: reg_out1_fwd = reg_out1;
            2'b10: reg_out1_fwd = EX_MEM_result;
            2'b11: reg_out1_fwd = MEM_WB_result;
        endcase
        
    always_comb
        case (op2_fwd_src)
            2'b00, 2'b01: reg_out2_fwd = reg_out2;
            2'b10: reg_out2_fwd = EX_MEM_result;
            2'b11: reg_out2_fwd = MEM_WB_result;
        endcase
    
     alu_control ac_inst
    (
        .aluop(aluop),
        .ctrl_code(alu_ctrl_code),
        .alu_func(alu_func)
    );
    
    ALU alu0
    (
        .func(alu_func),
        .op1(operand1),
        .op2(operand2),
        .result(alu_result),
        .zero(alu_zero)
    );
    
    branch_decider2 branch_decide_inst (
        .is_jump(is_jump),
        .is_branch(is_branch),
        .operand1(reg_out1_fwd),
        .operand2(reg_out2_fwd),
        .funct3(alu_ctrl_code[2:0]),
        
        .branch_taken(branch_taken)
    );
endmodule
