`timescale 1ns / 1ps

module MainMemoryModule(
    input wire clk,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] dataIn,
    output reg [31:0] dataOut
    );
reg [31:0] memory[1024*1024*1024*4-1:0];

always @(*) 
    begin
    
    if(writeEnable & !readEnable) begin
        memory[address] = dataIn;
    end
    dataOut = memory[address]; 
end


endmodule
