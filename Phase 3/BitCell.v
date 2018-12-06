module BitCell(clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2, Bitline1, Bitline2);

input clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2;
inout Bitline1, Bitline2;

wire ff_out;

dff flipflop(.q(ff_out), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

assign Bitline1 = ReadEnable1 ? ff_out : 1'bz;
assign Bitline2 = ReadEnable2 ? ff_out : 1'bz;

endmodule
