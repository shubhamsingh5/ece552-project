module MemToEx_Fwd(

input MW_RegWrite, //MEM to WB control to write register 
input MW_MemRead, //MEM to WB control to read register 
input EM_RegWrite,	//EX to MEM control to Write Register 
input [3:0] MW_RegRd,	//Destination Register in MEM/WB 
input [3:0] EM_RegRd,	//Destination Register in EX/MEM
input [3:0] DE_RegRs,	//Source Register1 in ID/EX
input [3:0] DE_RegRt, 	//Source Register 2 in ID/EX
output [1:0] fwd_RegRs,	//data going into ALU from reg 1 
output [1:0] fwd_RegRt	//data going into ALU from reg2 
);

//assign ForwardA = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd != DE_RegRs))) & (MW_RegRd == DE_RegRs)) ? 2'b01 :  
//assign ForwardB = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd != DE_RegRt))) & (MW_RegRd == DE_RegRt))  
assign fwd_RegRs = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd != DE_RegRs))) & (MW_RegRd == DE_RegRs)) ? 2'b11 : 2'b00;
assign fwd_RegRt = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd != DE_RegRt))) & (MW_RegRd == DE_RegRt)) ? 2'b11 : 2'b00;

endmodule
