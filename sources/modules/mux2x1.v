`timescale 1ns / 1ps

module mux2x1(in0, in1, select, out);
    input wire select;
    input wire [31:0] in0;
    input wire [31:0] in1;
    output wire[31:0] out;

    assign out = (select == 0) ? in0 : in1;

endmodule
