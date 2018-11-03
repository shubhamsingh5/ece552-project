
module PC_control(
input B,
input [2:0] C,  //F=[N,Z,V]
input [8:0] I,
input [2:0] F,
input [15:0] PC_in,
output [15:0] PC_out
);

wire [15:0] taken, notTaken;


reg [15:0] target_addr;

wire [15:0] sext = {{7{I[8]}},I[8:0]};
wire [15:0] lshift;

CLA_16bit ntaken_add(.A(PC_in), .B(16'h0002), .Sum(notTaken), .Cout(), .ovfl(OvflSub), .sub(1'b0));
CLA_16bit taken_add(.A(notTaken), .B(lshift), .Sum(taken), .Cout(), .ovfl(OvflAdd), .sub(1'b0));

assign lshift = sext << 1;

always @(*) begin
  case (C)
    3'b000: //not equal (Z=0)
        target_addr = (F[1]) ? notTaken : taken;
    3'b001: //equal (Z=1)
        target_addr = (F[1]) ? taken : notTaken;
    3'b010: //greater than (Z=N=0)
        target_addr = (F[2] & F[1]) ? notTaken : taken;
    3'b011: //less than (N=1)
        target_addr = (F[2]) ? taken : notTaken;
    3'b100: //Greater than or equal (Z=1 or Z=N=0)
        target_addr = (F[1] | ~F[2] | ~F[1]) ? taken : notTaken;
    3'b101: //less than or equal (N = 1 or Z = 1)
        target_addr = (F[1] | F[2]) ? taken : notTaken;
    3'b110: //overflow (V = 1)
        target_addr = (F[0]) ? taken : notTaken;
    3'b111: //unconditional
        target_addr = taken;
    default: 
        target_addr = notTaken;
  endcase
end


assign PC_out = B ? target_addr : notTaken;

endmodule
