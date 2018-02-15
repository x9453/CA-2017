module Control(
    Op_i,
    RegDst_o,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    //new
    Jump_o,
    Branch_o,
    MemRead_o,
    MemtoReg_o,
    MemWrite_o
);

input	[5:0]	Op_i;

output reg		RegDst_o;
output reg	[1:0]	ALUOp_o;
output reg		ALUSrc_o;
output reg		RegWrite_o;
output reg		Jump_o;
output reg		Branch_o;
output reg		MemRead_o;
output reg		MemtoReg_o;
output reg		MemWrite_o;
//000000 R-type //001000 addi // 101011 sw // 100011 lw //000010 j //000100 beq
initial begin
    	RegDst_o = 1'b0;
		ALUOp_o = 2'b0;
		ALUSrc_o = 1'b0;
		RegWrite_o = 1'b0;
		Jump_o = 1'b0;
		Branch_o = 1'b0;
		MemRead_o = 1'b0;
		MemtoReg_o = 1'b0;
		MemWrite_o = 1'b0;
end
always@(*)begin
RegDst_o = (Op_i==6'b000000)? 1'b1: // R-type
		  (Op_i==6'b000010)? 1'b0: // j
		  (Op_i==6'b001000)? 1'b0: // addi
		  (Op_i==6'b101011)? 1'b0: // sw
		  (Op_i==6'b100011)? 1'b0: // lw
		  (Op_i==6'b000100)? 1'b0: // beq
				     1'b0;
ALUOp_o =  (Op_i==6'b000000)? 2'b10: // R-type
		  (Op_i==6'b000010)? 2'b00: // j
		  (Op_i==6'b001000)? 2'b00: // addi
		  (Op_i==6'b101011)? 2'b00: // sw
		  (Op_i==6'b100011)? 2'b00: // lw
		  (Op_i==6'b000100)? 2'b01: // beq
				     2'b00;
ALUSrc_o = (Op_i==6'b000000)? 1'b0: // R-type
		  (Op_i==6'b000010)? 1'b0: // j
		  (Op_i==6'b001000)? 1'b1: // addi
		  (Op_i==6'b101011)? 1'b1: // sw
		  (Op_i==6'b100011)? 1'b1: // lw
		  (Op_i==6'b000100)? 1'b0: // beq
				     1'b0;
MemRead_o = (Op_i==6'b000000)? 1'b0: // R-type
		   (Op_i==6'b000010)? 1'b0: // j
		   (Op_i==6'b001000)? 1'b0: // addi
		   (Op_i==6'b101011)? 1'b0: // sw
		   (Op_i==6'b100011)? 1'b1: // lw
		   (Op_i==6'b000100)? 1'b0: // beq
				      1'b0;
MemWrite_o = (Op_i==6'b000000)? 1'b0: // R-type
		    (Op_i==6'b000010)? 1'b0: // j
		    (Op_i==6'b001000)? 1'b0: // addi
		    (Op_i==6'b101011)? 1'b1: // sw
		    (Op_i==6'b100011)? 1'b0: // lw
		    (Op_i==6'b000100)? 1'b0: // beq
				       1'b0;
RegWrite_o = (Op_i==6'b000000)? 1'b1: // R-type
		    (Op_i==6'b000010)? 1'b0: // j
		    (Op_i==6'b001000)? 1'b1: // addi
		    (Op_i==6'b101011)? 1'b0: // sw
		    (Op_i==6'b100011)? 1'b1: // lw
		    (Op_i==6'b000100)? 1'b0: // beq
				       1'b0;
MemtoReg_o = (Op_i==6'b000000)? 1'b0: // R-type
		    (Op_i==6'b000010)? 1'b0: // j
		    (Op_i==6'b001000)? 1'b0: // addi
		    (Op_i==6'b101011)? 1'b0: // sw
		    (Op_i==6'b100011)? 1'b1: // lw
		    (Op_i==6'b000100)? 1'b0: // beq
				       1'b0;
Jump_o =   (Op_i==6'b000000)? 1'b0: // R-type
		  (Op_i==6'b000010)? 1'b1: // j
		  (Op_i==6'b001000)? 1'b0: // addi
		  (Op_i==6'b101011)? 1'b0: // sw
		  (Op_i==6'b100011)? 1'b0: // lw
		  (Op_i==6'b000100)? 1'b0: // beq
				     1'b0;
Branch_o = (Op_i==6'b000000)? 1'b0: // R-type
		  (Op_i==6'b000010)? 1'b0: // j
		  (Op_i==6'b001000)? 1'b0: // addi
		  (Op_i==6'b101011)? 1'b0: // sw
		  (Op_i==6'b100011)? 1'b0: // lw
		  (Op_i==6'b000100)? 1'b1: // beq
				     1'b0;
end
endmodule
