`timescale 1ns / 1ps

module ALU(a,b,alufn,otp,zero,overflow);
    input wire [31:0] a;
    input wire [31:0] b;
    input wire [5:0] alufn; // choosing 6 bit op code
    output reg [31:0] otp;
    output wire zero;
    output wire overflow;
    always @(alufn,a,b)
    begin
        if(alufn == 6'b000000)
            begin //ADD
                otp = a + b;
            end
    end
endmodule