module WriteDecoder_4_16(RegId, WriteReg, Wordline);

input WriteReg;
input [3:0] RegId;
output [15:0] Wordline;

assign Wordline = (WriteReg == 1'b0) ? 16'h0 :
                  (RegId == 0) ? 16'h1 :
                  (RegId == 1) ? 16'h2 :
                  (RegId == 2) ? 16'h4 :
                  (RegId == 3) ? 16'h8 :
                  (RegId == 4) ? 16'h10 :
                  (RegId == 5) ? 16'h20 :
                  (RegId == 6) ? 16'h40 :
                  (RegId == 7) ? 16'h80 :
                  (RegId == 8) ? 16'h100 :
                  (RegId == 9) ? 16'h200 :
                  (RegId == 10) ? 16'h400 :
                  (RegId == 11) ? 16'h800 :
                  (RegId == 12) ? 16'h1000 :
                  (RegId == 13) ? 16'h2000 :
                  (RegId == 14) ? 16'h4000 : 16'h8000;

endmodule // WriteDecoder_4_16
