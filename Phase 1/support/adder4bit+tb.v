module adder_1bit(A, B, Cin, S, Cout);

input A, B, Cin;

output S, Cout;


assign S = A ^ B ^ Cin;

assign Cout = (A & B) | (B & Cin) | (A & Cin);

endmodule

module adder_4bit(AA, BB, SS, CC);

input [3:0]AA, BB;

output [3:0] SS;

output CC;

wire [4:1] C;

assign CC = C[4];

adder_1bit A1 (AA[0],BB[0], 1'b0, SS[0], C[1]);
adder_1bit A2 (AA[1],BB[1], C[1], SS[1], C[2]);
adder_1bit A3 (AA[2],BB[2], C[2], SS[2], C[3]);
adder_1bit A4 (AA[3],BB[3], C[3], SS[3], C[4]);

endmodule

module adder_tb;

reg [7:0] stim;
wire [3:0] Sum;
wire Carry_Out;

adder_4bit DUT (stim[3:0], stim[7:4], Sum, Carry_Out);

initial begin
	stim = 8'b0;
	repeat(100) begin
		#20 stim = $random;
	end
	#10;
end

initial $monitor("Stim:%b Sum:%b CO:%b",stim, Sum, Carry_Out );

endmodule

