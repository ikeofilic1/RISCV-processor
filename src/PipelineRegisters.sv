`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2024 10:49:28 AM
// Design Name: 
// Module Name: ID_EX
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


module IF_ID # (parameter M = 32) (
    input clk, clear, we,
    input [M-1:0] pc_i, inst_i,
    output reg [M-1:0] pc_o, inst_o    
);

    always @ (posedge clk)
    begin
        if (clear) begin
            pc_o <= '0;
            inst_o <= '0;
        end
        else if (we) begin
            pc_o <= pc_i;
            inst_o <= inst_i;
        end
    end
endmodule

module ID_EX(
    input wire clk, clear, we,
    input wire [31:0] pc_i,
    input wire [4:0] rd_i,
    input wire [3:0] alu_ctrl_code_i,
    input wire [31:0] reg_out1_i,
    input wire [31:0] reg_out2_i,
    input wire [31:0] immediate_i,
    input reg [1:0] rs1_fwd_i,
    input reg [1:0] rs2_fwd_i,
    input wire [8:0] control_i,
    output reg [31:0] pc_o,
    output reg [31:0] immediate_o,
    output reg [4:0] rd_o,
    output reg [31:0] reg_out1_o,
    output reg [31:0] reg_out2_o,
    output reg [3:0] alu_ctrl_code_o,
    output reg [1:0] rs1_fwd_o,
    output reg [1:0] rs2_fwd_o,
    output reg [8:0] control_o
);

    always @(posedge clk) begin
        if (clear) begin
            pc_o <= '0;
            immediate_o <= '0;
            rd_o <= '0;
            reg_out1_o <= '0;
            reg_out2_o <= '0;
            alu_ctrl_code_o <= '0;
            rs1_fwd_o <= '0;
            rs2_fwd_o <= '0;
            control_o <= '0;
        end
        else if (we) begin
            pc_o <= pc_i;
            immediate_o <= immediate_i;
            rd_o <= rd_i;
            reg_out1_o <= reg_out1_i;
            reg_out2_o <= reg_out2_i;
            alu_ctrl_code_o <= alu_ctrl_code_i;
            rs1_fwd_o <= rs1_fwd_i;
            rs2_fwd_o <= rs2_fwd_i;
            control_o <= control_i;
        end
    end
endmodule

module EX_MEM(
    input wire clk, clear, we,
    input wire [31:0] reg_out2_i,
    input wire [31:0] alu_res_i,
    input wire [4:0] rd_i,
    input wire [3:0] control_i,
    
    output reg [31:0] reg_out2_o,
    output reg [31:0] alu_res_o,
    output reg [4:0] rd_o,
    output reg [3:0] control_o
);

    always @(posedge clk) begin
        if (clear) begin
            reg_out2_o <= '0;
            alu_res_o <= '0;
            rd_o <= '0;
            control_o <= '0;
        end
        else if (we) begin
            reg_out2_o <= reg_out2_i;
            alu_res_o <= alu_res_i;
            rd_o <= rd_i;
            control_o <= control_i;
        end
    end
endmodule


module MEM_WB(
    input wire clk, clear, we,
    input wire [31:0] mem_data_i,
    input wire [31:0] alu_result_i,
    input wire [4:0] rd_i,
    input wire [1:0] control_i,
    
    output reg [31:0] mem_data_o,
    output reg [31:0] alu_result_o,
    output reg [4:0] rd_o,
    output reg [1:0] control_o
);

    always @(posedge clk) begin
        if (clear) begin
            mem_data_o <= '0;
            alu_result_o <= '0;
            rd_o <= '0;
            control_o <= '0;
        end
        else if (we) begin
            mem_data_o <= mem_data_i;
            alu_result_o <= alu_result_i;
            rd_o <= rd_i;
            control_o <= control_i;
        end
    end
endmodule   