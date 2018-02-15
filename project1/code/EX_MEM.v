module EX_MEM
(
    clk_i,
    ALUout_i,
    ID_EX_B_i,
    EX_MUX_i,
    MemRd_i,
    MemWr_i,
    MemtoReg_i,
    RegWr_i,
    ALUout_o,
    ID_EX_B_o,
    EX_MUX_o,
    MemRd_o,
    MemWr_o,
    MemtoReg_o,
    RegWr_o
);

// Ports
input               clk_i;

input   [31:0]      ALUout_i;
input   [31:0]      ID_EX_B_i;
input   [4:0]       EX_MUX_i;
input               MemRd_i;
input               MemWr_i;
input               MemtoReg_i;
input               RegWr_i;

output  [31:0]      ALUout_o;
output  [31:0]      ID_EX_B_o;
output  [4:0]       EX_MUX_o;
output              MemRd_o;
output              MemWr_o;
output              MemtoReg_o;
output              RegWr_o;

// Register File
reg     [31:0]      ALUout_reg;
reg     [31:0]      ID_EX_B_reg;
reg     [31:0]      EX_MUX_reg;
reg                 MemRd_reg;
reg                 MemWr_reg;
reg                 MemtoReg_reg;
reg                 RegWr_reg;

// Read Data      
assign  ALUout_o = ALUout_reg;
assign  ID_EX_B_o = ID_EX_B_reg;
assign  EX_MUX_o = EX_MUX_reg;
assign  MemRd_o = MemRd_reg;
assign  MemWr_o = MemWr_reg;
assign  MemtoReg_o = MemtoReg_reg;
assign  RegWr_o = RegWr_reg;

// Write Data   
always @(negedge clk_i) begin
    ALUout_reg <= ALUout_i;
    ID_EX_B_reg <= ID_EX_B_i;
    EX_MUX_reg <= EX_MUX_i;
    MemRd_reg <= MemRd_i;
    MemWr_reg <= MemWr_i;
    MemtoReg_reg <= MemtoReg_i;
    RegWr_reg <= RegWr_i;
end
   
endmodule