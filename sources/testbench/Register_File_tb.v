`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2017 02:17:25
// Design Name: 
// Module Name: Register_File_tb
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


module Register_File_tb;

reg clk;

reg [4:0]  read_addr1;
reg [4:0]  read_addr2;
reg [4:0]  write_addr;

reg [31:0] write_data;
reg        write_enable;

wire [31:0] read_data1;
wire [31:0] read_data2;

Register_File regfile(
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .read_data1(read_data1),
        .read_data2(read_data1),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable)
    );
integer i = 0;
initial
    begin
        clk = 0; 
        read_addr1 = 5'h00000;
        read_addr2 = 5'h00000;
        write_enable = 1;
        for(i=0;i<32;i=i+1)begin
            write_addr = $realtobits(i);
            write_data = 5'h00001;
            #5 clk = ~clk;
            #5 clk = ~clk;    
        end
    end
always begin
#10
    read_addr1 = 5'h00002;
    read_addr2 = 5'h00300;
    write_enable = 0;
    #5 clk = ~clk;
    #5 clk = ~clk;
#10 
    read_addr1 = 5'h00000;
    read_addr2 = 5'h00000;
    write_enable = 1;
    write_addr = 5'h00010;
    write_data = 5'h00100;
    #5 clk = ~clk;
    #5 clk = ~clk;    
#10
    read_addr1 = 5'h00010;
    read_addr2 = 5'h00300;
    write_enable = 0;
    #5 clk = ~clk;
    #5 clk = ~clk;
end
endmodule
