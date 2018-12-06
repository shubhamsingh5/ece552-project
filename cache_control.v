module cache_control(clk, rst_n, cache_addr, memory_data, cache_data, memory_addr, stall, Wen_cache, Ren_cache, data_valid_memory);
//read cache data, write cache data, write through and write to memory
input clk, rst_n;
input [15:0] cache_addr;
input [15:0] memory_data;
input Wen_cache, Ren_cache;
output [15:0] cache_data;
output [15:0] memory_addr;
output stall;
input data_valid_memory;

wire [7:0] MetaData1, MetaData2;
wire [6:0] addr_in;
wire [127:0] BlockEnable;
wire [127:0] block_number;
wire miss_detected;
wire memory_address;
wire data_valid;
wire FSM_tag_Wen;
wire [7:0] WordEnable;

wire [15:0] memory_data_out;

assign addr_in = {{cache_addr[9:4]},{1'b0}};
assign BlockEnable2 = BlockEnable1 << 1;
cb7to128 inst1(.addr_in(addr_in), .blockEnable(BlockEnable1));

//read data or write data, need to change MetaDataArray
MetaDataArray set_block1(.clk(clk), .rst(~rst_n), .DataIn(), .Write(Wen_cache | FSM_tag_Wen), .BlockEnable(BlockEnable1), .DataOut1(MetaData1));
MetaDataArray set_block2(.clk(clk), .rst(~rst_n), .DataIn(), .Write(Wen_cache | FSM_tag_Wen), .BlockEnable(BlockEnable2), .DataOut(MetaData2));//we should change MetaDataArray Module according to TA

Offset3to8 offset3to8(.offset(cache_addr[3:1]), .WordEnable(WordEnable));
DataArray dataArray(.clk(clk), .rst(~rst_n), .DataIn(memory_data_out), .Write(Wen_cache | FSM_cache_Wen), .BlockEnable(block_number), .WordEnable(WordEnable), .DataOut(cache_data));
//Wen_cache when cpu write data to cache, FSM_cache_Wen when FSM asks memory wirte data to cache

assign block_number = (cache_addr[15:10] == MetaData1[7:1]) ? BlockEnable1 : (cache_addr[15:10] == MetaData2[7:1]) ? BlockEnable2 : 128'b0;
assign miss_detected = (block_number == 128'b0)? 1'b1 : 1'b0;
assign memory_address = {{cache_addr[15:4]},{4'b0000}};
cache_fill_FSM FSM(.clk(clk), .rst_n(rst_n), .miss_detected(miss_detected), .miss_address(cache_addr), .fsm_busy(stall), .write_data_array(FSM_cache_Wen), .write_tag_array(FSM_tag_Wen), .memory_address(memory_address), .memory_data_valid(data_valid_memory));



memory4c memory(.data_out(memory_data_out), .data_in(cache_data), .addr(cache_addr), .enable, .wr, .clk, .rst, .data_valid(data_valid_memory));
//this memory should be set outside the cache control 

endmodule


module cb7to128(input [6:0] addr_in, output [127:0] blockEnable);

wire [127:0] s0, s1, s2, s3, s4, s5, s6;
assign s0 = 128'b1;
assign s1 = addr_in[0] ? (s0 << 1) : s0;
assign s2 = addr_in[1] ? (s1 << 2) : s1;
assign s3 = addr_in[2] ? (s2 << 4) : s2;
assign s4 = addr_in[3] ? (s3 << 8) : s3;
assign s5 = addr_in[4] ? (s4 << 16) : s4;
assign s6 = addr_in[5] ? (s5 << 32) : s5;
assign blockEnable = addr_in[6] ? (s6 << 64) : s6;

endmodule

module Offset3to8(input [2:0] offset, output [7:0] WordEnable);
wire [7:0] s0, s1, s2;
assign s0 = 8'b1;
assign s1 = (offset[0]) ? (s0 << 1) : s0;
assign s2 = (offset[1]) ? (s1 << 2) : s1;
assign WordEnable = (offset[2]) ? (s2 << 4) : s2;
endmodule
