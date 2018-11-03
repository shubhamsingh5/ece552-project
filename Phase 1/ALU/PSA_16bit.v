module PADDSB_16bit (Sum, A, B);
input [15:0] A, B; // Input data values
output [15:0] Sum; // Sum output
/*paddSb_4bit ADD1(.Sum(Sum[3:0]),.Ovfl(Ovfl[0]), .A(A[3:0]), .B(B[3:0])); 
paddSb_4bit ADD2(.Sum(Sum[7:4]),.Ovfl(Ovfl[1]), .A(A[7:4]), .B(B[7:4])); 
paddSb_4bit ADD3(.Sum(Sum[11:8]),.Ovfl(Ovfl[2]), .A(A[11:8]), .B(B[11:8])); 
paddSb_4bit ADD4(.Sum(Sum[15:12]),.Ovfl(Ovfl[3]), .A(A[15:12]), .B(B[15:12]));*/

paddSb_4bit ADD1(.Sum(Sum[3:0]), .A(A[3:0]), .B(B[3:0])); 
paddSb_4bit ADD2(.Sum(Sum[7:4]), .A(A[7:4]), .B(B[7:4])); 
paddSb_4bit ADD3(.Sum(Sum[11:8]), .A(A[11:8]), .B(B[11:8])); 
paddSb_4bit ADD4(.Sum(Sum[15:12]), .A(A[15:12]), .B(B[15:12])); 

endmodule
