`timescale 1ns / 1ps

module InstructionMemoryModule(
    input wire clk,
    input wire [31:0] instructionAddress,
    output wire [31:0] instruction
    );
MainMemoryModule instructionMemory(
    .clk(clk),
    .address(InstructionAddress),
    .readEnable(1),
    .writeEnable(0),
    .dataIn(32'h00000000),
    .dataOut(instruction));

endmodule
