`timescale 1ns / 1ps

module control_unit(
    input      [31:0] instruction,
    input      [1:0]  ALUOp,

    output reg [5:0]  ALUFn
);

assign fnField = instruction[5:0];

always @(instruction)
    begin
        if (ALUOp == 2'b10)
            begin
                ALUFn = fnField;
            end
    end

endmodule
