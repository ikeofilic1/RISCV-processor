`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 01:47:59 PM
// Design Name: 
// Module Name: inst_single_cycle
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


module inst_five_stage_pipelined(
    input wire clk, rst, // posedge clock, active high reset
    input seg_clk, // clock for seven segment displays
    output wire [31:0] pc_out,
    output wire [31:0] curr_inst,
    output [7:0] seg,
    output [3:0] an,
    output [3:0] [7:0] segments,
    output wire [31:0] [31:0] registers
);
        
    wire [31:0] pc;
    wire branch;
    wire alu_src, reg_we, mem_we, mem_re, mem_to_reg, regwrite; 
    wire alu_zero; // Is the result from the ALU zero?
    wire [1:0] aluop;
    wire [4:0] rs1, rs2;
    wire [4:0] rd;
    wire [3:0] alu_ctrl_code;
    wire [31:0] immediate_value;
    wire [31:0] alu_result;
    wire [31:0] reg_out1, reg_out2, reg_out2_fwd_o;
    wire [31:0] reg_wdata;
    wire [31:0] mem_out;
    wire [1:0] rs1_fwd;
    wire [1:0] rs2_fwd;
    wire is_branch;
    wire is_jump;
    
    // PIPELINE OUTPUTS
    wire mem_to_reg_mem_o;
    wire [31:0] mem_out_mem_o;
    wire [31:0] alu_result_mem_o;
    wire [31:0] pc_if_o;
    wire [31:0] pc_id_o;
    wire [31:0] inst_if_o;
    wire reg_we_mem_o;
    wire reg_we_id_o;
    wire mem_to_reg_id_o;
    wire mem_we_id_o;
    wire mem_re_id_o;
    wire [31:0] reg_out1_id_o;
    wire [31:0] reg_out2_id_o;
    wire [4:0] rd_id_o;
    wire [31:0] reg_out2_ex_o;
    wire mem_we_ex_o;
    wire mem_re_ex_o;
    wire [4:0] rd_ex_o;
    wire reg_we_ex_o;
    wire mem_to_reg_ex_o;
    wire [3:0] alu_ctrl_code_id_o;
    wire [31:0] immediate_value_id_o;
    wire [31:0] alu_result_ex_o;
    wire alu_src_id_o;
    wire [4:0] rd_mem_o;
    wire [1:0] aluop_id_o;
    wire [1:0] rs1_fwd_id_o;
    wire [1:0] rs2_fwd_id_o;
    wire is_branch_id_o;
    wire is_jump_id_o;
    
    // Stall signals (active low)
    wire load_stall;
    wire hazard_stall;    
    
    hazard_detection_unit hazard_detect(
        .ID_EX_rd(rd_id_o),
        .ID_rs1(rs1),
        .ID_rs2(rs2),
        .ID_EX_MemRead(mem_to_reg_id_o),
        .stalln(hazard_stall)
    );
    
    //==============INSTRUCTION FETCH=================
    
    instruction_fetch_stage IF_stage (
        .clk(clk),          // Clock input
        .rst(rst),          // Reset input
        .pc_we(load_stall & hazard_stall), // PC write enable
        .branch_sig(branch),    // Branch signal input
        .pc_for_branch(pc_id_o), // Program counter from instruction decode stage
        .immediate_value(immediate_value_id_o),
        .curr_pc(pc),            // Program counter output
        .pc_next(pc_out),  // Next program counter output
        .curr_inst(curr_inst) // Current instruction output
    );
    
    IF_ID if_id_reg
    (
        .clk(clk),
        .clear(rst | branch),//(if_id_clear),
        .we(load_stall & hazard_stall),//(if_id_we),
        .pc_i(pc),
        .inst_i(curr_inst),
        
        .pc_o(pc_if_o),
        .inst_o(inst_if_o)
    );
    //===============INSTRUCTION DECODE===================    
    
    instruction_decode_stage ID_stage (
        .clk(clk),                      // Clock input
        
        // Current instruction input
        .curr_inst(inst_if_o),        
        .rs1(rs1),                      // Source address 1
        .rs2(rs2),                      // Source address 2
        .rd(rd),                        // Destination address
        .immediate_value(immediate_value), // Immediate value
        .alu_ctrl_code(alu_ctrl_code),
        
        // register_file ports
        .reg_wdata(reg_wdata),          // Data to be written into the register file
        .reg_we(reg_we_mem_o),          // Write enable signal for the register file
        .reg_waddr(rd_mem_o),          // Write address for the register file
        .reg_out1(reg_out1),            // Data output 1 from the register file
        .reg_out2(reg_out2),            // Data output 2 from the register file
        .registers(registers),
        
        // forwarding_unit ports
        .ID_EX_RegWrite(reg_we_id_o),
        .EX_MEM_RegWrite(reg_we_ex_o),
        .ID_EX_rd(rd_id_o),
        .EX_MEM_rd(rd_ex_o),
        .rs1_fwd(rs1_fwd),
        .rs2_fwd(rs2_fwd),
            
        // main_control ports
        .aluop(aluop),                  // ALU operation code
        .alu_src(alu_src),              // ALU source selection
        .mem_re(mem_re),                // Memory read enable
        .mem_we(mem_we),                // Memory write enable
        .mem_to_reg(mem_to_reg),        // Memory to register
        .reg_we_control_o(reg_we),      // Register write enable control
        
        .is_branch(is_branch),
        .is_jump(is_jump)
        
        // branch_decider ports
        //.branch(branch)                 // Branch signal
    );
    
    ID_EX id_ex_reg
    (
        .clk(clk),
        .clear(~hazard_stall | branch),//(id_ex_clear),
        .we(load_stall),//(id_ex_we),
        
        .pc_i(pc_if_o),
        .rd_i(rd),
        .alu_ctrl_code_i(alu_ctrl_code),
        .reg_out1_i(reg_out1),
        .reg_out2_i(reg_out2),
        .immediate_i(immediate_value),
        .rs1_fwd_i(rs1_fwd),
        .rs2_fwd_i(rs2_fwd),
        .control_i({reg_we, mem_to_reg, mem_we, mem_re, alu_src, aluop, is_branch, is_jump}),
        
        .pc_o(pc_id_o),
        .rd_o(rd_id_o),
        .alu_ctrl_code_o(alu_ctrl_code_id_o),
        .reg_out1_o(reg_out1_id_o),
        .reg_out2_o(reg_out2_id_o),
        .immediate_o(immediate_value_id_o),
        .rs1_fwd_o(rs1_fwd_id_o),
        .rs2_fwd_o(rs2_fwd_id_o),
        .control_o({reg_we_id_o, mem_to_reg_id_o, mem_we_id_o, mem_re_id_o, alu_src_id_o, aluop_id_o, is_branch_id_o, is_jump_id_o})
    );
    
    //===============EXECUTION=====================
    
    execution_stage EX_stage (
        // Global Inputs
        //.clk(clk),                          // Clock input
        
        // Inputs from instruction_decode_stage
        .reg_out1(reg_out1_id_o),        // Data output 1 from register file in ID stage
        .reg_out2(reg_out2_id_o),        // Data output 2 from register file in ID stage
        .immediate_value(immediate_value_id_o), // Immediate value from ID stage
        
        // Forwarding unit
        .EX_MEM_result(alu_result_ex_o),
        .MEM_WB_result(reg_wdata),
        .op1_fwd_src(rs1_fwd_id_o),
        .op2_fwd_src(rs2_fwd_id_o),
        .reg_out2_fwd_o(reg_out2_fwd_o),
        
        // ALU inputs
        .alu_src(alu_src_id_o),                // ALU source selection from ID stage
        .aluop(aluop_id_o),            // ALU operation code from ID stage
        .alu_ctrl_code(alu_ctrl_code_id_o),    // ALU control code from ID stage
        
        // Branchhh
        .is_jump(is_jump_id_o),
        .is_branch(is_branch_id_o),
        .branch_taken(branch),
        
        // ALU outputs
        .alu_result(alu_result),
        .alu_zero(alu_zero)
    );
   
    EX_MEM ex_mem_reg
    (
        .clk(clk),
        .we(load_stall),//(ex_mem_we),
        .clear(1'b0),//(ex_mem_clear),
        
        .reg_out2_i(reg_out2_fwd_o),
        .alu_res_i(alu_result),
        .rd_i(rd_id_o),
        .control_i({reg_we_id_o, mem_to_reg_id_o, mem_we_id_o, mem_re_id_o}),
        
        .reg_out2_o(reg_out2_ex_o),
        .alu_res_o(alu_result_ex_o),
        .rd_o(rd_ex_o),
        .control_o({reg_we_ex_o, mem_to_reg_ex_o, mem_we_ex_o, mem_re_ex_o})
    );
    
    //============MEMORY============================
    // IO instantiations
    //wire [3:0] [7:0] segments;
        
    seg_controller seven_seg
    (
        .clk(seg_clk),
        .segs(segments),
        .seg(seg),
        .an(an)
    );
   
    memory_rw_stage MEM_stage
    (
        .clk(clk),
        .rst(rst),
        .bank_en({4{mem_we_ex_o}}),
        .re(mem_to_reg_id_o),
        .stalln(load_stall),
        .w_data(reg_out2_ex_o),
        .r_data(mem_out),
        .addr(alu_result_ex_o),
        .segs(segments)
    );
    
    MEM_WB mem_wb_reg
    (
        .clk(clk),
        .we(load_stall),//(mem_wb_we),
        .clear(1'b0),//(mem_wb_clear),
        
        .mem_data_i(mem_out),
        .alu_result_i(alu_result_ex_o),
        .rd_i(rd_ex_o),
        .control_i({reg_we_ex_o, mem_to_reg_ex_o}),
        
        .mem_data_o(mem_out_mem_o),
        .alu_result_o(alu_result_mem_o),
        .rd_o(rd_mem_o),
        .control_o({reg_we_mem_o, mem_to_reg_mem_o})
    );
    
    //===================WRITE BACK====================
    assign reg_wdata = mem_to_reg_mem_o ? mem_out_mem_o : alu_result_mem_o;   
endmodule
