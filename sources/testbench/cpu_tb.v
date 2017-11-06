`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2017 12:16:35
// Design Name: 
// Module Name: cpu_tb
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

module cpu_tb;
reg clk;
reg rst;
cpu uut(.clk(clk),
.rst(rst));

always 
		#5 clk = ~clk;
	
	initial
	begin
	
		clk    = 1'b0      ; // time = 0 
		#1 rst    = 1'b1;
	end
	initial
        begin        
            repeat(2)
                @(posedge clk);
                
            rst = 1'b0;
        
            
            repeat(2)
                @(posedge clk);
                
            $stop();
        end
endmodule
