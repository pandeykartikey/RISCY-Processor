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
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] dataIn,
    output wire [31:0] dataOut
    );
reg [31:0] memory[8*1024:0];

always @(posedge clk) begin
    if(writeEnable & !readEnable) begin
        memory[address] = dataIn;
    end 
end

assign dataOut = memory[address]; 

endmodule
