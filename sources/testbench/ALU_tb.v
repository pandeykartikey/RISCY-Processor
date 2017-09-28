`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2017 23:21:05
// Design Name: 
// Module Name: ALU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg [5:0] alufn;
    wire [31:0] otp;
    wire overflow;
    wire zero;
    
    
    ALU alu_inst_1(.a(a),.b(b),.alufn(alufn),.otp(otp),.overflow(overflow),.zero(zero));
    
    initial 
        begin
            //add
            #100 
            alufn = 6'b000000;     
            a = 32'h00000001; 
            b = 32'h00000001; 
            //subtract
            #100 
            alufn = 6'b000001;     
            a = 32'h00000013; 
            b = 32'h00000002;
            //multiply
            #100 
            alufn = 6'b000010;     
            a = 32'h00000013; 
            b = 32'h00000002;  
            #100 //and
            alufn = 6'b000100;     
            a = 1; 
            b = 0;
            #100 //or
            alufn = 6'b000101;     
            a = 32'h00000001; 
            b = 32'h00000000;    
            #100 //xor
            alufn = 6'b000110;     
            a = 32'h00000001; 
            b = 32'h00000000;  
            #100 //shiftleft
            alufn = 6'b001000;     
            a = 32'h00000001; 
            b = 32'h00000003; 
            #100 //shiftright
            alufn = 6'b001001;     
            a = 32'h00000010; 
            b = 32'h00000003;         
        end
    
endmodule
