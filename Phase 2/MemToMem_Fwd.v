
module MemToMem_Fwd(
input EM_MemWrite, //LW, LHB, LLB share dstReg with SW rt
input MW_RegWrite,
input [3:0] MW_dstReg, //destination Register for LW rt, and LLB LHB's rd
input [3:0] EM_RegRt,
input [15:0] data_dstReg,
input [15:0] data_in_RegRt,
output [15:0] data_out_RegRt
);

assign data_out_RegRt = ((EM_MemWrite) & (MW_RegWrite) & (MW_dstReg!= 4'b0000) & (MW_dstReg == EM_RegRt)) ?  data_dstReg : data_in_RegRt;

endmodule
