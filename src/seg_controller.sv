`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2024 03:58:28 PM
// Design Name: 
// Module Name: top_level
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

module seg_controller(
    input clk,
    input [3:0] [7:0] segs,
    output [7:0] seg,
    output [3:0] an
);

reg [23:0] counter = 24'd0;
reg divclk = 1'b0;
reg [1:0] round_counter = 2'd0;
reg [7:0] seg_reg;
reg [3:0] an_reg;

/* Clock Divider: 100MHz -> 1000Hz (1ms) */
    always @(posedge clk)
    begin
        if (counter == 24'd49999) begin
            divclk <= ~divclk;
            counter <= 24'd0;
        end
        else begin
            divclk <= divclk;
            counter <= counter + 1'd1;
        end 
    end
    
    always @(posedge divclk)
    begin
        round_counter <= round_counter + 1'd1;
    end
    
    // Date of birth is 11/05
    always @(posedge divclk)
    begin
        if (round_counter == 2'd0) begin
            seg_reg <= segs[0];
            an_reg <= 4'b1110;
        end
        else if (round_counter == 2'd1) begin
            seg_reg <= segs[1];
            an_reg <= 4'b1101;
        end
        else if (round_counter == 2'd2) begin
            seg_reg <= segs[2];
            an_reg <= 4'b1011;
        end
        else begin
            seg_reg <= segs[3];
            an_reg <= 4'b0111;
        end
    end
    
    assign seg = seg_reg;
    assign an = an_reg;
endmodule
