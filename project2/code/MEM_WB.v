module MEM_WB
(
    clk_i,
    mdr_i,
    ALU_result_i,
    MemtoReg_i,
    RegWr_i,
    EX_MUX_i,
	MEM_WB_Enable,
    mdr_o,
    ALU_result_o,
    MemtoReg_o,
    RegWr_o,
    EX_MUX_o
);

// Ports
input               clk_i;

input   [31:0]      mdr_i;
input   [31:0]      ALU_result_i;
input               MemtoReg_i;
input               RegWr_i;
input   [4:0]       EX_MUX_i;
input				MEM_WB_Enable;

output  [31:0]      mdr_o;
output  [31:0]      ALU_result_o;
output              MemtoReg_o;
output              RegWr_o;
output  [4:0]       EX_MUX_o;

// Register File
reg     [31:0]      mdr_reg;
reg     [31:0]      ALU_result_reg;
reg                 MemtoReg_reg;
reg                 RegWr_reg;
reg     [4:0]       EX_MUX_reg;

// Read Data
assign  mdr_o = mdr_reg;
assign  ALU_result_o = ALU_result_reg;
assign  MemtoReg_o = MemtoReg_reg;
assign  RegWr_o = RegWr_reg;
assign  EX_MUX_o = EX_MUX_reg;

// Write Data   
always@(posedge clk_i) begin
	if(~MEM_WB_Enable)begin
	end
	else begin
    mdr_reg <= mdr_i;
    ALU_result_reg <= ALU_result_i;
    MemtoReg_reg <= MemtoReg_i;
    RegWr_reg <= RegWr_i;
    EX_MUX_reg <= EX_MUX_i;
	end
end
   
endmodule