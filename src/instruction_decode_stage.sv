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


module instruction_decode_stage (
    input clk,                              // Clock input
    input [31:0] curr_inst,                 // Current instruction input
    
    // Ports for instruction_decode module
    output [4:0] rs1,                       // Source address 1
    output [4:0] rs2,                       // Source address 2
    output [4:0] rd,                        // Destination address
    output [31:0] immediate_value,          // Immediate value
    output [6:0] funct7,                    // Function 7
    output [2:0] funct3,                    // Function 3
    output [3:0] alu_ctrl_code,
    
    // Ports for forwiding_unit module
    input ID_EX_RegWrite,
    input EX_MEM_RegWrite,
    input [4:0] ID_EX_rd,
    input [4:0] EX_MEM_rd,
    output [1:0] rs1_fwd,
    output [1:0] rs2_fwd,
    
    // Ports for register_file module
    input [31:0] reg_wdata,                 // Data to be written into the register file
    input reg_we,                           // Write enable signal for the register file
    input [4:0] reg_waddr,                  // Write address for the register file
    output [31:0] reg_out1,             // Data output 1 from the register file
    output [31:0] reg_out2,             // Data output 2 from the register file
    output [31:0] [31:0] registers,
    
    // Ports for main_control module
    output [1:0] aluop,                     // ALU operation code
    output alu_src,                         // ALU source selection
    output mem_re,                          // Memory read enable
    output mem_we,                          // Memory write enable
    output mem_to_reg,                      // Memory to register
    output reg_we_control_o,                   // Register write enable control
    output is_branch,
    output is_jump
    
    // Ports for branch_decider module
    //output branch                             // Branch signal
);
    RISCV::op_type optype;
    assign alu_ctrl_code = {funct7[5], funct3};
    
    // Extract components of the instruction
    instruction_decode id_inst
    (
       .inst(curr_inst),
       
       .src_addr1(rs1),
       .src_addr2(rs2),
       .dest_addr(rd),
       .immediate(immediate_value),
       .funct7(funct7),
       .funct3(funct3),
       .opcode(optype)
    ); 
       
    register_file #(.N(32), .n(32)) regfile_inst
    (
        .clk(clk),
        .data_in(reg_wdata),
        .write_enable(reg_we),
        .write_addr(reg_waddr),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .data_out1(reg_out1), 
        .data_out2(reg_out2),
        .registers(registers)
    );
    
    main_control control_inst
    (
        .valid_op(curr_inst[1] & curr_inst[0]),
        .optype(optype),
        .aluop(aluop),
        .alu_src(alu_src),
        .memread(mem_re),
        .memwrite(mem_we),
        .mem_to_reg(mem_to_reg),
        .regwrite(reg_we_control_o),
        .is_branch(is_branch),
        .is_jump(is_jump)
    );
    
    forwarding_unit #(32, 5) forward_inst (
        .EX_MEM_RegWrite(ID_EX_RegWrite), 
        .MEM_WB_RegWrite(EX_MEM_RegWrite),
        .EX_MEM_rd(ID_EX_rd), 
        .MEM_WB_rd(EX_MEM_rd),
        .ID_EX_rs1(rs1), 
        .ID_EX_rs2(rs2),        
        .rs1_fwd(rs1_fwd), 
        .rs2_fwd(rs2_fwd)
    );

endmodule
