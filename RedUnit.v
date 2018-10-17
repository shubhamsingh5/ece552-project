module RedUnit(A, B, RedResult);
input [15:0] A;
input [15:0] B;
output [15:0] RedResult;//Let A = aaaaaaaa_bbbbbbbbb, B = cccccccc_dddddddd
wire [7:0] Resultbd;
wire [7:0] Resultac;
wire [2:0] Coutbd, Coutac,Pbd,Pac,Gac,Gbd;
wire [2:0] Lev2Ci;
wire [2:0] Lev2P;
wire [2:0] Lev2G;
CLA_4bit Levelbd0(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .Sum(Resultbd[3:0]), .P(Pbd[0]), .G(Gbd[0]));

assign Coutbd[0] = Gbd[0]; //Cinbd = 0, no propagation
CLA_4bit Levelbd1(.A(A[7:4]), .B(B[7:4]), .Cin(Coutbd[0]), .Sum(Resultbd[7:4]), .P(Pbd[1]), .G(Gbd[1]));
assign Coutbd[1] = Gbd[1] + (Pbd[1]*Coutbd[0]);

CLA_4bit Levelac0(.A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .Sum(Resultac[3:0]), .P(Pac[0]), .G(Gac[0]));
assign Coutac[0] = Gac[0];

CLA_4bit Levelac1(.A(A[15:12]), .B(B[15:12]), .Cin(Coutac[0]), .Sum(Resultac[7:4]), .P(Pac[1]), .G(Gac[1]));
assign Coutac[1] = Gac[1] + (Pac[1]*Coutac[0]);

assign Lev2Ci = {Lev2G[1] + Lev2P[1]*Lev2Ci[1], (Lev2G[0] + Lev2P[0]*Lev2Ci[0]), 1'b0};

CLA_4bit Lev2CLA0(.A(Resultbd[3:0]), .B(Resultac[3:0]), .Cin(Lev2Ci[0]), .Sum(RedResult[3:0]), .P(Lev2P[0]), .G(Lev2G[0]));
CLA_4bit Lev2CLA1(.A(Resultbd[7:4]), .B(Resultac[7:4]), .Cin(Lev2Ci[1]), .Sum(RedResult[7:4]), .P(Lev2P[1]), .G(Lev2G[1]));
//CLA_4bit Lev2CLA2(.A(4{Coutbd}), .B(4{Coutac}), .Cin(Lev2Ci[2]), .Sum(Sumi[11:8]), .P(Lev2P[2]), .G(Lev2G[2]));//do inputs need to be sign extended?

endmodule
