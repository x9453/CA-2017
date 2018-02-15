module ID_EX
(
    clk_i,
    a_i,
    b_i,
    immediate_i,
    ALUSrc_i,
    ALUOp_i,
    RegDst_i,
    MemRd_i,
    MemWr_i,
    MemtoReg_i,
    RegWr_i,
    inst_i,
	ID_EX_Enable,
    a_o,
    b_o,
    immediate_o,
    ALUSrc_o,
    ALUOp_o,
    RegDst_o,
    MemRd_o,
    MemWr_o,
    MemtoReg_o,
    RegWr_o,
    inst_o
);

// Ports
input               clk_i;

input   [31:0]      a_i;
input   [31:0]      b_i;
input   [31:0]      immediate_i;
input               ALUSrc_i;
input   [1:0]       ALUOp_i;
input               RegDst_i;
input               MemRd_i;
input               MemWr_i;
input               MemtoReg_i;
input               RegWr_i;
input   [31:0]      inst_i;
input 				ID_EX_Enable;

output  [31:0]      a_o;
output  [31:0]      b_o;
output  [31:0]      immediate_o;
output              ALUSrc_o;
output  [1:0]       ALUOp_o;
output              RegDst_o;
output              MemRd_o;
output              MemWr_o;
output              MemtoReg_o;
output              RegWr_o;
output  [31:0]      inst_o;

// Register File
reg     [31:0]      a_reg;
reg     [31:0]      b_reg;
reg     [31:0]      immediate_reg;
reg                 ALUSrc_reg;
reg     [1:0]       ALUOp_reg;
reg                 RegDst_reg;
reg                 MemRd_reg;
reg                 MemWr_reg;
reg                 MemtoReg_reg;
reg                 RegWr_reg;
reg     [31:0]      inst_reg;

// Read Data      
assign  a_o = a_reg;
assign  b_o = b_reg;
assign  immediate_o = immediate_reg;
assign  ALUSrc_o = ALUSrc_reg;
assign  ALUOp_o = ALUOp_reg;
assign  RegDst_o = RegDst_reg;
assign  MemRd_o = MemRd_reg;
assign  MemWr_o = MemWr_reg;
assign  MemtoReg_o = MemtoReg_reg;
assign  RegWr_o = RegWr_reg;
assign  inst_o = inst_reg;

// Write Data   
always@(posedge clk_i) begin
	if(~ID_EX_Enable)begin
	end
	else begin
    a_reg <= a_i;
    b_reg <= b_i;
    immediate_reg <= immediate_i;
    ALUSrc_reg <= ALUSrc_i;
    ALUOp_reg <= ALUOp_i;
    RegDst_reg <= RegDst_i;
    MemRd_reg <= MemRd_i;
    MemWr_reg <= MemWr_i;
    MemtoReg_reg <= MemtoReg_i;
    RegWr_reg <= RegWr_i;
    inst_reg <= inst_i;
	end
end
   
endmodule