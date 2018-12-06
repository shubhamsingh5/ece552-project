module MemToExFwd(

input MW_RegWrite, //MEM to WB control to write register 
input MW_MemRead, //MEM to WB control to read register 
input EM_RegWrite,	//EX to MEM control to Write Register 
input [3:0] MW_RegRd,	//Destination Register in MEM/WB 
input [3:0] EM_RegRd,	//Destination Register in EX/MEM
input [3:0] DE_RegRs,	//Source Register1 in ID/EX
input [3:0] DE_RegRt, 	//Source Register 2 in ID/EX
input [15:0] dataIn_rs,	//current value in src reg1 in ID/EX
input [15:0] dataIn_rt,	//current value in src reg 2 in ID/EX
input [15:0] dataFromMem,	//data loaded from Memory
output [15:0] dataOut_rs,	//data going into ALU from reg 1 
output [15:0] dataOut_rt	//data going into ALU from reg2 
);

//assign ForwardA = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd = DE_RegRs))) & (MW_RegRd == DE_RegRs)) ? 2'b01 :  
//assign ForwardB = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd = DE_RegRt))) & (MW_RegRd == DE_RegRt))  


assign dataOut_rs = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd == DE_RegRs))) & (MW_RegRd == DE_RegRs)) ? dataFromMem : dataIn_rs;
assign dataOut_rt = ((MW_RegWrite) & (MW_RegRd != 4'h0) & (~((EM_RegWrite) & (EM_RegRd != 4'h0) & (EM_RegRd == DE_RegRt))) & (MW_RegRd == DE_RegRt)) ? dataFromMem : dataIn_rt;

endmodule
