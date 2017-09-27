`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2017 13:00:07
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(
    input clk,
    input reset,
    input [1:0] pcControl,
    input [25:0] jumpAddress,
    input [15:0] branchOffset,
    input [31:0] regAddress,
    output reg [31:0] pc 
    );
    wire [31:0] pcPlus4;
    assign pcPlus4 = pc +4;
    always @(posedge clk or posedge  reset)
    begin
        if(reset)
        begin
            pc <= 32'd0;//Program counter is reset to O.
        end
        else
        begin
            case(pcControl)
                2'b00: pc <= pcPlus4;//Increment of program counter by 4
                2'b01: pc <= {pcPlus4[31:28],jumpAddress,2'b00};//Jump address calculation.
                2'b10: pc <= regAddress;//Initial address
                2'b11: pc <= pcPlus4 + {{14{branchOffset[15]}},branchOffset[15:0],2'b00};//Branch address calculation.
                default: pc<= pcPlus4;
            endcase
        end
    end
endmodule
