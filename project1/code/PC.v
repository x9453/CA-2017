module PC
(
    clk_i,
    rst_i,
    start_i,
    pc_i,
    pc_o,
	PC_Wr
//	IF_ID_Wr_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input   [31:0]      pc_i;
input				PC_Wr;
output  [31:0]      pc_o;
//output reg 			IF_ID_Wr_o;

// Wires & Registers
reg     [31:0]      pc_o;

initial begin
    pc_o = 32'b0;
end

always@(negedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_o <= 32'b0;
    end
    else begin 
			if(start_i && PC_Wr)
				pc_o <= pc_i;
			else
				pc_o <= pc_o;
			
    end
end

endmodule
