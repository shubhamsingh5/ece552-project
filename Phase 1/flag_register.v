module flag_register(clk, rst, flag_in, flag_out, en);

input clk, rst;
input [2:0] en;
inout [2:0] flag_in;
inout [2:0] flag_out;

dff ff0(.q(flag_out[0]), .d(flag_in[0]), .wen(en[0]), .clk(clk), .rst(rst));
dff ff1(.q(flag_out[1]), .d(flag_in[1]), .wen(en[1]), .clk(clk), .rst(rst));
dff ff2(.q(flag_out[2]), .d(flag_in[2]), .wen(en[2]), .clk(clk), .rst(rst));

endmodule