// PC register module
module pc_reg(clk, rst, D, WriteEnable, q);

input clk, rst, WriteEnable;
input [15:0] D;
inout [15:0] q;

dff ff0(.q(D[0]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff1(.q(D[1]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff2(.q(D[2]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff3(.q(D[3]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff4(.q(D[4]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff5(.q(D[5]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff6(.q(D[6]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff7(.q(D[7]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff8(.q(D[8]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff9(.q(D[9]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff10(.q(D[10]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff11(.q(D[11]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff12(.q(D[12]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff13(.q(D[13]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff14(.q(D[14]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff15(.q(D[15]), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));


endmodule // Regster
