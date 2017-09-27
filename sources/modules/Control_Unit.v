`timescale 1ns / 1ps

module control_unit(
    input [31:0] instruction, //opcode

    output reg       RegDst,
    output reg       MemRead,
    output reg       MemToReg,
    output reg [1:0] ALUOp,
    output reg       MemWrite,
    output reg       ALUSrc,
    output reg       RegWrite,
    output reg       Branch,
    output reg       Jump
);

assign opcode = instruction[31:26];


always @(instruction)
    begin
    	RegDst   = 0;
        MemRead  = 0;
        MemToReg = 0;
        ALUOp    = b'00;
        MemWrite = 0;
        ALUSrc   = 0;
        RegWrite = 0;
        Branch   = 0;
        Jump     = 0;

        if (opcode == 6b'000000)
        begin
            // R-Format Instruction
            ALUOp = b'10;
            RegDst = 1;
            RegWrite = 1;
        end
    end
endmodule
