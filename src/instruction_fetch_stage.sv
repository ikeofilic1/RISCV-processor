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


module instruction_fetch_stage #(parameter n = 32, m = 32) (
    input clk, rst, pc_we,
    input branch_sig,
    input [n-1:0] pc_for_branch, 
    input [n-1:0] immediate_value,
    output [n-1:0] curr_pc, pc_next,
    output [m-1:0] curr_inst
);
    wire rom_ce;
    wire [n-1:0] pc_in, pc, seq_pc, branch_pc;
    
    assign branch_pc = pc_for_branch + immediate_value;
    assign seq_pc = pc + 32'd4;
    assign pc_in = branch_sig ? branch_pc : seq_pc;
    
    // outputs
    assign pc_next = pc_in;
    assign curr_pc = pc;

    pc_reg #(32) pc_inst
    (
        .clk(clk),
        .we(pc_we),
        .rst(rst),
        .pc_in(pc_in),
        .pc_out(pc),
        .ce(rom_ce)
    );

    rom #(.INIT_FILE("rom.mem")) 
    instruction_rom0 (
      .ce(rom_ce),
      .addr(pc),
      .inst(curr_inst)
    );

endmodule
