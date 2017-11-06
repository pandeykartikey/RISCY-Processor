`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2017 11:32:04
// Design Name: 
// Module Name: regmux2x1
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


module regmux2x1(in0,in1,select,out);
input wire select; 
input wire [4:0] in0;
input wire [4:0] in1;
output wire[4:0] out;
assign out = (select==0)?in0:in1;

endmodule