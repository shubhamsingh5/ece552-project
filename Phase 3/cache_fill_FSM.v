module cache_fill_FSM(clk, rst, miss_detected, way_0, way_1, miss_address, fsm_busy, write_data_array, write_tag_array,memory_address, memory_data_valid);
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
//input [15:0] memory_data; // data returned by memory (afterdelay)

wire curr_state; // 0=idle and 1=wait
wire next_state;
wire chunks_left;
wire [3:0] cnt_in, cnt_out, sum;

dff state(.clk(clk), .rst(rst), .q(curr_state), .d(next_state), .wen(1'b1));
dff counter[3:0](.clk(clk), .rst(rst), .q(cnt_out), .d(cnt_in), .wen(1'b1));
CLA4 inc(.a(cnt_out), .b(4'b1), .sum(sum), .cin(4'b0), .cout(), .ovfl(), .tg(), .tp());

assign next_state = (~curr_state) ? (miss_detected) : (chunks_left);
assign chunks_left = (curr_state & ~(cnt_out == 1000));
assign cnt_in = (~curr_state) ? 1'b0 : (memory_data_valid & (cycle_out[1:0] == 2'b11)) ? sum : cnt_out;
assign fsm_busy = (~curr_state) ? miss_detected : fsm_busy;
assign write_data_array = curr_state & memory_data_valid;
assign write_tag_array = curr_state & ~chunks_left;
assign memory_address = rst ? 16'b0 : {miss_address[15:4], cnt_out << 1};
assign way_0 = (cnt_out[0] == 0);
assign way_1 = (cnt_out[1] == 1);

endmodule