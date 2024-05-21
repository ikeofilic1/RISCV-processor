`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 05:14:45 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit #(parameter n = 32, m = 5) (
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    input [m-1:0] EX_MEM_rd, MEM_WB_rd,
    input [m-1:0] ID_EX_rs1, ID_EX_rs2,
    
    output reg [1:0] rs1_fwd, rs2_fwd
);

    // 00 => use the register values as is (Do not forward)
    // 10 => forward from EX_MEM stage
    // 11 => forward from MEM_WB stage

    always @ (*) begin
    // TODO: I don't think MemToReg and RegWrite are '1' at the same time because we stall in a LOAD
        if (EX_MEM_RegWrite && ID_EX_rs1 != '0 && (EX_MEM_rd == ID_EX_rs1))
            rs1_fwd = 2'b10;
        else if (MEM_WB_RegWrite && ID_EX_rs1 != '0 && (MEM_WB_rd == ID_EX_rs1))
            rs1_fwd = 2'b11;
        else
            rs1_fwd = 2'b00;
    end
    
    always @ (*) begin
    // I don't think MemToReg and RegWrite can be '1' at the same time because we stall in a LOAD
        if (EX_MEM_RegWrite && ID_EX_rs2 != '0 && (EX_MEM_rd == ID_EX_rs2))
            rs2_fwd = 2'b10;
        else if (MEM_WB_RegWrite && ID_EX_rs2 != '0 && (MEM_WB_rd == ID_EX_rs2))
            rs2_fwd = 2'b11;
        else
            rs2_fwd = 2'b00;
    end
    
endmodule
