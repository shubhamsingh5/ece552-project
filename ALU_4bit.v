module ALU (ALU_Out, Error, ALU_In1, ALU_In2, Opcode);
input [3:0] ALU_In1, ALU_In2;
input [1:0] Opcode;
output reg [3:0] ALU_Out;
output Error; // Just to show overflow
wire [3:0] Sum;
wire [3:0] Diff;
addsub_4bit add(.Sum(Sum), .Ovfl(Error), .A(ALU_In1), .B(ALU_In2), .sub(1'b0));	//perform addition
addsub_4bit sub(.Sum(Diff), .Ovfl(Error), .A(ALU_In1), .B(ALU_In2), .sub(1'b1));	//perform subtraction

always @* case(Opcode)
2'b00 : ALU_Out = Sum; //Addition
2'b01 :  ALU_Out = Diff;  //Subtraction
2'b10 :  ALU_Out = ~(ALU_In1 & ALU_In2);	//perform NAND operation
2'b11 :  ALU_Out = ALU_In1 ^ ALU_In2;	//perform XOR operation

endcase

endmodule
