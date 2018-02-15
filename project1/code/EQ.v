module EQ (
    RSaddr_i,
    RTaddr_i,
    EQ_o
);

input   [31:0]  RSaddr_i;
input   [31:0]  RTaddr_i;
output          EQ_o;

assign  EQ_o = (RSaddr_i == RTaddr_i) ? 1 : 0;

endmodule
