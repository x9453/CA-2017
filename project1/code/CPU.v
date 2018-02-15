module CPU
(
    clk_i, 
    start_i
);

// Ports
input   clk_i;
input   start_i;
wire 		IF_ID_Wr,PC_Wr,ID_MUX_EX;
wire [31:0] IF_pc_add_4,IF_inst_addr, IF_inst;
wire        is_zero,is_jump,is_stall,is_flush;
wire [31:0]	ID_pc_add_4,ID_inst,ID_a,ID_b,ID_immediate;
wire 		ID_RegDst,ID_ALUSrc,ID_RegWr,ID_Branch,ID_MemRd,ID_MemtoReg,ID_MemWr;
wire 		ID_RegDst_MUX,ID_ALUSrc_MUX,ID_RegWr_MUX,ID_MemRd_MUX,ID_MemtoReg_MUX,ID_MemWr_MUX;
wire [31:0]	EX_pc_add_4,EX_inst,EX_a,EX_b,EX_immediate,EX_ALUout;
wire 		EX_RegDst,EX_ALUSrc,EX_RegWr,EX_MemRd,EX_MemtoReg,EX_MemWr;
wire [31:0] MEM_b,MEM_ALUout,MEM_mdr;
wire 		MEM_RegWr,MEM_MemRd,MEM_MemtoReg,MEM_MemWr;
wire [31:0] WB_ALUout,WB_mdr,WB_MUX_o;
wire 		WB_RegWr,WB_MemtoReg;
wire [4:0]	WB_RDaddr,EX_RDaddr,MEM_RDaddr;
wire [1:0]	ID_ALUOp,ID_ALUOp_MUX,EX_ALUOp;
wire [31:0] jump_addr, inst_extend,MUX_ALUSrc2_o;

wire [31:0] IF_MUX_Branch_o;
assign is_flush = is_jump | (is_zero & ID_Branch);
assign jump_addr[31:28] = IF_MUX_Branch_o[31:28];

//IF stage
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (),//MUX_PC_JUMP output
    .pc_o       (IF_inst_addr),
	.PC_Wr		(PC_Wr)
//	.IF_ID_Wr_o	(IF_ID_Wr)
);
Adder Add_PC(
    .data1_in   (IF_inst_addr),
    .data2_in   (32'd4),
    .data_o     (IF_pc_add_4)
);
Instruction_Memory Instruction_Memory(
    .addr_i     (IF_inst_addr), 
    .instr_o    (IF_inst)
);
MUX32 MUX_PC_Branch(
    .data1_i    (IF_pc_add_4),
    .data2_i    (),//Add_Branch
    .select_i   (is_zero & ID_Branch),
    .data_o     (IF_MUX_Branch_o)
);
MUX32 MUX_PC_Jump(
    .data1_i    (IF_MUX_Branch_o),
    .data2_i    (jump_addr),
    .select_i   (is_jump),//Control.Jump
    .data_o     (PC.pc_i)
);
IF_ID IF_ID(
	.clk_i		(clk_i),
	.IR_i		(IF_inst),
	.PC_i		(IF_pc_add_4),
	.IR_o		(ID_inst),
	.PC_o		(ID_pc_add_4),
	.IF_ID_Wr	(IF_ID_Wr),
	.is_flush	(is_flush)
);
//ID stage
Control Control(
    .Op_i       (ID_inst[31:26]),
    .RegDst_o   (ID_RegDst/*MUX_RegDst.select_i*/),
    .ALUOp_o    (ID_ALUOp/*ALU_Control.ALUOp_i*/),
    .ALUSrc_o   (ID_ALUSrc/*MUX_ALUSrc.select_i*/),
    .RegWrite_o (ID_RegWr/*Registers.RegWrite_i*/),
    .Jump_o     (is_jump),
    .Branch_o   (ID_Branch),
    .MemRead_o  (ID_MemRd/*Data_Memory.MemRead_i*/),
    .MemtoReg_o (ID_MemtoReg/*MUX_MemToReg.select_i*/),
    .MemWrite_o (ID_MemWr/*Data_Memory.MemWrite_i*/)
);
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (ID_inst[25:21]),
    .RTaddr_i   (ID_inst[20:16]),
    .RDaddr_i   (WB_RDaddr), 
    .RDdata_i   (WB_MUX_o),
    .RegWrite_i (WB_RegWr), 
    .RSdata_o   (ID_a/*ALU.data1_i*/), 
    .RTdata_o   (ID_b/*RTdata*/) 
);
Sign_Extend Sign_Extend(
    .data_i     (ID_inst[15:0]),
    .data_o     (ID_immediate)
);
Shift26 Shift_inst(
    .data_i     (ID_inst[25:0]),
    .data_o     (jump_addr[27:0])
);
Shift32 Shift_Branch(
    .data_i     (ID_immediate),
    .data_o     (Add_Branch.data2_in)
);
Adder Add_Branch(
    .data1_in   (ID_pc_add_4),
    .data2_in   (),//Shift 32 output
    .data_o     (MUX_PC_Branch.data2_i)
);
EQ EQ(
    .RSaddr_i	(ID_a),
    .RTaddr_i	(ID_b),
    .EQ_o		(is_zero)
);
Hazard_Detection HD(
//	.clk_i		(clk_i),
	.IF_ID_Wr	(IF_ID_Wr),//new wire
	.PC_Wr		(PC_Wr),//new wire
	.ID_MUX_EX	(ID_MUX_EX),//new wire
	.ID_EX_MemRd(EX_MemRd),
	.EX_RT		(EX_inst[20:16]),
	.ID_RT			(ID_inst[20:16]),
	.ID_RS			(ID_inst[25:21]),
	.is_stall	(is_stall)
);
MUX8 IDEX_MUX(
	.data1_i	({ID_RegDst,ID_ALUSrc,ID_RegWr,ID_MemRd,ID_MemtoReg,ID_MemWr,ID_ALUOp}),
    .data2_i	(8'b0),
    .select_i	(ID_MUX_EX),
    .data_o		({ID_RegDst_MUX,ID_ALUSrc_MUX,ID_RegWr_MUX,ID_MemRd_MUX,ID_MemtoReg_MUX,ID_MemWr_MUX,ID_ALUOp_MUX})
);
ID_EX ID_EX(
	.clk_i		(clk_i),
    .a_i		(ID_a),
    .b_i		(ID_b),
    .immediate_i(ID_immediate),
    .ALUSrc_i	(ID_ALUSrc_MUX),
    .ALUOp_i	(ID_ALUOp_MUX),
    .RegDst_i	(ID_RegDst_MUX),
	.MemRd_i	(ID_MemRd_MUX),
    .MemWr_i	(ID_MemWr_MUX),
    .MemtoReg_i	(ID_MemtoReg_MUX),
    .RegWr_i	(ID_RegWr_MUX),
    .inst_i		(ID_inst),
    .a_o		(EX_a),
    .b_o		(EX_b),
    .immediate_o(EX_immediate),
    .ALUSrc_o	(EX_ALUSrc),
    .ALUOp_o	(EX_ALUOp),
    .RegDst_o	(EX_RegDst),
	.MemRd_o	(EX_MemRd),
    .MemWr_o	(EX_MemWr),
    .MemtoReg_o	(EX_MemtoReg),
    .RegWr_o	(EX_RegWr),
    .inst_o		(EX_inst)
);
//EX stage
MUX5 MUX_RegDst(
    .data1_i    (EX_inst[20:16]),
    .data2_i    (EX_inst[15:11]),
    .select_i   (EX_RegDst),
    .data_o     (EX_RDaddr)
);
MUX32 MUX_ALUSrc(
    .data1_i    (MUX_ALUSrc2_o),
    .data2_i    (EX_immediate),
    .select_i   (EX_ALUSrc),
    .data_o     (ALU.data2_i)
);
MUX3_32 MUX_ALUSrc1(
	.data0_i	(EX_a),
    .data1_i	(WB_MUX_o),
    .data2_i	(MEM_ALUout),
    .select_i	(),
    .data_o		(ALU.data1_i)
);
MUX3_32 MUX_ALUSrc2(
	.data0_i	(EX_b),
    .data1_i	(WB_MUX_o),
    .data2_i	(MEM_ALUout),
    .select_i	(),
    .data_o		(MUX_ALUSrc2_o)
);
ALU ALU(
    .data1_i    (),
    .data2_i    (),//ALUSrc output
    .ALUCtrl_i  (),
    .data_o     (EX_ALUout)
);
ALU_Control ALU_Control(
    .funct_i    (EX_immediate[5:0]),//R-type func
    .ALUOp_i    (EX_ALUOp),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);
Forward_Ctrl Forward_Ctrl(
    .ID_EX_RS_i	(EX_inst[25:21]),
    .ID_EX_RT_i	(EX_inst[20:16]),
    .EX_MEM_RD_i(MEM_RDaddr),
    .EX_MEM_RegWr_i(MEM_RegWr),
    .MEM_WB_RD_i(WB_RDaddr),
    .MEM_WB_RegWr_i(WB_RegWr),
    .Forward_A_o(MUX_ALUSrc1.select_i),
    .Forward_B_o(MUX_ALUSrc2.select_i)
);
EX_MEM EX_MEM(
	.clk_i		(clk_i),
    .ALUout_i	(EX_ALUout),
    .ID_EX_B_i	(MUX_ALUSrc2_o),
    .EX_MUX_i	(EX_RDaddr),
    .MemRd_i	(EX_MemRd),
    .MemWr_i	(EX_MemWr),
    .MemtoReg_i	(EX_MemtoReg),
    .RegWr_i	(EX_RegWr),
    .ALUout_o	(MEM_ALUout),
    .ID_EX_B_o	(MEM_b),
    .EX_MUX_o	(MEM_RDaddr),
    .MemRd_o	(MEM_MemRd),
    .MemWr_o	(MEM_MemWr),
    .MemtoReg_o	(MEM_MemtoReg),
    .RegWr_o	(MEM_RegWr)
);
//MEM stage
Data_Memory Data_Memory
(
    .clk_i       (clk_i),
    .addr_i      (MEM_ALUout),
    .WriteData_i (MEM_b),
    .MemRead_i   (MEM_MemRd),
    .MemWrite_i  (MEM_MemWr),
    .ReadData_o  (MEM_mdr)
);
MEM_WB MEM_WB(
	.clk_i		(clk_i),
    .mdr_i		(MEM_mdr),
    .ALU_result_i(MEM_ALUout),
    .MemtoReg_i	(MEM_MemtoReg),
    .RegWr_i	(MEM_RegWr),
    .EX_MUX_i	(MEM_RDaddr),
    .mdr_o		(WB_mdr),
    .ALU_result_o(WB_ALUout),
    .MemtoReg_o	(WB_MemtoReg),
    .RegWr_o	(WB_RegWr),
    .EX_MUX_o	(WB_RDaddr)
);
//WB stage
MUX32 MUX_MemToReg(
    .data1_i    (WB_ALUout),
    .data2_i    (WB_mdr),
    .select_i   (WB_MemtoReg),
    .data_o     (WB_MUX_o)
);

endmodule