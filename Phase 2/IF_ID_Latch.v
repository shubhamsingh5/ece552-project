module IF_ID_latch(clk, rst, en, npc_in, instr_in, npc_out, instr_out);

input clk, rst, en;
input [15:0] npc_in, instr_in;

output [15:0] npc_out, instr_out;

Register instr_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(instr_out), .D(instr_in));
Register npc_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(npc_out), .D(npc_in));

endmodule