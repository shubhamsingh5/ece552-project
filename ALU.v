module ALU(ALU_Out, Error, ALU_In1, ALU_In2, Opcode);

input [3:0] ALU_In1, ALU_In2;
input [1:0] Opcode;

output [3:0] ALU_Out;
output Error; //Just to show overflow

wire sub;
wire [3:0] add_out;
wire [3:0] nand_out;
wire [3:0] xor_out;
reg [3:0] temp;

addsub_4bit add_sub(.A(ALU_In1), .B(ALU_In2), .sub(Opcode[0]), .Sum(add_out), .Ovfl(Error));

xor xor1(xor_out[0], ALU_In1[0], ALU_In2[0]);
xor xor2(xor_out[1], ALU_In1[1], ALU_In2[1]);
xor xor3(xor_out[2], ALU_In1[2], ALU_In2[2]);
xor xor4(xor_out[3], ALU_In1[3], ALU_In2[3]);

nand nand1(nand_out[0], ALU_In1[0], ALU_In2[0]);
nand nand2(nand_out[1], ALU_In1[1], ALU_In2[1]);
nand nand3(nand_out[2], ALU_In1[2], ALU_In2[2]);
nand nand4(nand_out[3], ALU_In1[3], ALU_In2[3]);

always @(*) 
  case (Opcode)
    2'b01 : begin
      temp = add_out;
    end
    2'b10 : begin
      temp = xor_out;
    end
    2'b11 : begin
      temp = nand_out;
    end
    default : begin
      temp = add_out;
    end
endcase

assign ALU_Out = temp;

endmodule