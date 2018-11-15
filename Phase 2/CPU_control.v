module CPU_control(opc, halt, RegDst, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite, Lower, Higher, BEn, Br, PCS);

input [15:12] opc;
output halt, RegDst, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite, Lower, Higher, BEn, Br, PCS;

reg r_hlt, r_RegDst, r_ALUSrc, r_MemRead, r_MemWrite, r_MemtoReg, r_RegWrite, r_Lower, r_Higher, r_BEn, r_Br, r_PCS;
always @(*) begin
  casex (opc)
  4'b00??: begin        //ADD, SUB, XOR, RED
    assign r_hlt = 0;
    assign r_RegDst = 1;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 1;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b0111: begin        //PADDSB
    assign r_hlt = 0;
    assign r_RegDst = 1;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 1;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b01??: begin        //SLL. SRA. ROR
    assign r_hlt = 0;
    assign r_RegDst = 1;
    assign r_ALUSrc = 1;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 1;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b1000: begin        //LW
    assign r_hlt = 0;
    assign r_RegDst = 0;
    assign r_ALUSrc = 1;
    assign r_MemRead = 1;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 1;
    assign r_RegWrite = 1;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b1001: begin        //SW
    assign r_hlt = 0;
    assign r_RegDst = 0;
    assign r_ALUSrc = 1;
    assign r_MemRead = 0;
    assign r_MemWrite = 1;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 0;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b1010: begin        //LLB
    assign r_hlt = 0;
    assign r_RegDst = 1;
    assign r_ALUSrc = 1;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 1;
    assign r_Lower = 1;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b1011: begin        //LHB
    assign r_hlt = 0;
    assign r_RegDst = 1;
    assign r_ALUSrc = 1;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 1;
    assign r_Lower = 0;
    assign r_Higher = 1;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b1100: begin        //B
    assign r_hlt = 0;
    assign r_RegDst = 0;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 0;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 1;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  4'b1101: begin        //BR
    assign r_hlt = 0;
    assign r_RegDst = 0;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 0;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 1;
    assign r_Br = 1;
    assign r_PCS = 0;
  end
  4'b1110: begin        //PCS
    assign r_hlt = 0;
    assign r_RegDst = 1;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 1;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 1;
  end
  4'b1111: begin        //HLT
    assign r_hlt = 1;
    assign r_RegDst = 0;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 0;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
    default: begin       
    assign r_hlt = 0;
    assign r_RegDst = 0;
    assign r_ALUSrc = 0;
    assign r_MemRead = 0;
    assign r_MemWrite = 0;
    assign r_MemtoReg = 0;
    assign r_RegWrite = 0;
    assign r_Lower = 0;
    assign r_Higher = 0;
    assign r_BEn = 0;
    assign r_Br = 0;
    assign r_PCS = 0;
  end
  endcase
end

assign halt = r_hlt;
assign RegDst = r_RegDst;
assign ALUSrc = r_ALUSrc;
assign MemRead = r_MemRead;
assign MemWrite = r_MemWrite;
assign MemtoReg = r_MemtoReg;
assign RegWrite = r_RegWrite;
assign Lower = r_Lower;
assign Higher = r_Higher;
assign BEn = r_BEn;
assign Br = r_Br;
assign PCS = r_PCS;

endmodule