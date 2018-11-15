
module PC_control(
input B,
input [2:0] C,  //F=[N,Z,V]
input [8:0] I,
input [2:0] F,
input [15:0] PC_in,
output bTaken,
output [15:0] PC_out
);

wire [15:0] taken, notTaken;
reg b;

reg [15:0] target_addr;

wire [15:0] sext = {{7{I[8]}},I[8:0]};
wire [15:0] lshift;

ADDSUB ntaken_add(.a(PC_in), .b(16'h0002), .sum(notTaken), .ovfl(OvflSub), .sub(1'b0));
ADDSUB taken_add(.a(notTaken), .b(lshift), .sum(taken), .ovfl(OvflAdd), .sub(1'b0));

assign lshift = sext << 1;

always @(*) begin
  case (C)
    3'b000: begin //not equal (Z=0)
        target_addr = (F[1]) ? notTaken : taken;
        b = (F[1]) ? 1'b0 : 1'b1;
        end
    3'b001: begin //equal (Z=1)
        target_addr = (F[1]) ? taken : notTaken;
        b = (F[1]) ? 1'b1 : 1'b0;
        end
    3'b010: begin //greater than (Z=N=0)
        target_addr = (F[2] & F[1]) ? notTaken : taken;
        b = (F[2] & F[1]) ? 1'b0 : 1'b1;
        end
    3'b011: begin //less than (N=1)
        target_addr = (F[2]) ? taken : notTaken;
        b = (F[2]) ? 1'b1 : 1'b0;
        end
    3'b100: begin //Greater than or equal (Z=1 or Z=N=0)
        target_addr = (F[1] | ~F[2] | ~F[1]) ? taken : notTaken;
        b = (F[1] | ~F[2] | ~F[1]) ? 1'b1 : 1'b0;
        end
    3'b101: begin //less than or equal (N = 1 or Z = 1)
        target_addr = (F[1] | F[2]) ? taken : notTaken;
        b = (F[1] | F[2]) ? 1'b1 : 1'b0;
        end
    3'b110: begin //overflow (V = 1)
        target_addr = (F[0]) ? taken : notTaken;
        b = (F[0]) ? 1'b1 : 1'b0;
        end
    3'b111: begin //unconditional
        target_addr = taken;
        b = 1'b1;
        end
    default: begin 
        target_addr = notTaken;
        b = 1'b0;
        end
  endcase
end


assign PC_out = B ? target_addr : notTaken;
assign bTaken = B ? b : 1'b0;

endmodule
