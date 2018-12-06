module Dcache(clk, rst, data_in, data_we, data_blockEn, wordEn, data_out, tag_in, tag_we, tag_blockEn, tag_out);
input clk, rst;    
input [15:0] data_in; // data to be stored in data array
input [127:0] data_blockEn; // block number in dataArray
input [7:0] wordEn;	//word in the data array
output [15:0] data_out; //data returned by memory (afterdelay 
input data_we, tag_we; // write enables for data and tag array
input [7:0] tag_in;	//tag to be stored in tag array
input [127:0] tag_blockEn;	//block number in tagArray
output [7:0] tag_out;	// tag stored at the given location in cache

DataArray instr(.clk(clk), .rst(rst), .DataIn(data_in), .Write(data_we), .BlockEnable(data_blockEn), .WordEnable(wordEn), .DataOut(data_out));
MetaDataArray tagArray(.clk(clk), .rst(rst), .MetaDataIn(tag_in),.Write(tag_we), .BlockEnable(tag_blockEn), .DataOut(tag_out));
endmodule
