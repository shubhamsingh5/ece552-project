module paddSb_4bit (Sum, A, B);

input [3:0] A, B; //Input values
output [3:0] Sum; //sum output
wire Ovfl; //To indicate overflow
wire povfl,novfl;
wire [3:0] Sumi;
wire [3:0] Binput;
wire [3:0] C;
assign C[0] = 1'b0;
full_adder_1bit FA0 (.c_out(C[1]),.s(Sumi[0]),.a(A[0]), .b(B[0]),.c_in(C[0])); //Example of using the one bit full adder(which you must also design)
full_adder_1bit FA1 (.c_out(C[2]),.s(Sumi[1]),.a(A[1]), .b(B[1]),.c_in(C[1]));
full_adder_1bit FA2 (.c_out(C[3]),.s(Sumi[2]),.a(A[2]), .b(B[2]),.c_in(C[2]));
full_adder_1bit FA3 (.c_out(),.s(Sumi[3]),.a(A[3]), .b(B[3]),.c_in(C[3]));
assign povfl = (~A[3]) & (~B[3]) & (Sumi[3]); //A and B positive, Sum negative
assign novfl = (A[3] & B[3] & (~Sumi[3]));	//A and B negative, sum positive
assign Ovfl = povfl|novfl; 
assign Sum = povfl ? 4'b0111 : 
			 novfl ? 4'b1000 : Sumi;
endmodule
