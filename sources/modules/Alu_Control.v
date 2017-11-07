`timescale 1ns / 1ps

module alu_control(
    input      [31:0] instruction,
    input      [2:0]  ALUOp,

    output reg [5:0]  ALUFn
);

always @(instruction or ALUOp)
begin
    if (ALUOp == 3'b010) begin
        ALUFn <= instruction[5:0];
    end else if (ALUOp == 3'b000) begin
        ALUFn <= 6'b000000;        
    end else if (ALUOp == 3'b001) begin
        ALUFn <= 6'b000001;
    end else if (ALUOp == 3'b011)begin
        ALUFn <= 6'b000000;
    end else if (ALUOp == 3'b100)begin
        ALUFn <= 6'b000100;
    end else if (ALUOp == 3'b101)begin
        ALUFn <= 6'b000110;
    end else if (ALUOp == 3'b110)begin
        ALUFn <= 6'b001011;
    end 
end

endmodule
