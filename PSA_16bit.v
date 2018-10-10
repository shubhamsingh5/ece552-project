module PSA_16bit(Sum, Error, A, B);

input[15:0] A, B;  //input data values
output[15:0] Sum;  //Sum output
output Error;      //To indicate overflows

wire [3:0] a, b, c, d;
wire of1, of2, of3, of4, sub;

assign sub = 0;

addsub_4bit add1(.Sum(a), .Ovfl(of1), .A(A[15:12]), .B(B[15:12]), .sub(sub));
addsub_4bit add2(.Sum(b), .Ovfl(of2), .A(A[11:8]), .B(B[11:8]), .sub(sub));
addsub_4bit add3(.Sum(c), .Ovfl(of3), .A(A[7:4]), .B(B[7:4]), .sub(sub));
addsub_4bit add4(.Sum(d), .Ovfl(of4), .A(A[3:0]), .B(B[3:0]), .sub(sub));

assign Sum = {a, b, c, d};
assign Error = of1 | of2 | of3 | of4;

endmodule