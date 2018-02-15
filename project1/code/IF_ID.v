module IF_ID
(
	clk_i,
	IR_i,
	PC_i,
	IR_o,
	PC_o,
	IF_ID_Wr,
	is_flush
);

input	clk_i;
input	[31:0]	IR_i;
input	[31:0]	PC_i;
input 			IF_ID_Wr;
input 			is_flush;
output	[31:0]	IR_o;
output	[31:0]	PC_o;
reg [31:0]	IR_reg;
reg [31:0]	PC_reg;

assign IR_o = IR_reg;
assign PC_o = PC_reg;

always@(negedge clk_i)begin
	if(IF_ID_Wr)begin
		IR_reg <= IR_i;
		PC_reg <= PC_i;
	end
	else begin
		IR_reg <= IR_o;
		PC_reg <= PC_o;
	end
	if(is_flush)begin
		IR_reg <= 32'b0;
		PC_reg <= 32'b0;
	end
end

endmodule	
