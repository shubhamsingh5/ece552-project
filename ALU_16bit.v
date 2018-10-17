module ALU_16bit(ALU_Out, ALU_In1, ALU_In2, Opcode,Flags);
output [2:0] Flags;
input [15:0] ALU_In1;
input [15:0] ALU_In2;
input [3:0] Opcode;
output [15:0] ALU_Out;
wire [15:0] Sum;
wire [15:0] Diff, PADDSB;
wire [15:0] Exor;
wire [15:0] Red;
wire OvflAdd,OvflSub,N,V,Z;
CLA_16bit add(.A(A), .B(B), .Sum(Sum), .Cout(), .ovfl(OvflAdd), .sub(1'b0));
CLA_16bit sub(.A(A), .B(B), .Sum(Diff), .Cout(), .ovfl(OvflSub), .sub(1'b1));
RedUnit redUnit(.A(A), .B(B), .RedResult(Red));
PADDSB_16bit paddsb(.Sum(PADDSB), .A(A), .B(B));

assign Exor = A ^ B;

always @* case (Opcode)
4'b0000 : ALU_Out = Sum;
4'b0001 : ALU_Out = Diff;
4'b0010 : ALU_Out = Exor;
4'b0011 : ALU_Out = Red;
4'h4 : SLL;
4'h5 : SRA;
4'h6 : ROR;
4'h7 : PADDSB;
endcase
/*
always @* case (Opcode)
4'b0000 : begin 
			ALU_Out = Sum;
			V = OvflAdd;
			Z = (Sum & 16'h0000);
			N = Sum[15];
			end
4'b0001 : begin
		ALU_Out = Diff;
		V = OvflSub;
		Z = (Diff & 16'h0000);
		N = Diff[15];	
		end
4'b0010 : begin
		ALU_Out = Exor;
		Z = (Exor & 16'h0000);
		end
4'b0011 : ALU_Out = Red;
4'h4 : bSLL;
4'h5 : SRA;
4'h6 : ROR;
4'h7 : PADDSB;
endcase */
assign ALU_Out = (Opcode == 4'h0) ? Sum:
				 (Opcode == 4'h1) ? Diff:
				 (Opcode == 4'h2) ? Exor:
				 (Opcode == 4'h3) ? Red:
				 (Opcode == 4'h4) ? SLL:
				 (Opcode == 4'h5) ? SRA:
				 (Opcode == 4'h6) ? ROR: PADDSB;
assign V = ((Opcode == 4'h0)& (OvflAdd == 1'b1)) ? 1'b1:
		   ((Opcode == 4'h1) & (OvflSub == 1'b1)) ? 1'b1: 1'b0;
assign N = ((Opcode == 4'h0)& (Sum[15] == 1'b1)) ? 1'b1:
		   ((Opcode == 4'h1) & (Diff[15] == 1'b1)) ? 1'b1: 1'b0;
assign Z = (ALU_Out == 16'h0000);
endmodule


