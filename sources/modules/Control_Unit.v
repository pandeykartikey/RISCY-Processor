`timescale 1ns / 1ps

module control_unit(
    input [31:0] instruction,
    output reg       RegDst,    // Destination for I and R type instruction
    output reg       ALUSrc,    // Decides between Register input to ALU and I Type add immediate
    output reg       MemToReg,  // Decides between SW and ALU output
    output reg       RegWrite,  // Write enable for Register File
    output reg       MemRead,   // Read from data memory
    output reg       MemWrite,  // Write to data memory
    output reg       Branch,    // 1 if instruction is beq and thus decides Program Counter
    output reg [2:0] ALUOp,     // ALU Opcode
    output reg       Jump       // 1 if insturction is J type
);

wire [5:0] opcode;
assign opcode = instruction [31:26];
reg [10:0]  controlSignals[63:0];

initial
begin
    controlSignals[6'b000000] = 11'b10010000100; // rtype
    controlSignals[6'b010000] = 11'b01010000110; // addi
    controlSignals[6'b010001] = 11'b01010001000; // andi 
    controlSignals[6'b010010] = 11'b01010001010; // xori
    controlSignals[6'b010011] = 11'b00000010010; // beq
    //controlSignals[6'b010100] = 11'b; //bne
    controlSignals[6'b010101] = 11'b01111000000; // lw
    controlSignals[6'b010110] = 11'b01001000000; // sw
    controlSignals[6'b010111] = 11'b10010000100; // slt
    controlSignals[6'b011000] = 11'b01010001100; // slti
    controlSignals[6'b011001] = 11'b00000011111; // slti
    


end

always @(instruction)
    begin
        RegDst   = controlSignals[opcode][10];
        ALUSrc   = controlSignals[opcode][9];
        MemToReg = controlSignals[opcode][8];
        RegWrite = controlSignals[opcode][7];
        MemWrite = controlSignals[opcode][6];
        MemRead  = controlSignals[opcode][5];
        Branch   = controlSignals[opcode][4];
        ALUOp    = controlSignals[opcode][3:1];
        Jump     = controlSignals[opcode][0];
    end
endmodule
