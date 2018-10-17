
module PC_control(
input B,
input [2:0] C,
input [15:0] I,
input [2:0] F,
input [15:0] PC_in,
output [15:0] PC_out
);

reg [15:0] target_addr;


always @(*) begin
  case (C)
    3'b000: //not equal (Z=0)
        target_addr = (F[1]) ? PC_in + 2 : PC_in + 2 + (I << 1);
    3'b001: //equal (Z=1)
        target_addr = (F[1]) ? PC_in + 2 + (I << 1) : PC_in + 2;
    3'b010: //greater than (Z=N=0)
        target_addr = (F[2] & F[1]) ? PC_in + 2 : PC_in + 2 + (I << 1);
    3'b011: //less than (N=1)
        target_addr = (F[2]) ? PC_in + 2 + (I << 1) : PC_in + 2;
    3'b100: //Greater than or equal (Z=1 or Z=N=0)
        target_addr = (F[1] | ~F[2] | ~F[1]) ? PC_in + 2 + (I << 1) : PC_in + 2;
    3'b101: //less than or equal (N = 1 or Z = 1)
        target_addr = (F[1] | F[2]) ? PC_in + 2 + (I << 1) : PC_in + 2;
    3'b110: //overflow (V = 1)
        target_addr = (F[0]) ? PC_in + 2 + (I << 1) : PC_in + 2;
    3'b111: //unconditional
        target_addr = PC_in + 2 + (I << 1);
    default: 
        target_addr = PC_in + 2;
  endcase
end


assign PC_out = B ? target_addr : PC_in + 2;

endmodule
