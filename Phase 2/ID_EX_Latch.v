module ID_EX_Latch(clk, rst, en, ALUSrc_in, Lower_in, Higher_in, npc_in, wreg_in, a_in, b_in, imm_in, 
                    ALUSrc_out, Lower_out, Higher_out, npc_out, wreg_out, a_out, b_out, imm_out);

input clk, rst, en, ALUSrc_in, Lower_in, Higher_in;
input [3:0] wreg_in;
input [15:0] npc_in, a_in, b_in, imm_in;

output ALUSrc_out, Lower_out, Higher_out;
output [3:0] wreg_out;
output [15:0] npc_out, wreg_out, a_out, b_out, imm_out;

dff alusrc(.q(ALUSrc_out), .d(ALUSrc_in), .wen(en), .clk(clk), .rst(rst));
dff lower(.q(Lower_out), .d(Lower_in), .wen(en), .clk(clk), .rst(rst));
dff higher(.q(Higher_out), .d(Higher_in), .wen(en), .clk(clk), .rst(rst));

dff b_ff0(.q(wreg_out[0]), .d(wreg_in[0]), .wen(en), .clk(clk), .rst(rst));
dff b_ff1(.q(wreg_out[1]), .d(wreg_in[1]), .wen(en), .clk(clk), .rst(rst));
dff b_ff2(.q(wreg_out[2]), .d(wreg_in[2]), .wen(en), .clk(clk), .rst(rst));
dff b_ff3(.q(wreg_out[3]), .d(wreg_in[3]), .wen(en), .clk(clk), .rst(rst));

Register instr_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(wreg_out), .D(wreg_in));
Register npc_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(npc_out), .D(npc_in));
Register a_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(a_out), .D(a_in));
Register b_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(b_out), .D(b_in));
Register imm_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(imm_out), .D(imm_in));


endmodule