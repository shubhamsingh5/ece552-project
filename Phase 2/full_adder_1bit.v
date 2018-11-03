module full_adder_1bit(cout, sum, a, b, cin) ;

input a, b, cin;

output sum, cout;
wire w1, w2, w3;

assign w1 = a^b;
assign w2 = w1 & cin;
assign w3 = a & b;
assign sum = w1 ^ cin;
assign cout = w2 | w3;

endmodule