module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
);

input      [31:0]   data1_i;
input      [31:0]   data2_i;
input      [2:0]    ALUCtrl_i;
output reg [31:0]   data_o;

reg        [31:0]   sub;

always @(*) begin
	case(ALUCtrl_i)
		3'b010: data_o = data1_i + data2_i;   // add
		3'b110: data_o = data1_i - data2_i;   // sub
		3'b000: data_o = data1_i & data2_i;   // and
		3'b001: data_o = data1_i | data2_i;   // or
		3'b100: data_o = data1_i * data2_i;   // mul
	endcase
end

endmodule
