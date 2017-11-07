`timescale 1ns / 1ps

module cpu(
    input clk,
    input rst
);
    wire [31:0] alu_operand;
    wire [31:0] alu_otp;
    wire [31:0] pc_instaddr;
    wire [31:0] instruction;
    wire [31:0] sign_extend;
    wire [31:0] reg1data;
    wire [31:0] reg2data;
    wire [31:0] regwrdata;
    wire [31:0] data_mem_in;
    wire [31:0] data_mem_out;   
    wire [1:0]  pccontrol;
    wire [2:0]  alu_op;
    wire [4:0]  reg_radd0;
    wire [4:0]  reg_radd1;
    wire [4:0]  reg_waddr;
    wire [5:0]  alu_control_otp;
    wire        reg_wr_add_control;
    wire        datamem_readen;
    wire        datawr_select;
    wire        datamemwriteen;
    wire        alusrcselect;
    wire        reg_wr_en;
    wire        branch_control;
    wire        jump_control;
    wire        alu_zero;
    wire        overflow_signal;
    reg pcsrc;
    wire jump_s4;
    wire [31:0] jaddr_s4;
    reg [1:0] forward_a;
    reg [1:0] forward_b;
    wire [31:0] branchOffset_s4;


    //STAGE5 SE JO WRITE KE LIYE CONTROL, REG, OR DATA AAEGA YE VO HAI(UPAR WALE USE NAHI KIYE NAYE BANAYE HAI AGAR CHALTA HAI TO UPAR WALE DEKH KE HATA DENGE)
    wire        RegWriteControl_s5;
    wire [4:0]  writeReg_s5;
    wire [31:0] writeData_s5;
    reg stall_s1_s2;
    
   /* ProgramCounter prcount (
        .clk(clk),
        .reset(rst),
        .pcControl(pccontrol),
        .jumpAddress(instruction[25:0]),
        .branchOffset(instruction[15:0]),
        .regAddress(reg1data),
        .pc(pc_instaddr)
    );
    */

    // FLUSH CONTROL I GUESS
    reg flush_s1, flush_s2, flush_s3;
    always @(*) begin
        flush_s1 <= 1'b0;
        flush_s2 <= 1'b0;
        flush_s3 <= 1'b0;
        if (pcsrc | jump_s4) begin
            flush_s1 <= 1'b1;
            flush_s2 <= 1'b1;
            flush_s3 <= 1'b1;
        end
    end

    // New pc as in datapath
    reg  [31:0] pc;
    initial begin
        pc <= 32'd0;
    end

    //PC+4 GENERATE KAR RAHA HAI
    wire [31:0] pc4;  // PC + 4
    assign pc4 = pc + 1;

    MainMemoryModule instructionMemory(
        .clk(clk),
        .address(pc),
        .readEnable(1'b1),
        .writeEnable(1'b0),
        .dataIn(32'h000000),
        .dataOut(instruction)
    );
    
    // PC MAIN KYA VALUE JANIN HAI DEPENDING ON AAGE KI STAGES KE CONTROL SIGNAL KYA HAI
    always @(posedge clk) begin
        if (stall_s1_s2) 
            pc <= pc;
        else if (pcsrc == 1'b1)
            pc <= branchOffset_s4;
        else if (jump_s4 == 1'b1)
            pc <= jaddr_s4;
        else
            pc <= pc4;
    end
    //END OF STAGE1
    //STAGE2 START HO RAHI HAI YAHA SE 
    
    //STAGE2 KA PC OUTPUT HAI APNE BUFFER REGISTER KA AND INPUT HAI JO PC UPAR DECIDE HUA HAI AND ISME EK FLUSH KA SIGNAL EK HOLD SIGNAL HAI.
    wire [31:0] pc4_s2;
    regr #(.N(32)) regr_pc4_s2(.clk(clk),
                        .hold(stall_s1_s2),
                        .clear(flush_s1),
                        .in(pc4),
                        .out(pc4_s2)
                        );

    
    //STAGE2 KA INSTRUCTION JO PASS ON HONA
    wire [31:0] instruction_s2;

    regr #(.N(32)) regr_instruction_s2(
                        .clk(clk),
                        .hold(stall_s1_s2),
                        .clear(flush_s1),
                        .in(instruction),
                        .out(instruction_s2)
                        );

    control_unit signals(
        .instruction(instruction_s2),
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

    //SAARE KE SAARE CONTROL SIGNALS AAGE BHEJ RAHA HU KYUKI VO SAARE STAGE2 MAIN NAHI STAGE3 MAIN USE HO RAHE HAI
    wire reg_wr_add_control_s3,datamem_readen_s3,datawr_select_s3,datamemwriteen_s3,alusrcselect_s3,reg_wr_en_s3,branch_control_s3;
    wire [2:0] alu_op_s3;
    regr #(.N(10)) regr_s3_control(.clk(clk), 
                            .clear(1'b0),
                            .hold(stall_s1_s2),
                            .in({reg_wr_add_control,datamem_readen,datawr_select,alu_op,datamemwriteen,alusrcselect,reg_wr_en,branch_control}),
                            .out({reg_wr_add_control_s3,datamem_readen_s3,datawr_select_s3,alu_op_s3,datamemwriteen_s3,alusrcselect_s3,reg_wr_en_s3,branch_control_s3}));

    wire jump_s3;
    regr #(.N(1)) reg_jump_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
                .in(jump_control),
                .out(jump_s3));


    assign reg_radd0 = instruction_s2[25:21];

    assign reg_radd1 = instruction_s2[20:16];

    //YE WALA WRITE ADDRESS CHECK KARNE WALA MUX SHIFT HOGA STAGE3 MAIN TO WAHA SHIFT KARNA HAI
    
    /*regmux2x1 reg_wr_dst(
        .select(reg_wr_add_control),
        .in0(reg_radd1),
        .in1(instruction_s2[15:11]),
        .out(reg_waddr)
    );*/

    Register_File regfile(
        .clk(clk),
        .read_addr1(reg_radd0),
        .read_addr2(reg_radd1),
        .write_addr(writeReg_s5),
        .write_data(writeData_s5),
        .write_enable(RegWriteControl_s5),
        .read_data1(reg1data),
        .read_data2(reg2data)
    );

    //RS PASS KAR RAHA HAI STAGE3 FOR FORWARDING AATA NAHI HAI MUJHE JAHA SE CODE CHAP RAHA HU WAHA SE DEKH KE KAR RAHA HU BAS SO FORGIVE ME IF I CREATE A FUCK UP
    wire [4:0] reg_radd0_s3;
    regr #(.N(5)) regr_s3_radd0(.clk(clk), 
                            .clear(1'b0),
                            .hold(stall_s1_s2),
                            .in(reg_radd0),
                            .out(reg_radd0_s3));

    //TRANSFER THE DATA READ FROM REG FILE TO STAGE3 
    wire [31:0] reg1data_s3;
    wire [31:0] reg2data_s3;
    regr #(.N(64)) reg_s3_register_file(.clk(clk), 
                            .clear(flush_s2), 
                            .hold(stall_s1_s2),
                            .in({reg1data, reg2data}),
                            .out({reg1data_s3, reg2data_s3}));

    //SIGN EXTEND KARA BAAD KI 16BITS KA FOR I FORMAT AND THEN USKO STAGE3 ME PASS KAR DIYA WITH THE NAME OF SIGNEXTEND_S3
    signExtension sign(
        .in(instruction[15:0]),
        .out(sign_extend)
    );

    wire [31:0] sign_extend_s3;
    regr #(.N(32)) reg_s3_signextend(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in(sign_extend), 
                        .out(sign_extend_s3));
    
    //VO JO UPAR KA MUX HATAYA THA VO STAGE 3 MAIN JAEGA TO USKE LIYE RT,RD AAGE BHEJ RAHE HAI MAST VO MUX MAIN JAENGE AND YAHA VO MUX LAG JAEGA
    wire [4:0]  rt_s3;
    wire [4:0]  rd_s3;
    
    regr #(.N(10)) reg_s2_rt_rd(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in({instruction_s2[20:16], instruction_s2[15:11]}), 
                        .out({rt_s3, rd_s3}));

    //PC4 KO STAGE3 MAIN BHEJ RAHA HAI WAHA PE MAST JUMP WUMP KE LIYE SETUP KAR DENGE
    wire [31:0] pc4_s3;
    regr #(.N(32)) reg_pc4_s2(.clk(clk),
                        .clear(1'b0), 
                        .hold(stall_s1_s2),
                        .in(pc4_s2), 
                        .out(pc4_s3));
    
    wire [31:0] instruction_s3;
    regr #(.N(32)) reg_s3_instruction(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in(instruction_s2), 
                        .out(instruction_s3));

    wire [4:0] rs_s3;
    regr #(.N(5)) regr_s2_rs(.clk(clk), .clear(1'b0), .hold(stall_s1_s2),
                .in(instruction_s2[25:21]), .out(rs_s3));
    
    wire [31:0] jaddr_s2;
    assign jaddr_s2 = {pc[31:26],instruction_s2[25:0]};

    wire [31:0] jaddr_s3;
    regr #(.N(32)) reg_jaddr_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
                .in(jaddr_s2), .out(jaddr_s3));

    //END OF STAGE2
    //STAGE3 BEGINS

    //ALU KE ANDAR KYA JANA HAI YE DEKH RAHA TO ISME REG2DATA OR SIGNEXTEND JAENGE STAGE3 MAIN AAYE HUE
    
    mux2x1 alusrc_select(
        .select(alusrcselect_s3),
        .in0(reg2data_s3),
        .in1(sign_extend_s3),
        .out(alu_operand)
    );

    alu_control alucntrl(
        .instruction(instruction_s3),
        .ALUOp(alu_op_s3),
        .ALUFn(alu_control_otp)
    );
        
    reg [31:0] fw_reg1data_s3;
    wire [31:0] alu_otp_s4;

    always @(*)
    case (forward_a)
            2'd1: fw_reg1data_s3 = alu_otp_s4;
            2'd2: fw_reg1data_s3 = writeData_s5;
         default: fw_reg1data_s3 = reg1data_s3;
    endcase
    
    //ALU MAIN JO CONTROL SIGNAL JANA HAI VO AB STAGE3 WALA HAI BAS
    ALU alu(.a(fw_reg1data_s3),
        .b(alu_operand),
        .alufn(alu_control_otp),
        .otp(alu_otp),
        .zero(alu_zero),
        .overflow(overflow_signal)
    );

    //ALU KE OUTPUT AAGE BHEJ DIYE HAI MAST
    wire alu_zero_s4;
    regr #(.N(33)) reg_s4_aluotp(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in({alu_otp,alu_zero}), 
                        .out({alu_otp_s4,alu_zero_s4}));

    reg [31:0] fw_reg2data_s3;
    always @(*)
    case (forward_b)
            2'd1: fw_reg2data_s3 = alu_otp_s4;
            2'd2: fw_reg2data_s3 = writeData_s5;
         default: fw_reg2data_s3 = reg2data_s3;
    endcase

    //REG2 KA DATA AAGE FORWARD KAR RAHA HU
    wire [31:0] reg2data_s4;
    regr #(.N(32)) reg_s4_reg2data(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in({fw_reg2data_s3}), 
                        .out(reg2data_s4));

    //REG DESTINATION PATA LAGANE KE LIYE DATAPATH MAIN NEECHE WALA MUX HAI PAGE348 OF P&H AND USSE AAGE BHEJA HAI STAGE4
    regmux2x1 reg_wr_dst(
        .select(reg_wr_add_control_s3),
        .in0(rt_s3),
        .in1(rd_s3),
        .out(reg_waddr)
    );

    wire [4:0] reg_waddr_s4;
    regr #(.N(5)) reg_s4_waddr(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in(reg_waddr), 
                        .out(reg_waddr_s4));


    wire [31:0] branchOffset;
    assign branchOffset = pc4_s3 + sign_extend_s3;
    regr #(.N(32)) reg_s4_branchOffset(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in(branchOffset), 
                        .out(branchOffset_s4));

    //JO CONTROL SIGNALS MEMORY KE HAI AUR JO SAALE WRITE KE HAI UNHE AAGE BHEJ DIYA HAI MAINE BAS
    wire reg_wr_en_s4,datamemwriteen_s4,datawr_select_s4,datamem_readen_s4,branch_control_s4;
    regr #(.N(32)) reg_s4_remainingControls(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in({reg_wr_en_s3,datamemwriteen_s3,datawr_select_s3,datamem_readen_s3,branch_control_s3}), 
                        .out({reg_wr_en_s4,datamemwriteen_s4,datawr_select_s4,datamem_readen_s4,branch_control_s4}));
    
    regr #(.N(32)) reg_jaddr_s4(.clk(clk), .clear(flush_s3), .hold(1'b0),
                .in(jaddr_s3), .out(jaddr_s4));

    
    regr #(.N(1)) reg_jump_s4(.clk(clk), .clear(flush_s3), .hold(1'b0),
                .in(jump_s3),
                .out(jump_s4));


    //STAGE3 ENDS
    //STAGE4 BEGINS
    //NEECHE JO WRITE DESTINATION REG HAI USKO PHIR AAGE BHEJ DIYA HAI

    always @(*) begin
         pcsrc <= branch_control_s4 & alu_zero_s4;
    end

    wire [4:0] reg_waddr_s5;
    regr #(.N(5)) reg_s5_regwaddr(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in(reg_waddr_s4), 
                        .out(reg_waddr_s5));

    wire reg_wr_en_s5,datawr_select_s5;
    regr #(.N(2)) reg_s5_controls(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in({reg_wr_en_s4,datawr_select_s4}), 
                        .out({reg_wr_en_s5,datawr_select_s5}));

    MainMemoryModule data_mem(.clk(clk),
        .address(alu_otp_s4),
        .readEnable(datamem_readen_s4),
        .writeEnable(datamemwriteen_s4),
        .dataIn(reg2data_s4),
        .dataOut(data_mem_out)
    );
    //assign data_mem_in=reg2data;
    
    wire [31:0] alu_otp_s5;
    wire [31:0] data_mem_out_s5;
    regr #(.N(64)) reg_s5_mainMemory(.clk(clk), 
                        .clear(flush_s2), 
                        .hold(stall_s1_s2),
                        .in({alu_otp_s4,data_mem_out}), 
                        .out({alu_otp_s5,data_mem_out_s5}));

    //STAGE4 ENDS
    //STAGE5 BEGINS

    //WRITE SELECT MUX HAI WITH NAYA CONTROL SIGNAL AND DATA TO BE COMPARED
    mux2x1 write_select(.select(datawr_select_s5),
        .in1(data_mem_out_s5),
        .in0(alu_otp_s5),
        .out(regwrdata)
    );
    assign writeData_s5 = regwrdata;
    assign writeReg_s5 = reg_waddr_s5;
    assign RegWriteControl_s5 = reg_wr_en_s5;

    
    //FORWARDING
    // stage 3 (MEM) -> stage 2 (EX)
    // stage 4 (WB) -> stage 2 (EX)

    always @(*) begin
        // If the previous instruction (stage 4) would write,
        // and it is a value we want to read (stage 3), forward it.

        // data1 input to ALU
        if ((reg_wr_en_s4 == 1'b1) && (reg_waddr_s4 == rs_s3)) begin
            forward_a <= 2'd1;  // stage 4
        end else if ((reg_wr_en_s5 == 1'b1) && (reg_waddr_s5 == rs_s3)) begin
            forward_a <= 2'd2;  // stage 5
        end else
            forward_a <= 2'd0;  // no forwarding

        // data2 input to ALU
        if ((reg_wr_en_s4 == 1'b1) & (reg_waddr_s4 == rt_s3)) begin
            forward_b <= 2'd1;  // stage 5
        end else if ((reg_wr_en_s5 == 1'b1) && (reg_waddr_s5 == rt_s3)) begin
            forward_b <= 2'd2;  // stage 5
        end else
            forward_b <= 2'd0;  // no forwarding
    end



    //STALLING
    always @(*) begin
        if (datamem_readen_s3== 1'b1 && ((instruction_s2[20:16] == rt_s3) || (instruction_s2[25:21] == rt_s3)) ) begin
            stall_s1_s2 <= 1'b1;  // perform a stall
        end else
            stall_s1_s2 <= 1'b0;  // no stall
    end




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
