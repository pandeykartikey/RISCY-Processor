`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2017 22:10:57
// Design Name: 
// Module Name: MainMemoryModule
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


module MainMemoryModule(
    input wire clk,
    input wire [31:0] Address,
    input wire ReadEnable,
    input wire WriteEnable,
    input wire [31:0] DataIn,
    output wire [31:0] DataOut
    );
reg [31:0] memory[8*1024:0];

always @(posedge clk) begin
    if(WriteEnable & !ReadEnable) begin
        memory[Address] = DataIn;
    end 
end

assign DataOut = memory[Address]; 

endmodule
