module addsub_4bit (Sum, Ovfl, A, B, sub);

input[3:0] A, B; //Input values
input sub; // add-sub indicator
output[3:0] Sum; //sum output
output Ovfl; //To indicate overflow

wire mux1, mux2, mux3, mux4;
wire cout0, cout1, cout2, cout;

assign mux1 = sub ? ~B[0] : B[0];
assign mux2 = sub ? ~B[1] : B[1];
assign mux3 = sub ? ~B[2] : B[2];
assign mux4 = sub ? ~B[3] : B[3];

full_adder_1bit FA1(cout0, Sum[0], A[0], mux1, sub);
full_adder_1bit FA2(cout1, Sum[1], A[1], mux2, cout0);
full_adder_1bit FA3(cout2, Sum[2], A[2], mux3, cout1);
full_adder_1bit FA4(cout, Sum[3], A[3], mux4, cout2);

assign Ovfl = cout2 ^ cout;

endmodule