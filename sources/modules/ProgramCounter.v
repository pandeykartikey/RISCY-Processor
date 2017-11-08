`timescale 1ns / 1ps

module ProgramCounter(
    input clk,
    input reset,
    input zero,
    input branch,
    input jump,
    input [25:0] jumpAddress,
    input [15:0] branchOffset,
    input [31:0] regAddress,
    output reg [31:0] pc 
);
    wire [31:0] pcPlus4;
    reg [1:0] pcControl;
    initial
    begin
        pc <= 32'h00000000;
    end
    
    assign pcPlus4 = pc + 1;
    
    always @(posedge clk)
    begin
        if(reset == 1)
            pc <= 32'h00000000;
        else
        begin
        pcControl = ( branch & zero == 1)? 2'b10: 2'b00;
        pcControl = (jump)?2'b11:pcControl;
        
            case(pcControl)
                2'b00: pc <= pcPlus4;                                                       //Increment of program counter by 4
                2'b11: pc <= {pcPlus4[31:26],jumpAddress};                                  //Jump address calculation.
                2'b01: pc <= regAddress;                                                    //Initial address
                2'b10: pc <= pcPlus4 + {{14{branchOffset[15]}},branchOffset[15:0]};   //Branch address calculation.
                default: pc<= pcPlus4;
            endcase
        end
        // $display("pc - %d clk -%d  reset- %d pcControl- %b",pc,clk,reset,pcControl);
    end
endmodule
