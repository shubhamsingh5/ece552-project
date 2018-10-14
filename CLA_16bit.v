module CLA_16bit(A, B, Sum, Cout, ovfl, sub);
input [15:0] A;
input [15:0] B;
wire [15:0] Binput;
//input Cin;
input sub;
output [15:0] Sum;
wire [15:0] Sumi;
wire povfl, novfl;
output Cout;
wire [3:0] Ci;
wire [3:0] P;
wire [3:0] G;
output ovfl;
assign Binput = sub ? (~B) : B;
assign Ci[0] = sub ? (1'b1) : (1'b0);

CLA_4bit CLA0(.A(A[3:0]), .B(Binput[3:0]), .Cin(Ci[0]), .Sum(Sumi[3:0]), .P(P[0]), .G(G[0]));
CLA_4bit CLA1(.A(A[7:4]), .B(Binput[7:4]), .Cin(Ci[1]), .Sum(Sumi[7:4]), .P(P[1]), .G(G[1]));
CLA_4bit CLA2(.A(A[11:8]), .B(Binput[11:8]), .Cin(Ci[2]), .Sum(Sumi[11:8]), .P(P[2]), .G(G[2]));
CLA_4bit CLA3(.A(A[15:12]), .B(Binput[15:12]), .Cin(Ci[3]), .Sum(Sumi[15:12]), .P(P[3]), .G(G[3]));
assign Ci = {G[2] + P[2]*Ci[2],G[1] + P[1]*Ci[1], (G[0] + P[0]*Ci[0]), Ci[0]};
assign Cout = G[3] + P[3]*Ci[3];
//assign povfl = sub ? (Sum[15] * (~A[15]) * B[15]) : (Sum[15]* (~A[15]) * (~B[15]));
//assign novfl = sub ? ((A[15]) * (~B[15]) * (~Sum[15])) : ((~Sum[15]) * (A[15]) * (B[15]));
assign novfl = (A[15] * Binput[15] *(~Sumi[15]));
assign povfl = (~A[15] * (~Binput[15]) * (Sumi[15]));
assign ovfl = povfl | novfl;
assign Sum = povfl ? 16'h7FFF : 
			 (novfl ? 16'h8000 : Sumi);
endmodule 
