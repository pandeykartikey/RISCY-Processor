`timescale 1ns / 1ps

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
