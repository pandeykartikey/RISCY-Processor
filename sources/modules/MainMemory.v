`timescale 1ns / 1ps

module MainMemoryModule(
    input wire clk,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] dataIn,
    output wire [31:0] dataOut
    );
reg [31:0] memory[1024*1024*1024*4-1:0];

always @(posedge clk) 
    begin
    memory[0] <= 32'b00000000001000100001100000000000;//ADD R1 and R2 Store in R3
    memory[4] <= 32'b00000000001000100001100000000000;
    memory[8] <= 32'b00000000001000100001100000000000;

    if(writeEnable & !readEnable) begin
        memory[address] = dataIn;
    end 
end

assign dataOut = memory[address]; 

endmodule