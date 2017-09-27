`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2017 13:35:24
// Design Name: 
// Module Name: signExtension
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


module signExtension(
    input [15:0] in,
    output [31:0] out
    );
    assign out = {{16{in[15]}},in[15:0]};
endmodule
