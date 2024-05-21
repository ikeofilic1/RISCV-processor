`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2024 07:25:23 PM
// Design Name: 
// Module Name: rom
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

// TODO: use addr_hi  and addr_lo instead of width and 
module rom #(
    parameter INIT_FILE = "rom.mem",
    parameter ADDR_WIDTH = 32,
    parameter ROM_DEPTH = 256, ROM_WIDTH = 32,
    
    localparam shift = $clog2(ROM_WIDTH / 8)
)
(
    input wire ce,
    input wire [ADDR_WIDTH-1:0] addr,
    output wire [ROM_WIDTH-1:0] inst
);    
    (* rom_style = "block" *) reg[ROM_WIDTH-1:0] rom[ROM_DEPTH-1:0];    
    initial $readmemh (INIT_FILE, rom);    
    assign inst = ce ? rom[addr[ADDR_WIDTH-1 : shift]] : '0;
endmodule