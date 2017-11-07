`timescale 1ns / 1ps

module cpu(
    input clk,
    input rst
    );
    wire [31:0] pc_instaddr;
    wire [31:0] instruction;
    wire [1:0] pccontrol;
    wire reg_wr_add_control;
    wire  datamem_readen;
    wire  datawr_select;
    wire [2:0] alu_op;
    wire datamemwriteen;
    wire alusrcselect;
    wire reg_wr_en;
    wire branch_control;
    wire jump_control;
    wire [31:0] sign_extend;
    wire [31:0] reg1data;
    wire [31:0] reg2data;
    wire [31:0] regwrdata;
    wire [4:0] reg_radd0;
    wire [4:0] reg_radd1;
    wire [4:0] reg_waddr;
    wire [31:0] alu_operand;
    wire [5:0] alu_control_otp;
    wire [31:0] alu_otp;
    wire alu_zero;
    wire overflow_signal;
    wire [31:0] data_mem_in;
    wire [31:0] data_mem_out;   
    ProgramCounter prcount (
        .clk(clk),
        .reset(rst),
        .pcControl(pccontrol),
        .jumpAddress(instruction[25:0]),
        .branchOffset(instruction[15:0]),
        .regAddress(reg1data),
        .pc(pc_instaddr)
        );
        
    MainMemoryModule instructionMemory(
        .clk(clk),
        .address(pc_instaddr),
        .readEnable(1'b1),
        .writeEnable(1'b0),
        .dataIn(32'h000000),
        .dataOut(instruction)
        );
        
    control_unit signals(
        .instruction(instruction),
        .RegDst(reg_wr_add_control),
        .MemRead(datamem_readen),
        .MemToReg(datawr_select),
        .ALUOp(alu_op),
        .MemWrite(datamemwriteen),
        .ALUSrc(alusrcselect),
        .RegWrite(reg_wr_en),
        .Branch(branch_control),
        .Jump(jump_control)
        );
    





    assign reg_radd0 = instruction[25:21];

    assign reg_radd1 = instruction[20:16];

    regmux2x1 reg_wr_dst(
        .select(reg_wr_add_control),
        .in0(reg_radd1),
        .in1(instruction[15:11]),
        .out(reg_waddr)
        );

    Register_File regfile(
        .clk(clk),
        .read_addr1(reg_radd0),
        .read_addr2(reg_radd1),
        .write_addr(reg_waddr),
        .write_data(regwrdata),
        .write_enable(reg_wr_en),
        .read_data1(reg1data),
        .read_data2(reg2data)
        );

    signExtension sign(
        .in(instruction[15:0]),
        .out(sign_extend)
        );

    mux2x1 alusrc_select(
        .select(alusrcselect),
        .in0(reg2data),
        .in1(sign_extend),
        .out(alu_operand)
        );
        
    alu_control alucntrl(
        .instruction(instruction),
        .ALUOp(alu_op),
        .ALUFn(alu_control_otp)
        );
        
    ALU alu(.a(reg1data),
        .b(alu_operand),
        .alufn(alu_control_otp),
        .otp(alu_otp),
        .zero(alu_zero),
        .overflow(overflow_signal)
        );
 
    MainMemoryModule data_mem(.clk(clk),
        .address(alu_otp),
        .readEnable(datamem_readen),
        .writeEnable(datamemwriteen),
        .dataIn(data_mem_in),
        .dataOut(data_mem_out)
        );
    mux2x1 write_select(.select(datawr_select),
        .in1(data_mem_out),
        .in0(alu_otp),
        .out(regwrdata)
        );

    
     assign data_mem_in=reg2data;
 always @(posedge clk)
     begin
         $display("INSTRUCTION=%h - reg1data=%d - reg2data=%d  - alu_control_otp=%d - datamemwriteen=%d - data_mem_in=%d - alu_otp=%d",
             instruction, 
             reg1data, 
             reg2data,
             alu_control_otp,
             datamemwriteen,
             data_mem_in,
             alu_otp);
     end
endmodule