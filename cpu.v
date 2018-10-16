
module cpu(
input clk,
input rst_n,
output hlt,
output pc[15:0]
); 

wire rst;
reg [2:0] FLAG;

wire [15:0] rst_pc;
wire [15:0] current_pc, new_pc;
wire [15:0] RegRp1, RegRp2, RegRp3;

reg [15:0] WrData;
wire [15:0] Add, Sub, Xor, Red, Sll, Sra, Ror, Pad, Llb, Lhb;

assign rst =  ~rst_n;
memory1c rst1(.data_out(rst_pc), .data_in(16'h0000), .addr(16'h0000), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));
assign current_pc = (rst_n) ? 16'b0 : rst_pc; // execution start at address 0x0000

RegisterFile reg1(.clk(clk), .rst(rst), .SrcReg1(current_pc[7:4]), .SrcReg2(current_pc[3:0]), .DstReg(4'b0000), .WriteReg(1'b0), .DstData(16'h0000), .SrcData1(RegRp2), .SrcData2(RegRp3));
//RegisterFile reg3 ();  read [7:4] as rs Rp2, [3:0] as rt Rp3

//instructions execution
ADD addinst(); //including flag, output Add
SUB subinst(); //including flag, output Sub
XOR xorinst(); //including flag, output Xor
SLL sllinst(); //including flag, output Sll
SRA srainst(); //including flag, output Sra
ROR rorinst(); //including flag, output Ror
RED redinst(); //otuput Red
PADDSB padinst(); //output Pad
LLB llbinst(); //output llb
LHB lhbinst(); //output lhb



assign sign_ext

always @* case(current_pc[15:12])
4'b0000: begin WrData = Add; RegWrite = 1'b1; end
4'b0001: begin WrData = Sub; RegWrite = 1'b1; end
4'b0010: begin WrData = Xor; RegWrite = 1'b1; end
4'b0011: begin WrData = Red; RegWrite = 1'b1; end
4'b0100: begin WrData = Sll; RegWrite = 1'b1; end
4'b0101: begin WrData = Sra; RegWrite = 1'b1; end
4'b0110: begin WrData = Ror; RegWrite = 1'b1; end
4'b0111: begin WrData = Pad; RegWrite = 1'b1; end
4'b1000: begin RegWrite = 1'b1; MemRead = 1'b1; end //lw
4'b1001: MemWrite = 1'b1; //sw
4'b1010: begin WrData = Llb; RegWrite = 1'b1; end
4'b1011: begin WrData = Lhb; RegWrite = 1'b1; end
4'b1100: begin branchEn = 1'b1; br = 1'b0; end
4'b1101: begin branchEn = 1'b1; br = 1'b1; end
4'b1110: PCWrite = 1'b1;
4'b1111: hlt = 1'b1;
default: rst_n = 1'b0; //reset
endcase

//write register
RegisterFile reg2(.clk(clk), .rst(rst), .SrcReg1(4'b0000), .SrcReg2(4'b0000), .DstReg(current_pc[11:8]), .WriteReg(RegWrite), .DstData(WrData), .SrcData1(16'h0000), .SrcData2(16'h0000));

//LW and SW, wirte and read memory

//branchEn enable while on branch instructions
PC_control pcinst(.branch(branchEn),.Br(br), ....., .PC_in(current_pc), .PC_out(new_pc));
//execute the PCs
PCS
assign pc = (hlt) ? new_pc : current_pc;

endmodule
