`timescale 1ns / 1ps

module Register_File(
        clk,
        read_addr1,
        read_addr2,
        read_data1,
        read_data2,
        write_addr,
        write_data,
        write_enable
    );

/***************************
******** PARAMETERS ********
***************************/

input wire clk;

input wire [4:0]  read_addr1;
input wire [4:0]  read_addr2;
input wire [4:0]  write_addr;

input wire [31:0] write_data;
input wire        write_enable;

output wire [31:0] read_data1;
output wire [31:0] read_data2;


// REGISTER FILE

reg [31:0] Register_File [31:0]; // 32 - 32 Bit Registers


/*************************
********* LOGIC **********
**************************/

assign read_data1 = (read_addr1 != 5'b11111) ? Register_File[read_addr1] : 32'h00000000;
assign read_data2 = (read_addr2 != 5'b11111) ? Register_File[read_addr2] : 32'h00000000;

always @(posedge clk)
    begin
   Register_File[1]=32'h00000003;
   Register_File[2]=32'h00000002;
   Register_File[4]=32'h00000001;
        if (write_enable) begin
            if (write_addr != 5'b11111) begin
                Register_File[write_addr] = write_data;   
            end
        end
    end

endmodule
