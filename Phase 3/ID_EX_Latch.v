module ID_EX_Latch(clk, rst, en, halt_in, RegDst_in, ALUSrc_in, MemRead_in, MemWrite_in, MemtoReg_in,
                    RegWrite_in, Lower_in, Higher_in, BEn_in, Br_in, PCS_in, opc_in, regs_in, npc_in, wreg_in, a_in, b_in, imm_in,
                    halt_out, RegDst_out, ALUSrc_out, MemRead_out, MemWrite_out, MemtoReg_out, 
                    RegWrite_out, Lower_out, Higher_out, BEn_out, Br_out, PCS_out, opc_out, regs_fwd, npc_out, wreg_out, a_out, b_out, imm_out);

input clk, rst, en, halt_in, RegDst_in, ALUSrc_in, MemRead_in, MemWrite_in, MemtoReg_in,
                    RegWrite_in, Lower_in, Higher_in, BEn_in, Br_in, PCS_in;
input [3:0] wreg_in, opc_in;
input [7:0] regs_in;
input [15:0] npc_in, a_in, b_in, imm_in;

output halt_out, RegDst_out, ALUSrc_out, MemRead_out, MemWrite_out, MemtoReg_out, 
                    RegWrite_out, Lower_out, Higher_out, BEn_out, Br_out, PCS_out;
output [3:0] wreg_out, opc_out;
output [7:0] regs_fwd;
output [15:0] npc_out, a_out, b_out, imm_out;

wire [15:0] zext_regs_in, zext_regs_out;

assign zext_regs_in = {{8{1'b0}},regs_in};

dff halt(.q(halt_out), .d(halt_in), .wen(en), .clk(clk), .rst(rst));
dff regdst(.q(RegDst_out), .d(RegDst_in), .wen(en), .clk(clk), .rst(rst));
dff alusrc(.q(ALUSrc_out), .d(ALUSrc_in), .wen(en), .clk(clk), .rst(rst));
dff memread(.q(MemRead_out), .d(MemRead_in), .wen(en), .clk(clk), .rst(rst));
dff memwrite(.q(MemWrite_out), .d(MemWrite_in), .wen(en), .clk(clk), .rst(rst));
dff memtoreg(.q(MemtoReg_out), .d(MemtoReg_in), .wen(en), .clk(clk), .rst(rst));
dff regwrite(.q(RegWrite_out), .d(RegWrite_in), .wen(en), .clk(clk), .rst(rst));
dff lower(.q(Lower_out), .d(Lower_in), .wen(en), .clk(clk), .rst(rst));
dff higher(.q(Higher_out), .d(Lower_in), .wen(en), .clk(clk), .rst(rst));
dff ben(.q(BEn_out), .d(BEn_in), .wen(en), .clk(clk), .rst(rst));
dff br(.q(Br_out), .d(Br_in), .wen(en), .clk(clk), .rst(rst));
dff pcs(.q(PCS_out), .d(PCS_in), .wen(en), .clk(clk), .rst(rst));

dff b_ff0(.q(wreg_out[0]), .d(wreg_in[0]), .wen(en), .clk(clk), .rst(rst));
dff b_ff1(.q(wreg_out[1]), .d(wreg_in[1]), .wen(en), .clk(clk), .rst(rst));
dff b_ff2(.q(wreg_out[2]), .d(wreg_in[2]), .wen(en), .clk(clk), .rst(rst));
dff b_ff3(.q(wreg_out[3]), .d(wreg_in[3]), .wen(en), .clk(clk), .rst(rst));

dff opc_ff0(.q(opc_out[0]), .d(opc_in[0]), .wen(en), .clk(clk), .rst(rst));
dff opc_ff1(.q(opc_out[1]), .d(opc_in[1]), .wen(en), .clk(clk), .rst(rst));
dff opc_ff2(.q(opc_out[2]), .d(opc_in[2]), .wen(en), .clk(clk), .rst(rst));
dff opc_ff3(.q(opc_out[3]), .d(opc_in[3]), .wen(en), .clk(clk), .rst(rst));

Register npc_reg(.clk(clk), .rst(rst), .WriteReg(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(npc_out), .Bitline2(), .D(npc_in));
Register a_reg(.clk(clk), .rst(rst), .WriteReg(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(a_out), .Bitline2(), .D(a_in));
Register b_reg(.clk(clk), .rst(rst), .WriteReg(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(b_out), .Bitline2(), .D(b_in));
Register imm_reg(.clk(clk), .rst(rst), .WriteReg(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(imm_out), .Bitline2(), .D(imm_in));
Register regs_reg(.clk(clk), .rst(rst), .WriteReg(en), .ReadEnable1(1'b1), .ReadEnable2(1'b0), .Bitline1(zext_regs_out), .Bitline2(), .D(zext_regs_in));

assign regs_fwd = zext_regs_out[7:0];

endmodule