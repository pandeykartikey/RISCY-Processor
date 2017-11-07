`timescale 1ns / 1ps

parameter N = 1;
module regr(
    input clk,
	input clear,
	input hold,
	input wire [N-1:0] in,
	output reg [N-1:0] out);



	always @(posedge clk) begin
		if (clear)
			out <= {N{1'b0}};
		else if (hold)
			out <= out;
		else
			out <= in;
	end
endmodule
