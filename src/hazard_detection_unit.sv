`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2024 01:31:50 AM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit(
    input [4:0] ID_EX_rd, ID_rs1, ID_rs2,
    input ID_EX_MemRead,
    output reg stalln
);

    always @(*) begin
        if (ID_EX_MemRead && (ID_EX_rd == ID_rs1 || ID_EX_rd == ID_rs2))
            stalln = 1'b0; //stall the pipeline
        else stalln = 1'b1;
    end
endmodule