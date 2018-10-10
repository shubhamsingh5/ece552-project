module Shifter(Shift_Out, Shift_In, Shift_Val, Mode);

input [15:0] Shift_In;
input [3:0] Shift_Val;
input Mode;
output [15:0] Shift_Out;

wire [15:0] s1, s2, s3, s4;

assign s1 = (Shift_Val[0] ? (Mode ? {Shift_In[15],Shift_In[14:1]} : Shift_In << 1) : Shift_In);
assign s2 = (Shift_Val[1] ? (Mode ? {{2{s1[15]}},s1[15:2]} : s1 << 2) : s1);
assign s3 = (Shift_Val[2] ? (Mode ? {{4{s2[15]}},s2[15:4]} : s2 << 4) : s2);
assign s4 = (Shift_Val[3] ? (Mode ? {{8{s3[15]}},s3[15:8]} : s3 << 8) : s3);

assign Shift_Out = s4;

endmodule