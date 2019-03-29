module cache_control(clk, rst, instr_write, instr_read, data_write, data_read, instr_cache_addr, data_cache_addr, data_cache_data_in, instr_cache_data, data_cache_data, if_stall, mem_stall, instr_cache_hit, data_cache_hit);
input clk, rst;
input instr_write, instr_read, data_write, data_read;
input [15:0] instr_cache_addr, data_cache_addr;                 //addresses for icache and dcache
input [15:0] data_cache_data_in;                                //data to store in dcache
output [15:0] instr_cache_data, data_cache_data;                //data output by cache for loads
output if_stall, mem_stall;                                     //pipeline stall signals
output instr_cache_hit, data_cache_hit;

wire cache_enable;
wire instr_miss_detected, data_miss_detected;
//wire data_valid;
wire FSM_tag_Wen;
wire instr_write_0, instr_write_1, data_write_0, data_write_1;
wire instr_write_way_0, instr_write_way_1, data_write_way_0, data_write_way_1;
wire way_0, way_1;
wire [7:0] instr_metadata0, instr_metadata1, data_metadata0, data_metadata1;
wire [7:0] instr_metadata_0_out, instr_metadata_1_out, data_metadata_0_out, data_metadata_1_out;
wire [7:0] instr_cache_wordEn, data_cache_wordEn, word_sel, instr_cache_word_sel, data_cache_word_sel;
wire [63:0] instr_blockEnable, data_blockEn;
wire [15:0] instr_cache_write, data_cache_write;
wire [15:0] instr_cache_data_out0, instr_cache_data_out1, data_cache_data_out0, data_cache_data_out1;
wire [15:0] memory_data_out, memory_address, miss_address;

//6 to 64 decoder for index bits
cb6to64 instr_index(.addr_in(instr_cache_addr[9:4]), .blockEnable(instr_blockEnable));
cb6to64 data_index(.addr_in(data_cache_addr[9:4]), .blockEnable(data_blockEn));

//3 to 8 decoder for word select
offset3to8 instr_offset(.offset(instr_cache_addr[3:1]), .WordEnable(instr_cache_wordEn));
offset3to8 data_offset(.offset(data_cache_addr[3:1]), .WordEnable(data_cache_wordEn));

//instruction cache
cache icache(.clk(clk), .rst(rst), .data_we(FSM_cache_Wen | instr_write), .tag_we(FSM_tag_Wen), .Write0(instr_write_0 | instr_write_way_0), .Write1(instr_write_1 | instr_write_way_1),
                .wordEn(instr_cache_word_sel), .tag_in({instr_read, instr_write,instr_cache_addr[15:10]}), .data_in(instr_cache_write), .blockEnable(instr_blockEnable), .tag_out0(instr_metadata0),
                .tag_out1(instr_metadata1), .data_out0(instr_cache_data_out0), .data_out1(instr_cache_data_out1));

//data cache
cache dcache(.clk(clk), .rst(rst), .data_we(FSM_cache_Wen | data_write), .tag_we(FSM_tag_Wen), .Write0(data_write_0 | data_write_way_0), .Write1(data_write_1 | data_write_way_1),
                .wordEn(data_cache_word_sel), .tag_in({data_read, data_write,data_cache_addr[15:10]}), .data_in(data_cache_write), .blockEnable(data_blockEn), .tag_out0(data_metadata0),
                .tag_out1(data_metadata1), .data_out0(data_cache_data_out0), .data_out1(data_cache_data_out1));

//state machine to handle cache misses
cache_fill_FSM FSM(.clk(clk), .rst(rst), .miss_detected(cache_enable & (instr_miss_detected | data_miss_detected)), .way_0(way_0), .way_1(way_1), .miss_address(miss_address), .fsm_busy(stall), .write_data_array(FSM_cache_Wen),
                .write_tag_array(FSM_tag_Wen), .memory_address(memory_address), .memory_data_valid(data_valid_memory), .word_sel(word_sel));

//Wen_cache when cpu write data to cache, FSM_cache_Wen when FSM asks memory wirte data to cache
//shouldn't the enable be 1 only when the tag?
memory4c memory(.data_out(memory_data_out), .data_in(data_cache_data_in), .addr(memory_address), .enable(instr_miss_detected | data_miss_detected), .wr(data_write & ~stall), .clk(clk), .rst(rst), .data_valid(data_valid_memory));

dff instr_metadata_0[7:0](.q(instr_metadata_0_out), .d(instr_metadata0), .wen(1'b1), .clk(clk), .rst(rst));
dff instr_metadata_1[7:0](.q(instr_metadata_1_out), .d(instr_metadata1), .wen(1'b1), .clk(clk), .rst(rst));
dff data_metadata_0[7:0](.q(data_metadata_0_out), .d(data_metadata0), .wen(1'b1), .clk(clk), .rst(rst));
dff data_metadata_1[7:0](.q(data_metadata_1_out), .d(data_metadata1), .wen(1'b1), .clk(clk), .rst(rst));

assign cache_enable = (instr_write | instr_read | data_write | data_read);

//figure out which way contains valid cache block
assign instr_write_0 = (instr_cache_addr[15:10] == instr_metadata0[5:0] & instr_metadata0[6]) & ~FSM_tag_Wen;
assign instr_write_1 = (instr_cache_addr[15:10] == instr_metadata1[5:0] & instr_metadata1[6]) & ~FSM_tag_Wen;
assign data_write_0 = (data_cache_addr[15:10] == data_metadata0[5:0] & data_metadata0[6]) & ~FSM_tag_Wen;
assign data_write_1 = (data_cache_addr[15:10] == data_metadata1[5:0] & data_metadata1[6]) & ~FSM_tag_Wen;

//figure out if there was a cache miss
assign instr_miss_detected = (~instr_write_0 & ~instr_write_1) & (instr_write | instr_read);
assign instr_cache_hit = ~instr_miss_detected & (instr_write | instr_read);

assign data_miss_detected = (~data_write_0 & ~data_write_1) & (data_write | data_read);
assign data_cache_hit = ~data_miss_detected & (data_write | data_read);

//get miss address in case of cache miss
assign miss_address = instr_miss_detected ? instr_cache_addr : data_cache_addr;

//set data to be stored in cache
assign data_cache_write = data_miss_detected ? memory_data_out : data_cache_data_in;
assign instr_cache_write = memory_data_out;

assign instr_cache_word_sel = (~instr_miss_detected) ? instr_cache_wordEn : word_sel;
assign data_cache_word_sel = (~data_miss_detected) ? instr_cache_wordEn : word_sel;

//select output for cache hits
assign instr_cache_data = (stall) ? 1'b0 : instr_write_1 ? instr_cache_data_out1 : instr_cache_data_out0;
assign data_cache_data = (stall) ? 1'b0 : data_write_1 ? data_cache_data_out1 : data_cache_data_out0;

//set stall signals for instr cache and data cache 
assign if_stall = (instr_read | instr_write) & stall;
assign mem_stall = (data_read | data_write) & stall;


assign instr_write_way_0 = (instr_metadata_0_out[6] == 0) ? 1'b1 : (instr_metadata_0_out[7]);
assign instr_write_way_1 = (instr_metadata_1_out[6] == 0 & ~instr_write_way_0) ? 1'b1 : (instr_metadata_1_out[7]);
assign data_write_way_0 = (data_metadata_0_out[6] == 0) ? 1'b1 : (data_metadata_0_out[7]);
assign data_write_way_1 = (data_metadata_1_out[6] == 0 & ~data_write_way_0) ? 1'b1 : (data_metadata_1_out[7]);

endmodule


module cb6to64(input [5:0] addr_in, output [63:0] blockEnable);

wire [63:0] s0, s1, s2, s3, s4, s5, s6;
assign s0 = 128'b1;
assign s1 = addr_in[0] ? (s0 << 1) : s0;
assign s2 = addr_in[1] ? (s1 << 2) : s1;
assign s3 = addr_in[2] ? (s2 << 4) : s2;
assign s4 = addr_in[3] ? (s3 << 8) : s3;
assign s5 = addr_in[4] ? (s4 << 16) : s4;
assign blockEnable = addr_in[5] ? (s5 << 32) : s5;

endmodule

// module cb7to128(input [6:0] addr_in, output [127:0] blockEnable);

// wire [63:0] s0, s1, s2, s3, s4, s5, s6;
// assign s0 = 128'b1;
// assign s1 = addr_in[0] ? (s0 << 1) : s0;
// assign s2 = addr_in[1] ? (s1 << 2) : s1;
// assign s3 = addr_in[2] ? (s2 << 4) : s2;
// assign s4 = addr_in[3] ? (s3 << 8) : s3;
// assign s5 = addr_in[4] ? (s4 << 16) : s4;
// assign s6 = addr_in[5] ? (s5 << 32) : s5;
// assign blockEnable = addr_in[6] ? (s6 << 64) : s6;

// endmodule

module offset3to8(input [2:0] offset, output [7:0] WordEnable);
wire [7:0] s0, s1, s2;
assign s0 = 8'b1;
assign s1 = (offset[0]) ? (s0 << 1) : s0;
assign s2 = (offset[1]) ? (s1 << 2) : s1;
assign WordEnable = (offset[2]) ? (s2 << 4) : s2;
endmodule
