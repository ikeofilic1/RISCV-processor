`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2024 06:01:35 PM
// Design Name: 
// Module Name: imm_gen
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

module imm_gen import RISCV::*; (
    input [31:0] inst,
    output reg [31:0] immediate
);
    
    always @ (inst)  case (op_type'(inst[6:2]))
        LOAD, OP_IMM, JALR: immediate = {{20{inst[31]}}, inst[31:20]};
        STORE:  immediate = {{20{inst[31]}}, inst[31:25], inst[11:7]};
        AUIPC, LUI: immediate = {inst[31:12], 12'b0};
        JAL: begin
            immediate[0] = 1'b0;
            {immediate[20], immediate[10:1], immediate[11], immediate[19:12]} = inst[31:12];
            immediate[31:21] = {11{inst[31]}};
        end
        BRANCH: immediate = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
        default: immediate = 32'd0;
    endcase
endmodule
