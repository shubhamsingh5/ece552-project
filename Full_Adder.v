module full_adder_1bit (Cout,S,a,b,Cin);
input a,b;
input Cin;
output S;
output Cout;

assign S = a^ b^ Cin;
assign Cout = (a&b) | (b&Cin) | (a&Cin);

endmodule

