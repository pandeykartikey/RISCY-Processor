`timescale 1ns / 1ps

module InstructionMemoryModule(
    input wire clk,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] dataIn,
    output reg [31:0] dataOut
    );
reg [31:0] memory[8191:0];

initial 
begin
    //memory[0] <= 32'b11000000000000000000000000000010;//jump
    memory[0] <= 32'b01001100001000010000000000000001;// branch
    memory[1] <= 32'b01011000100000100000000000000001; //sw value of R2 in memory address in R4 
    memory[2] <= 32'b00000000001000100001100000000010;
end
always @(address) 
    begin
    #1
    dataOut = memory[address]; 
    $display("dataout - %b address- %d",dataOut,address); 
end


endmodule
