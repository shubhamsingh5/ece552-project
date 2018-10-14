module addsub_4bit (Sum, Ovfl, A, B, sub);

input [3:0] A, B; //Input values
input sub; // add-sub indicator
output [3:0] Sum; //sum output
output Ovfl; //To indicate overflow
wire [3:0] Binput;
wire [3:0] C;
assign Binput = sub ? (~B): B;
assign C[0] = sub ? 1'b1 : 1'b0;
full_adder_1bit FA0 (.Cout(C[1]),.S(Sum[0]),.A(A[0]), .B(Binput[0]),.Cin(C[0])); //Example of using the one bit full adder(which you must also design)
full_adder_1bit FA1 (.Cout(C[2]),.S(Sum[1]),.A(A[1]), .B(Binput[1]),.Cin(C[1]));
full_adder_1bit FA2 (.Cout(C[3]),.S(Sum[2]),.A(A[2]), .B(Binput[2]),.Cin(C[2]));
full_adder_1bit FA3 (.Cout(),.S(Sum[3]),.A(A[3]), .B(Binput[3]),.Cin(C[3]));
assign Ovfl = (A[3] & Binput[3] & (~Sum[3]))|((~A[3]) & (~Binput[3]) & (Sum[3]));

endmodule
