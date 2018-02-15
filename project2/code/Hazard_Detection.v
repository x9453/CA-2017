module Hazard_Detection
(
//	clk_i,
	ID_EX_MemRd,
	EX_RT,
	ID_RT,
	ID_RS,
	IF_ID_Wr,
	PC_Wr,
	ID_MUX_EX,
	is_stall
);
//input 	   clk_i;
input [4:0]ID_RS;
input [4:0]ID_RT;
input [4:0]EX_RT;
input ID_EX_MemRd;
output reg IF_ID_Wr;
output reg PC_Wr;
output reg ID_MUX_EX;
output reg is_stall;
initial begin
    IF_ID_Wr = 1'b0;
	PC_Wr = 1'b1;
	ID_MUX_EX = 1'b0;
	is_stall = 1'b0;
end
always@(*)begin
	is_stall = 1'b0;
	IF_ID_Wr = 1'b1;
	PC_Wr = 1'b1;
	ID_MUX_EX = 1'b0;
	if(ID_EX_MemRd)begin
	 IF_ID_Wr =	 (ID_RS==EX_RT)?1'b0:
						 (ID_RT==EX_RT)?1'b0:1'b1;
	 PC_Wr	=	 (ID_RS==EX_RT)?1'b0:
						 (ID_RT==EX_RT)?1'b0:1'b1;
	 ID_MUX_EX =	 (ID_RS==EX_RT)?1'b1:
						 (ID_RT==EX_RT)?1'b1:1'b0;
	end
	if(IF_ID_Wr == 1'b0)begin
		is_stall = 1'b1;
	end
end
endmodule