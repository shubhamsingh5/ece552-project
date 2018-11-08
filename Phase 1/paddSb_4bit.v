module paddSb_4bit (Sum, A, B);

input [3:0] A, B; //Input values
output [3:0] Sum; //sum output
wire Ovfl; //To indicate overflow
wire povfl,novfl;
wire [3:0] Sumi;
wire [3:0] Binput;
wire [3:0] C;
assign C[0] = 1'b0;
full_adder_1bit FA0 (.cout(C[1]),.sum(Sumi[0]),.a(A[0]), .b(B[0]),.cin(C[0])); //Example of using the one bit full adder(which you must also design)
full_adder_1bit FA1 (.cout(C[2]),.sum(Sumi[1]),.a(A[1]), .b(B[1]),.cin(C[1]));
full_adder_1bit FA2 (.cout(C[3]),.sum(Sumi[2]),.a(A[2]), .b(B[2]),.cin(C[2]));
full_adder_1bit FA3 (.cout(),.sum(Sumi[3]),.a(A[3]), .b(B[3]),.cin(C[3]));
assign povfl = (~A[3]) & (~B[3]) & (Sumi[3]); //A and B positive, Sum negative
assign novfl = (A[3] & B[3] & (~Sumi[3]));	//A and B negative, sum positive
assign Ovfl = povfl|novfl; 
assign Sum = povfl ? 4'b0111 : 
			 novfl ? 4'b1000 : Sumi;
endmodule
