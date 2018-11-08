module IF_ID_latch(clk, rst, en, npc_in, instr_in, 
                    BEn_out, Br_out, npc_out, instr_out);

input clk, rst, en, BEn_in, Br_in;
input [15:0] npc_in, instr_in;

output BEn_out, Br_out;
output [15:0] npc_out, instr_out;

dff memread(.q(BEn_out), .d(BEn_in), .wen(en), .clk(clk), .rst(rst));
dff memwrite(.q(Br_out), .d(Br_in), .wen(en), .clk(clk), .rst(rst));

Register instr_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(instr_out), .D(instr_in));
Register npc_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(npc_out), .D(npc_in));

endmodule