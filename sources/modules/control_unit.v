`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2017 00:29:24
// Design Name: 
// Module Name: control_unit
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


module control_unit(input [31:26] instruction, //opcode
output reg reg_mem_write_enable,
output reg reg_mem_regmux_control,
output reg reg_mem_writemux_control,
output reg alu_mux_control,
output reg data_mem_write,
output reg data_mem_read_enable,
output reg branch_enable,
output reg jump_enable
    );
    always @(instruction)
    begin
    
    case(instruction)
    6'b001100:reg_mem_writemux_contol=1; //load write to register enabled
    6'b001100:reg_mem_regmux_control=0; //load write to register [20:16] enabled
    6'b001100:data_mem_read_enable=1; //read value of calculated address from data mem
    6'b00110x:alu_mux_control=1; //load&store mux sign-extended data to input 2 of alu
    6'b001101:data_mem_write=1;//store value of register[20:16] to data mem
    6'b001110:branch_enable=1; //branch condition
    6'b010000:jump_enable=1;
    default:
    begin
    reg_mem_writemux_control=0; //R type write to register enabled
        reg_mem_regmux_control=1; //R type , write to register [15:11] enabled
        alu_mux_control=1; //R type 2nd input to alu is resistor2
        data_mem_write=0; //not store then no writing to data mem
        data_mem_read_enable=0;// not load then no reading data of datamem
        branch_enable=0;
        jump_enable=0;
    end
    
    endcase
    
      end
endmodule
