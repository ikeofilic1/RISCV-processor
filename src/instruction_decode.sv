`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 05:32:11 PM
// Design Name: 
// Module Name: instruction_decode
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

// Find a way to move this to the RISCV package
module instruction_decode import RISCV::op_type; (
    input  wire [31:0] inst,
    output wire [4:0] src_addr1, src_addr2, dest_addr,
    output wire [31:0] immediate,
    output wire [6:0] funct7,
    output wire [2:0] funct3,
    output op_type opcode
);
    assign opcode = op_type'(inst[6:2]);
    assign src_addr1 = inst[19:15];
    assign src_addr2 = inst[24:20];
    assign funct7 = inst[31:25];
    assign funct3 = inst[14:12];
    assign dest_addr = inst[11:7];
    
    imm_gen gen_inst(inst, immediate);
endmodule
