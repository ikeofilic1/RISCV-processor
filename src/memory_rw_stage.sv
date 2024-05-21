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
module memory_rw_stage (
    input clk,                  // Clock input
    input rst,
    input [3:0] bank_en,     // Bank enable, uncomment if needed
    input re,                   // Read enable
    input [31:0] addr,          // Address
    input [31:0] w_data,        // Data to write
    output reg stalln,             // stall for memory read
    output [31:0] r_data,   // Data read
    
    // TODO: figure out a more elegant way to include all the IO to map
    output [3:0] [7:0] segs
);
    parameter IO_SIZE = 16;
    reg [31:0] IO_map [IO_SIZE-1:0];
    // The actual IO map
    assign segs[0] = IO_map[0][7:0];
    assign segs[1] = IO_map[0][15:8];
    assign segs[2] = IO_map[0][23:16];
    assign segs[3] = IO_map[0][31:24];
    
    wire ram_re;
    wire [3:0] ram_we;    
    wire [$clog2(IO_SIZE)-1:0] io_addr;
    wire [31:0] ram_r_data;    
    
    always @(posedge clk)
        if (addr[10] & bank_en[0])
            IO_map[io_addr] = w_data; 

  // Instantiate RAM module
    blk_mem_gen_0 ram_4k (
      .clka(clk),    // input wire clka
      .wea(ram_we),      // input wire [3 : 0] wea
      .addra(addr),  // input wire [31 : 0] addra
      .dina(w_data),    // input wire [31 : 0] dina
      .douta(ram_r_data)  // output wire [31 : 0] douta
    );
    
    // Read latency (1 cycle)
    always @ (posedge clk) begin
        if (rst) stalln <= 1'b1;
        else if (~stalln)
            stalln <= 1'b1;
        else
            stalln <= ~ram_re;
    end
    
    assign ram_re = re & ~addr[10];
    assign ram_we = bank_en & {4{~addr[10]}};
    assign r_data = addr[10] ? IO_map[io_addr] : ram_r_data;
    assign io_addr = addr[$clog2(IO_SIZE)-1:0];
endmodule
