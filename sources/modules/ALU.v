`timescale 1ns / 1ps

module ALU(a,b,alufn,otp,zero,overflow);
    input wire [31:0] a;
    input wire [31:0] b;
    input wire [5:0] alufn; // choosing 6 bit op code
    output reg [31:0] otp;
    output wire zero; // set if the output of the alu is 0
    output wire overflow;
    wire [31:0] tempAuRes;
    wire [31:0] tempLuRes;
    wire [31:0] tempSuRes;
    
    
    ArithmeticUnit arith_inst_0(.a(a),.b(b),.alufn(alufn[1:0]),.otp(tempAuRes),.zero(zero),.overflow(overflow));
    LogicalUnit logic_inst_0(.a(a),.b(b),.alufn(alufn[1:0]),.otp(tempLuRes),.zero(zero),.overflow(overflow));
    ShiftUnit shift_inst_0(.a(a),.b(b),.alufn(alufn[1:0]),.otp(tempSuRes),.zero(zero),.overflow(overflow));
    
    always @(alufn,a,b)
    begin
        casex(alufn)
            6'b0000xx: otp = tempAuRes;
            6'b0001xx: otp = tempLuRes;
            6'b0010xx: otp = tempSuRes;
            default:
            begin 
                otp = {32{1'b0}};
            end
        endcase
    end
endmodule

module ArithmeticUnit(a,b,alufn,otp,zero,overflow);
    input wire [31:0] a;
    input wire [31:0] b;
    input wire [1:0] alufn; // choosing 6 bit op code
    output reg [31:0] otp;
    output reg zero; // set if the output of the alu is 0
    output reg overflow;
    
    always @(alufn,a,b)
    begin
        if(alufn == 2'b00)
            begin //ADD
                otp = a + b;
                zero = (otp==0)?0:1;
                if ((a >= 0 && b >= 0 && otp < 0) || (a < 0 && b < 0 && otp >= 0))
                    overflow = 1;
                else
                    overflow = 0;
            end
        else if(alufn == 2'b01) //SUB
            begin
                otp = a-b;
                zero = (otp==0)?0:1;
                if ((a >= 0 && b < 0 && otp < 0) || (a < 0 && b >= 0 && otp > 0))
                    overflow = 1;
                else
                    overflow = 0;
            end
        else if (alufn == 2'b10) //MUL
            begin
                otp = a*b;
                zero = (otp==0)?0:1;
                overflow = 0;
            end
    end
endmodule

module LogicalUnit(a,b,otp,alufn,zero,overflow);
    input wire [31:0] a;
    input wire [31:0] b;
    input wire [2:0] alufn;
    output reg [31:0] zero;
    output reg [31:0] overflow;
    output reg [31:0] otp;
    
    always @(a,b,alufn)
    begin
        case (alufn)
        2'b00: //AND
            begin
                otp = a & b;
                overflow = 0;
                zero = (otp==0)?1:0;
            end
        2'b01: //OR
            begin
                otp = a | b;
                overflow = 0;
                zero = (otp==0)?1:0;
            end
        2'b10:  //XOR
                begin
                    otp = a ^ b;
                    overflow = 0;
                    zero = (otp==0)?1:0;
                end
        endcase
    end
endmodule

module ShiftUnit(a,b,otp,alufn,zero,overflow);
    input wire [31:0] a;
    input wire [31:0] b;
    input wire [2:0] alufn;
    output reg [31:0] zero;
    output reg [31:0] overflow;
    output reg [31:0] otp;
    
    always @(a,b,alufn)
    begin
        case(alufn)
        2'b00: //SHIFTLEFT
            begin
                otp = a<<b;
                zero = (otp == 0)?1:0;
                overflow = 0;
            end
        2'b01: //shiftright
            begin
                otp = a>>b;
                zero = (otp == 0)?1:0;
                overflow = 0;
            end
        endcase
    end
endmodule   