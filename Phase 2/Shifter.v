module Shifter(opcode, Shift_Out, Shift_In, Shift_Val);

input [1:0] opcode;
input [15:0] Shift_In;
input [15:0] Shift_Val;
output [15:0] Shift_Out;

reg [15:0] s1, s2, s3, s4;

always @ (*) begin
	case(opcode) 
		2'b00: begin
			s1 = Shift_Val[0] ? Shift_In << 1 : Shift_In;
			s2 = Shift_Val[1] ? s1 << 2 : s1;
			s3 = Shift_Val[2] ? s2 << 4 : s2;
			s4 = Shift_Val[3] ? s3 << 8 : s3;
		end
		2'b01: begin
			s1 = (Shift_Val[0] ? {Shift_In[15],Shift_In[15:1]} : Shift_In);
			s2 = (Shift_Val[1] ? {{2{s1[15]}},s1[15:2]} : s1);
			s3 = (Shift_Val[2] ? {{4{s2[15]}},s2[15:4]} : s2);
			s4 = (Shift_Val[3] ? {{8{s3[15]}},s3[15:8]} : s3);
		end
		2'b10: begin
			s1 = (Shift_Val[0] ? {Shift_In[0],Shift_In[15:1]} : Shift_In);
			s2 = (Shift_Val[1] ? {s1[1:0],s1[15:2]} : s1);
			s3 = (Shift_Val[2] ? {s2[3:0],s2[15:4]} : s2);
			s4 = (Shift_Val[3] ? {s3[7:0],s3[15:8]} : s3);
		end
		default: 
			s4 = Shift_In;
	endcase
end

assign Shift_Out = s4;

endmodule