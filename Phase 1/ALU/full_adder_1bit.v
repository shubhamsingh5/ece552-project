module full_adder_1bit(c_out, s, a, b, c_in) ;

input a, b, c_in;

output s, c_out;
wire w1, w2, w3;

assign w1 = a^b;
assign w2 = w1 & c_in;
assign w3 = a & b;
assign s = w1 ^ c_in;
assign c_out = w2 | w3;

endmodule