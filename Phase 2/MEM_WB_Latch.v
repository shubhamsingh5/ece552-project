module EX_MEM_Latch(clk, rst, en, MemtoReg_in, PCS_in, mem_in, alu_in, 
                    MemtoReg_out, PCS_out, mem_out, alu_out);

input clk, rst, en, MemtoReg_in, PCS_in;
input [3:0] wreg_in;
input [15:0] mem_in, alu_in;
output MemtoReg_out, PCS_out;
output [3:0] wreg_out;
output [15:0] mem_out, alu_out;

dff memtoreg(.q(MemtoReg_out), d(MemtoReg_in), .wen(en), .clk(clk), .rst(rst));
dff pcs(.q(PCS_out), .d(PCS_in), .wen(en), .clk(clk), .rst(rst));

dff b_ff0(.q(wreg_out[0]), .d(wreg_in[0]), .wen(en), .clk(clk), .rst(rst));
dff b_ff1(.q(wreg_out[1]), .d(wreg_in[1]), .wen(en), .clk(clk), .rst(rst));
dff b_ff2(.q(wreg_out[2]), .d(wreg_in[2]), .wen(en), .clk(clk), .rst(rst));
dff b_ff3(.q(wreg_out[3]), .d(wreg_in[3]), .wen(en), .clk(clk), .rst(rst));

Register mem_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(mem_out), .D(mem_in));
Register alu_reg(.clk(clk), .rst(rst), .WriteEnable(en), .ReadEnable(1'b1), .ReadEnable2(1'b0), .Bitline1(alu_out), .D(alu_in));

endmodule