module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

input clk, rst, WriteReg;
input [3:0] SrcReg1, SrcReg2, DstReg;
input [15:0] DstData;
inout [15:0] SrcData1, SrcData2;

wire [15:0] dcd_out1, dcd_out2, dcd_out3;
wire [15:0] src1_data;
wire [15:0] src2_data;
//wire resD1, resD2;
ReadDecoder_4_16 rd1(.RegId(SrcReg1), .Wordline(dcd_out1));
ReadDecoder_4_16 rd2(.RegId(SrcReg2), .Wordline(dcd_out2));
WriteDecoder_4_16 rd3(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(dcd_out3));

Register reg1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[0]), .ReadEnable1(dcd_out1[0]), .ReadEnable2(dcd_out2[0]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[1]), .ReadEnable1(dcd_out1[1]), .ReadEnable2(dcd_out2[1]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[2]), .ReadEnable1(dcd_out1[2]), .ReadEnable2(dcd_out2[2]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[3]), .ReadEnable1(dcd_out1[3]), .ReadEnable2(dcd_out2[3]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[4]), .ReadEnable1(dcd_out1[4]), .ReadEnable2(dcd_out2[4]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[5]), .ReadEnable1(dcd_out1[5]), .ReadEnable2(dcd_out2[5]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[6]), .ReadEnable1(dcd_out1[6]), .ReadEnable2(dcd_out2[6]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[7]), .ReadEnable1(dcd_out1[7]), .ReadEnable2(dcd_out2[7]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[8]), .ReadEnable1(dcd_out1[8]), .ReadEnable2(dcd_out2[8]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[9]), .ReadEnable1(dcd_out1[9]), .ReadEnable2(dcd_out2[9]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[10]), .ReadEnable1(dcd_out1[10]), .ReadEnable2(dcd_out2[10]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[11]), .ReadEnable1(dcd_out1[11]), .ReadEnable2(dcd_out2[11]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[12]), .ReadEnable1(dcd_out1[12]), .ReadEnable2(dcd_out2[12]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[13]), .ReadEnable1(dcd_out1[13]), .ReadEnable2(dcd_out2[13]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[14]), .ReadEnable1(dcd_out1[14]), .ReadEnable2(dcd_out2[14]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[15]), .ReadEnable1(dcd_out1[15]), .ReadEnable2(dcd_out2[15]), .Bitline1(src1_data), .Bitline2(src2_data));


	
	
assign SrcData1 = (DstReg == SrcReg1) ? DstData : src1_data;
assign SrcData2 = (DstReg == SrcReg2) ? DstData : src2_data;

endmodule
