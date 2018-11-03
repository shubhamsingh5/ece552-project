module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

input clk, rst, WriteReg;
input [3:0] SrcReg1, SrcReg2, DstReg;
input [15:0] DstData;
inout [15:0] SrcData1, SrcData2;

wire [15:0] dcd_out1, dcd_out2, dcd_out3;
wire [15:0] src1_data0, src1_data1, src1_data2, src1_data3, src1_data4, src1_data5, src1_data6, src1_data7, src1_data8, src1_data9, src1_data10, src1_data11, src1_data12, src1_data13, src1_data14, src1_data15;
wire [15:0] src2_data0, src2_data1, src2_data2, src2_data3, src2_data4, src2_data5, src2_data6, src2_data7, src2_data8, src2_data9, src2_data10, src2_data11, src2_data12, src2_data13, src2_data14, src2_data15;

ReadDecoder_4_16 rd1(.RegId(SrcReg1), .Wordline(dcd_out1));
ReadDecoder_4_16 rd2(.RegId(SrcReg2), .Wordline(dcd_out2));
WriteDecoder_4_16 rd3(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(dcd_out3));

Register reg1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[0]), .ReadEnable1(dcd_out1[0]), .ReadEnable2(dcd_out2[0]), .Bitline1(src1_data0), .Bitline2(src2_data0));
Register reg0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[1]), .ReadEnable1(dcd_out1[1]), .ReadEnable2(dcd_out2[1]), .Bitline1(src1_data1), .Bitline2(src2_data1));
Register reg2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[2]), .ReadEnable1(dcd_out1[2]), .ReadEnable2(dcd_out2[2]), .Bitline1(src1_data2), .Bitline2(src2_data2));
Register reg3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[3]), .ReadEnable1(dcd_out1[3]), .ReadEnable2(dcd_out2[3]), .Bitline1(src1_data3), .Bitline2(src2_data3));
Register reg4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[4]), .ReadEnable1(dcd_out1[4]), .ReadEnable2(dcd_out2[4]), .Bitline1(src1_data4), .Bitline2(src2_data4));
Register reg5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[5]), .ReadEnable1(dcd_out1[5]), .ReadEnable2(dcd_out2[5]), .Bitline1(src1_data5), .Bitline2(src2_data5));
Register reg6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[6]), .ReadEnable1(dcd_out1[6]), .ReadEnable2(dcd_out2[6]), .Bitline1(src1_data6), .Bitline2(src2_data6));
Register reg7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[7]), .ReadEnable1(dcd_out1[7]), .ReadEnable2(dcd_out2[7]), .Bitline1(src1_data7), .Bitline2(src2_data7));
Register reg8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[8]), .ReadEnable1(dcd_out1[8]), .ReadEnable2(dcd_out2[8]), .Bitline1(src1_data8), .Bitline2(src2_data8));
Register reg9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[9]), .ReadEnable1(dcd_out1[9]), .ReadEnable2(dcd_out2[9]), .Bitline1(src1_data9), .Bitline2(src2_data9));
Register reg10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[10]), .ReadEnable1(dcd_out1[10]), .ReadEnable2(dcd_out2[10]), .Bitline1(src1_data10), .Bitline2(src2_data10));
Register reg11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[11]), .ReadEnable1(dcd_out1[11]), .ReadEnable2(dcd_out2[11]), .Bitline1(src1_data11), .Bitline2(src2_data11));
Register reg12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[12]), .ReadEnable1(dcd_out1[12]), .ReadEnable2(dcd_out2[12]), .Bitline1(src1_data12), .Bitline2(src2_data12));
Register reg13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[13]), .ReadEnable1(dcd_out1[13]), .ReadEnable2(dcd_out2[13]), .Bitline1(src1_data13), .Bitline2(src2_data13));
Register reg14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[14]), .ReadEnable1(dcd_out1[14]), .ReadEnable2(dcd_out2[14]), .Bitline1(src1_data14), .Bitline2(src2_data14));
Register reg15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(dcd_out3[15]), .ReadEnable1(dcd_out1[15]), .ReadEnable2(dcd_out2[15]), .Bitline1(src1_data15), .Bitline2(src2_data15));

assign SrcData1 = (dcd_out1[0]) ? src1_data0 :
                  (dcd_out1[1]) ? src1_data1 :
                  (dcd_out1[2]) ? src1_data2 :
                  (dcd_out1[3]) ? src1_data3 :
                  (dcd_out1[4]) ? src1_data4 :
                  (dcd_out1[5]) ? src1_data5 :
                  (dcd_out1[6]) ? src1_data6 :
                  (dcd_out1[7]) ? src1_data7 :
                  (dcd_out1[8]) ? src1_data8 :
                  (dcd_out1[9]) ? src1_data9 :
                  (dcd_out1[10]) ? src1_data10 :
                  (dcd_out1[11]) ? src1_data11 :
                  (dcd_out1[12]) ? src1_data12 :
                  (dcd_out1[13]) ? src1_data13 :
                  (dcd_out1[14]) ? src1_data14 :
                  (dcd_out1[15]) ? src1_data15 : 16'bz;

assign SrcData2 = (dcd_out2[0]) ? src2_data0 :
                  (dcd_out2[1]) ? src2_data1 :
                  (dcd_out2[2]) ? src2_data2 :
                  (dcd_out2[3]) ? src2_data3 :
                  (dcd_out2[4]) ? src2_data4 :
                  (dcd_out2[5]) ? src2_data5 :
                  (dcd_out2[6]) ? src2_data6 :
                  (dcd_out2[7]) ? src2_data7 :
                  (dcd_out2[8]) ? src2_data8 :
                  (dcd_out2[9]) ? src2_data9 :
                  (dcd_out2[10]) ? src2_data10 :
                  (dcd_out2[11]) ? src2_data11 :
                  (dcd_out2[12]) ? src2_data12 :
                  (dcd_out2[13]) ? src2_data13 :
                  (dcd_out2[14]) ? src2_data14 :
                  (dcd_out2[15]) ? src2_data15 : 16'bz;

endmodule
