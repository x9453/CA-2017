module Forward_Ctrl
(
    ID_EX_RS_i,
    ID_EX_RT_i,
    EX_MEM_RD_i,
    EX_MEM_RegWr_i,
    MEM_WB_RD_i,
    MEM_WB_RegWr_i,
    Forward_A_o,
    Forward_B_o
);

input      [4:0]   ID_EX_RS_i;
input      [4:0]   ID_EX_RT_i;
input      [4:0]   EX_MEM_RD_i;
input              EX_MEM_RegWr_i;
input      [4:0]   MEM_WB_RD_i;
input              MEM_WB_RegWr_i;  
output reg [1:0]   Forward_A_o;
output reg [1:0]   Forward_B_o;

always@(*) begin
	Forward_A_o = 2'b00;
	Forward_B_o = 2'b00;

	if(EX_MEM_RegWr_i == 1'b1 && EX_MEM_RD_i != 5'b0) begin
		if(EX_MEM_RD_i == ID_EX_RS_i)
			Forward_A_o = 2'b10;
		if(EX_MEM_RD_i == ID_EX_RT_i)
			Forward_B_o = 2'b10;
	end

	if(MEM_WB_RegWr_i == 1'b1 && MEM_WB_RD_i != 5'b0) begin
		if(EX_MEM_RD_i != ID_EX_RS_i && MEM_WB_RD_i == ID_EX_RS_i)
			Forward_A_o = 2'b01;
		if(EX_MEM_RD_i != ID_EX_RT_i && MEM_WB_RD_i == ID_EX_RT_i)
			Forward_B_o = 2'b01;
	end
end

endmodule