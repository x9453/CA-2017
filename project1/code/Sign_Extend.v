module Sign_Extend
(
    data_i,
    data_o
);

input      [15:0]   data_i;
output reg [31:0]   data_o;

always @(*) begin
	if(data_i[15] == 0)
		data_o = {16'h0000, data_i};
	else
		data_o = {16'hffff, data_i};
end

endmodule