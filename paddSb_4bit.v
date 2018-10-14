module paddSb_4bit (Sum, A, B);

input [3:0] A, B; //Input values
output [3:0] Sum; //sum output
wire Ovfl; //To indicate overflow
wire povfl,novfl;
wire [3:0] Sumi;
wire [3:0] Binput;
wire [3:0] C;
assign C[0] = 1'b0;
full_adder_1bit FA0 (.Cout(C[1]),.S(Sumi[0]),.A(A[0]), .B(B[0]),.Cin(C[0])); //Example of using the one bit full adder(which you must also design)
full_adder_1bit FA1 (.Cout(C[2]),.S(Sumi[1]),.A(A[1]), .B(B[1]),.Cin(C[1]));
full_adder_1bit FA2 (.Cout(C[3]),.S(Sumi[2]),.A(A[2]), .B(B[2]),.Cin(C[2]));
full_adder_1bit FA3 (.Cout(),.S(Sumi[3]),.A(A[3]), .B(B[3]),.Cin(C[3]));
assign povfl = (~A[3]) & (~B[3]) & (Sumi[3]); //A and B positive, Sum negative
assign novfl = (A[3] & B[3] & (~Sumi[3]));	//A and B negative, sum positive
assign Ovfl = povfl|novfl; 
assign Sum = povfl ? 4'b0111 : 
			 novfl ? 4'b1000 : Sumi;
endmodule
