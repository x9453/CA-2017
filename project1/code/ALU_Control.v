module ALU_Control
(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input      [5:0]   funct_i;
input      [1:0]   ALUOp_i;
output reg [2:0]   ALUCtrl_o;

always @(*) begin
	case(ALUOp_i)
		2'b00: ALUCtrl_o = 3'b010;   // add
		2'b01: ALUCtrl_o = 3'b110;   // sub
		2'b10: begin                 // R-type
			if(funct_i[5] == 0)               // mul
				ALUCtrl_o = 3'b100;
			else if(funct_i[2:0] == 3'b000)   // add
				ALUCtrl_o = 3'b010;
			else if(funct_i[2:0] == 3'b010)   // sub
				ALUCtrl_o = 3'b110;
			else if(funct_i[2:0] == 3'b100)   // and
				ALUCtrl_o = 3'b000;
			else if(funct_i[2:0] == 3'b101)   // or
				ALUCtrl_o = 3'b001;
		end
	endcase
end	

endmodule