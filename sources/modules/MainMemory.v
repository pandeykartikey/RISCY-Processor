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

always @(address) 
    begin
    memory[0] <= 32'b00000000001000100001100000000000;//ADD R1 and R2 Store in R3
    //memory[0] <= 32'b01011000100000100000000000000001; //sw value of R2 in memory address in R4 
    //  memory[8] <= 32'b00000000001000100001100000000000;
    dataOut = memory[address];
    // $display("address main memory - %b",address);
end

always @(dataIn) 
    begin
    if(writeEnable & !readEnable) begin
        memory[address] = dataIn;
    end 
end

endmodule
