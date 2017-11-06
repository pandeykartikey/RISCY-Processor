`timescale 1ns / 1ps

module alucontrol_unit(
    input      [31:0] instruction,
    input      [1:0]  ALUOp,

    output reg [5:0]  ALUFn
);


always @(instruction)
    begin
              ALUFn = instruction[5:0];
        if (ALUOp == 2'b10)
            begin
             ALUFn = instruction[5:0];
            end
    end

endmodule