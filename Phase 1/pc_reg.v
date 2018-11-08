// PC register module
module pc_reg(clk, rst, D, WriteEnable, q);

input clk, rst, WriteEnable;
input [15:0] D;
inout [15:0] q;

dff ff0(.q(q[0]), .d(D[0]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff1(.q(q[1]), .d(D[1]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff2(.q(q[2]), .d(D[2]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff3(.q(q[3]), .d(D[3]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff4(.q(q[4]), .d(D[4]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff5(.q(q[5]), .d(D[5]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff6(.q(q[6]), .d(D[6]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff7(.q(q[7]), .d(D[7]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff8(.q(q[8]), .d(D[8]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff9(.q(q[9]), .d(D[9]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff10(.q(q[10]), .d(D[10]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff11(.q(q[11]), .d(D[11]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff12(.q(q[12]), .d(D[12]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff13(.q(q[13]), .d(D[13]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff14(.q(q[14]), .d(D[14]), .wen(WriteEnable), .clk(clk), .rst(rst));
dff ff15(.q(q[15]), .d(D[15]), .wen(WriteEnable), .clk(clk), .rst(rst));


endmodule // Regster
