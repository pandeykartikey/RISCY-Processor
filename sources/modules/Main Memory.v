`timescale 1ns / 1ps

module MainMemoryModule(
    input wire clk,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] dataIn,
    output wire [31:0] dataOut
    );
reg [7:0] memory[(2**32) - 1:0];

always @(posedge clk) begin
    if(writeEnable & !readEnable) begin
        memory[address] <= dataIn[31:24];
        memory[address + 1'b1] <= dataIn[23:16];
        memory[address + 2'b10] <= dataIn[15:8];
        memory[address + 2'b11] <= dataIn[7:0];
    end 
end

assign dataOut[31:24] = memory[address];
assign dataOut[23:16] = memory[address + 1'b1]
assign dataOut[15:8] = memory[address + 2'b10]
assign dataOut[7:0] = memory[address + 2'b11]

endmodule
