module CLA_4bit(A, B, Cin, Sum, P, G);
input [3:0] A;
input [3:0] B;
input Cin;
output [3:0] Sum;
//output Cout;
output P;
output G;
wire [3:0] p;
wire [3:0] g;
wire Ovfl;
addsub_4bit sum (.Sum(Sum), .Ovfl(Ovfl), .A(A), .B(B), .cin(Cin));
assign p =  A|B;
assign g = A & B;
assign P = &p;
assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) & (p[3] | p[2] & p[1] & g[0]);
//assign Cout = G + (P*Cin);
endmodule
