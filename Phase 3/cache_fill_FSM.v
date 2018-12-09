module cache_fill_FSM(clk, rst, miss_detected, way_0, way_1, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data_valid, word_sel);
input clk, rst;
input miss_detected; // active high when tag match logic detects a miss
input memory_data_valid; // active high indicates valid data returning on memory bus
input [15:0] miss_address; // address that missed the cache
//input way_0, way_1;
output way_0, way_1;
output fsm_busy; // asserted while FSM is busy handling the miss (can be used as pipeline stall signal)
output write_data_array; // write enable to cache data array to signal when filling with memory_data
output write_tag_array; // write enable to cachetag array to signal when all words are filled in to data array
output [15:0] memory_address; // address to read from memory
output [7:0] word_sel;
//input [15:0] memory_data; // data returned by memory (afterdelay)

wire [15:0] fill_address;
wire curr_state; // 0=idle and 1=wait
wire next_state;
wire chunks_left;
wire [3:0] cnt_in, cnt_out, sum, addr_out, addr_in;

dff state(.clk(clk), .rst(rst), .q(curr_state), .d(next_state), .wen(1'b1));
dff fsm_busy_ff(.clk(clk), .rst(rst), .q(fsm_busy_out), .d(fsm_busy_in), .wen(1'b1));

dff counter1[3:0](.clk(clk), .rst(rst | cnt_out == 4'b1011), .q(cnt_out), .d(cnt_in), .wen(next_state));
dff counter2[3:0](.clk(clk), .rst(rst | ~curr_state), .q(addr_out), .d(addr_in), .wen(memory_data_valid));
CLA4 inc2(.a(addr_out), .b(4'b1), .sum(addr_in), .cin(1'b0), .cout(), .ovfl(), .tg(), .tp());
CLA4 inc(.a(cnt_out), .b(4'b1), .sum(sum), .cin(1'b0), .cout(), .ovfl(), .tg(), .tp());
offset3to8 instr_offset(.offset(fill_address[3:1]), .WordEnable(word_sel));

assign next_state = (~curr_state) ? (miss_detected) : (chunks_left);
assign chunks_left = (curr_state & ~(cnt_out == 4'b1011));
assign cnt_in = (~curr_state) ? 1'b1 : (miss_detected ) ? sum : cnt_out;
assign fsm_busy_in = (~curr_state) ? miss_detected : chunks_left;
assign write_data_array = curr_state & memory_data_valid;
assign write_tag_array = curr_state & cnt_out == 4'b1011;
assign fill_address = rst ? 16'b0 : {miss_address[15:4], addr_out << 1};
assign memory_address = rst ? 16'b0 : {miss_address[15:4], cnt_out << 1};
assign way_0 = (cnt_out[0] == 0);
assign way_1 = (cnt_out[1] == 1);
assign fsm_busy = fsm_busy_out | next_state;

endmodule