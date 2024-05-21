`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 01:47:10 PM
// Design Name: 
// Module Name: main_control
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


module main_control import RISCV::*; (
    input op_type optype,
    input wire valid_op,
    
    // ALU
    output wire [1:0] aluop,
    output wire alu_src,
    
    // RAM
    output wire memread,
    output wire memwrite,
    
    // Register file
    output wire mem_to_reg,
    output wire regwrite,
    
    // Branch decider
    output wire is_branch,
    output wire is_jump
);   
   
   reg alu_src_reg, memread_reg, memwrite_reg, regwrite_reg;
   
    always_comb
    case (optype)
        OP_IMM, LOAD, STORE, JALR, LUI, AUIPC: alu_src_reg = 1'b1; // I-type S-type and U-type
        default: alu_src_reg = 1'b0;
    endcase
    
    always_comb
    case (optype)
        LOAD   : begin memread_reg = 1'b1; memwrite_reg = 1'b0; end
        STORE  : begin memread_reg = 1'b0; memwrite_reg = 1'b1; end
        default: begin memread_reg = 1'b0; memwrite_reg = 1'b0; end 
    endcase
    
    always_comb
    case (optype)
        LOAD, OP_IMM, OP, JAL, JALR, LUI, AUIPC: regwrite_reg = 1'b1;
        default: regwrite_reg = 1'b0; 
    endcase
   
    assign aluop[1] = optype == OP; // R-type
    assign aluop[0] = optype == BRANCH; // B-type
    
    assign is_branch = optype == BRANCH;
    assign is_jump = optype == JALR || optype == JAL;
    
    assign alu_src = alu_src_reg;
    assign memread = memread_reg;
    assign memwrite = valid_op ? memwrite_reg : 1'b0;
    assign regwrite = valid_op ? regwrite_reg : 1'b0;
    assign mem_to_reg = valid_op ? optype == LOAD : 1'b0;
endmodule
