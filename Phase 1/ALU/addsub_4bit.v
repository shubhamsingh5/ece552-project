module addsub_4bit (Sum, Ovfl, A, B, cin);

input [3:0] A, B; //Input values
input cin; // add-sub indicator
output [3:0] Sum; //sum output
output Ovfl; //To indicate overflow

wire [3:0] C;

full_adder_1bit FA0 (.c_out(C[1]),.s(Sum[0]),.a(A[0]), .b(B[0]), .c_in(cin)); //Example of using the one bit full adder(which you must also design)
full_adder_1bit FA1 (.c_out(C[2]),.s(Sum[1]),.a(A[1]), .b(B[1]), .c_in(C[1]));
full_adder_1bit FA2 (.c_out(C[3]),.s(Sum[2]),.a(A[2]), .b(B[2]), .c_in(C[2]));
full_adder_1bit FA3 (.c_out(),.s(Sum[3]),.a(A[3]), .b(B[3]), .c_in(C[3]));
assign Ovfl = (A[3] & B[3] & (~Sum[3]))|((~A[3]) & (~B[3]) & (Sum[3]));

endmodule
