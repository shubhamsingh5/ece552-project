module Icache(clk, rst, data_we, tag_we, Write0, Write1, wordEn, tag_in, data_in, blockEnable, tag_out0, tag_out1, data_out0, data_out1);
input clk, rst;    
input data_we, tag_we; // write enables for data and tag array
input Write0, Write1; //way selects
input [7:0] wordEn;	//word in the data array
input [7:0] tag_in;	//tag to be stored in tag array
input [15:0] data_in; // data to be stored in data array
input [63:0] blockEnable; // block number in dataArray

output [7:0] tag_out0, tag_out1;	// tag stored at the given location in cache
output [15:0] data_out0, data_out1; //data returned by memory (afterdelay 

DataArray dataArray(.clk(clk), .rst(rst), .DataIn(data_in), .Write0(Write0 & data_we), .Write1(Write1 & data_we), .BlockEnable(blockEnable), .WordEnable(wordEn), .DataOut0(data_out0), .DataOut1(data_out1));
MetaDataArray set_block1(.clk(clk), .rst(rst), .DataIn(tag_in), .Write0(Write0 & tag_we), .Write1(Write1 & tag_we), .BlockEnable(blockEnable), .DataOut0(tag_out0), .DataOut1(tag_out1));

endmodule
