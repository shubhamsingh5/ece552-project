
module PC_control(
input branchEn,
input Br,
input [2:0] C,
input [8:0] I,
input [2:0] F,
input [15:0] PC_in,
output [15:0] PC_out
);

wire [15:0] PC_BrN;
wire [15:0] PC_BrT;
wire [15:0] extI;
wire overflow1, overflow2, branchtaken;

assign extI = {{7'b0000000},{I}};

//branch not taken, compute PC+2
adder_16bit addPC1 (.A(PC_in), .B(16'h0002), .Cin(1'b0), .Sum(PC_BrN), .overflow(overflow1));
//branch taken, compute PC+I
adder_16bit addPC2 (.A(PC_in), .B(extI), .Cin(1'b0), .Sum(PC_BrT), .overflow(overflow2));

assign banchtaken = ((C == 3'b000) & (F[0] == 1'b0)) ? 1'b1:
			((C == 3'b001) & (F[0] == 1'b1)) ? 1'b1:
			((C == 3'b010) & (F[0] == 1'b0) & (F[2] == 1'b0)) ? 1'b1:
			((C == 3'b011) & (F[2] == 1'b1)) ? 1'b1:
			((C == 3'b100) & ((F[0] == 1'b1) | ((F[0] == 1'b0)&(F[2] == 1'b0)))) ? 1'b1:
			((C == 3'b101) & ((F[0] == 1'b1) | (F[2] == 1'b1))) ? 1'b1:
			((C == 3'b110) & (F[1] == 1'b1)) ? 1'b1:
			1'b0;

assign PC_out = ((branch == 1'b1) & (branchtaken == 1'b1) ? ((Br == 1'b1) ? I : PC_BrT) : (PC_BrN);

endmodule
