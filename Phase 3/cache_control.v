module cache_control(clk, rst, instr_cache_addr, data_cache_addr, memory_data, cache_data, stall, Wen_cache, Ren_cache, data_valid_memory);
input clk, rst;
input Wen_cache, Ren_cache;
input [15:0] instr_cache_addr, data_cache_addr;                 //addresses for icache and dcache
input [15:0] data_cache_data_in;                                //data to store in dcache
output [15:0] cache_data;                                       //data output by cache for loads
output if_stall, mem_stall;                                     //pipeline stall signals

wire instr_miss_detected, data_miss_detected;
wire data_valid;
wire FSM_tag_Wen;
wire instr_write_0, instr_write_1, data_write_0, data_write_1;
wire [7:0] instr_metadata0, instr_metadata1, data_metadata0, data_metadata1;
wire [7:0] instr_cache_wordEn, data_cache_wordEn;
wire [63:0] instr_blockEnable, data_blockEn;
wire [15:0] instr_cache_data_in, data_cache_data_in;
wire [15:0] instr_cache_data_out0, instr_cache_data_out1, data_cache_data_out0, data_cache_data_out1;
wire [15:0] memory_data_out;

//6 to 64 decoder for index bits
cb6to64 instr_index(.addr_in(instr_cache_addr[9:4]), .blockEnable(instr_blockEnable));
cb6to64 data_index(.addr_in(data_cache_addr[9:4]), .blockEnable(data_blockEn));

//3 to 8 decoder for word select
offset3to8 instr_offset(.offset(instr_cache_addr[3:1]), .WordEnable(instr_cache_wordEn));
offset3to8 data_offset(.offset(data_cache_addr[3:1]), .WordEnable(data_cache_wordEn));

//instruction cache
Icache icache(.clk(clk), .rst(rst), .data_we(FSM_cache_Wen), .tag_we(FSM_tag_Wen), .Write0(instr_write_0), .Write1(instr_write_1),
                .wordEn(instr_cache_wordEn), .tag_in(), .data_in(instr_cache_data_in), .data_blockEn(instr_blockEnable), .tag_out0(instr_metadata0),
                .tag_out1(instr_metadata1), .data_out0(instr_cache_data_out0), .data_out1(instr_cache_data_out1));

//data cache
Dcache dcache(.clk(clk), .rst(rst), .data_we(FSM_cache_Wen), .tag_we(FSM_tag_Wen), .Write0(data_write_0), .Write1(data_write_1),
                .wordEn(data_cache_wordEn), .tag_in(), .data_in(data_cache_data_in), .data_blockEn(data_blockEn), .tag_out0(data_metadata0),
                .tag_out1(data_metadata1), .data_out0(data_cache_data_out0), .data_out1(data_cache_data_out1));

//state machine to handle cache misses
cache_fill_FSM FSM(.clk(clk), .rst(rst), .miss_detected(miss_detected), .miss_address(cache_addr), .fsm_busy(stall), .write_data_array(FSM_cache_Wen),
                .write_tag_array(FSM_tag_Wen), .memory_address(memory_address), .memory_data_valid(data_valid_memory));
                
//Wen_cache when cpu write data to cache, FSM_cache_Wen when FSM asks memory wirte data to cache
memory4c memory(.data_out(memory_data_out), .data_in(cache_data), .addr(memory_address), .enable(Wen_cache | miss_detected), .wr(Wen_cache), .clk(), .rst(rst), .data_valid(data_valid_memory));

//figure out which way contains valid cache block
assign instr_write_0 = (instr_cache_addr[15:10] == instr_metadata0[5:0] & instr_metadata0[7]);
assign instr_write_1 = (instr_cache_addr[15:10] == instr_metadata1[5:0] & instr_metadata1[7]);
assign data_write_0 = (instr_cache_addr[15:10] == data_metadata0[5:0] & data_metadata0[7]);
assign data_write_1 = (instr_cache_addr[15:10] == data_metadata1[5:0] & data_metadata1[7]);

//figure out if there was a cache miss
assign instr_miss_detected = (~instr_write_0 & ~instr_write_1) & (Wen_cache | Ren_cache);
assign data_miss_detected = (~data_write_0 & ~data_write_1) & (Wen_cache | Ren_cache);
//get miss address in case of cache miss
assign miss_address = instr_miss_detected ? instr_cache_addr : data_cache_addr;

//this memory should be set outside the cache control 

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

module cb7to128(input [6:0] addr_in, output [127:0] blockEnable);

wire [63:0] s0, s1, s2, s3, s4, s5, s6;
assign s0 = 128'b1;
assign s1 = addr_in[0] ? (s0 << 1) : s0;
assign s2 = addr_in[1] ? (s1 << 2) : s1;
assign s3 = addr_in[2] ? (s2 << 4) : s2;
assign s4 = addr_in[3] ? (s3 << 8) : s3;
assign s5 = addr_in[4] ? (s4 << 16) : s4;
assign s6 = addr_in[5] ? (s5 << 32) : s5;
assign blockEnable = addr_in[6] ? (s6 << 64) : s6;

endmodule

module offset3to8(input [2:0] offset, output [7:0] WordEnable);
wire [7:0] s0, s1, s2;
assign s0 = 8'b1;
assign s1 = (offset[0]) ? (s0 << 1) : s0;
assign s2 = (offset[1]) ? (s1 << 2) : s1;
assign WordEnable = (offset[2]) ? (s2 << 4) : s2;
endmodule
