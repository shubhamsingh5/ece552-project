//Tag Array of 128  blocks
//Each block will have 1 byte
//BlockEnable is one-hot
//WriteEnable is one on writes and zero on reads

//module MetaDataArray(input clk, input rst, input [7:0] DataIn, input Write0, input Write1, input [63:0] BlockEnable0, input [63:0] BlockEnable1, output [7:0] DataOut0, output [7:0] DataOut1);
module MetaDataArray(input clk, input rst, input [7:0] DataIn, input Write0, input Write1, input [63:0] BlockEnable, output [7:0] DataOut0, output [7:0] DataOut1);
	//MBlock Mblk0[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write0), .Enable(BlockEnable0), .Dout(DataOut0));
	//MBlock Mblk1[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write1), .Enable(BlockEnable1), .Dout(DataOut1));
	wire [5:0] Tag_in0, Tag_in1;
	wire lru, valid;
	//valid, LRU, tag_bits
	assign lru = (DataIn[7] | DataIn[6]) & (Write0 | Write1);
	assign valid = (Write0 | Write1);
	assign Tag_in0 = DataIn[5:0];
	assign Tag_in1 = DataIn[5:0];
	//assign Tag_in0 = (DataIn[7] | DataIn[6]) ? {evict/valid, Write0, DataIn[5:0]} : {};
	//assign Tag_in1 = (DataIn[7] | DataIn[6]) ? {evict/valid, Write1, DataIn[5:0]} : {};
	//MBlock Mblk0[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write0), .lru(lru), .valid(valid), .Enable(BlockEnable), .Dout(DataOut0));
	MBlock Mblk0[63:0]( .clk(clk), .rst(rst), .Din(Tag_in0), .WriteEnable(Write0), .lru(lru), .valid(valid), .Enable(BlockEnable), .Dout(DataOut0));
	
	MBlock Mblk1[63:0]( .clk(clk), .rst(rst), .Din(Tag_in1), .WriteEnable(Write1), .lru(lru), .valid(valid), .Enable(BlockEnable), .Dout(DataOut1));
endmodule

module MBlock( input clk,  input rst, input [5:0] Din, input WriteEnable, input lru, input valid, input Enable, output [7:0] Dout);
	//lru high means read or write happens and need to change lru of 2 blocks, writeEnable same as lru bit in thiscase
	MCell LRU( .clk(clk), .rst(rst), .Din(~WriteEnable), .WriteEnable(lru), .Enable(Enable), .Dout(Dout[7]));
	MCell valid1( .clk(clk), .rst(rst), .Din(1'b1), .WriteEnable(valid & WriteEnable), .Enable(Enable), .Dout(Dout[6]));
	MCell mc[5:0]( .clk(clk), .rst(rst), .Din(Din[5:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[5:0]));
endmodule

module MCell( input clk,  input rst, input Din, input WriteEnable, input Enable, output Dout);
	wire q;
	assign Dout = (Enable & ~WriteEnable) ? q:'bz;
	dff dffm(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));
endmodule

