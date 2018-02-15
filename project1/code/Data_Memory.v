module Data_Memory
(
    clk_i,
    addr_i, 
    WriteData_i,
    MemRead_i,
    MemWrite_i, 
    ReadData_o,
);

// Interface
input               clk_i;
input      [31:0]   addr_i; 
input      [31:0]   WriteData_i;
input               MemRead_i;
input               MemWrite_i; 
output reg [31:0]   ReadData_o;

// Data memory
reg     [31:0]      memory  [0:31];

always @(posedge clk_i) begin
	if(MemWrite_i == 1)
		memory[addr_i] <= WriteData_i;
	if(MemRead_i == 1)
		ReadData_o <= memory[addr_i];
end  

endmodule
