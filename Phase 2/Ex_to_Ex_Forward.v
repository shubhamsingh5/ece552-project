
module ExToEx_Fwd(
input EM_RegWrite, //EX to MEM, write register 
input [3:0] EM_dstReg, //destination Register in EX to MEM
input [3:0] DE_RegRs, //ID to EX Register Rs
input [3:0] DE_RegRt,
input [15:0] data_dstReg,
input [15:0] data_in_RegRs, //ID to EX Register Rs data
input [15:0] data_in_RegRt,
output [15:0] data_out_RegRs, //ID to EX Register RS data output
output [15:0] data_out_RegRt
);

assign data_out_RegRt = ( (EM_RegWrite) & (EM_dstReg == DE_RegRt) & (EM_dstReg != 4'b0000) ) ? data_dstReg : data_in_RegRt;
assign data_out_RegRs = ( (EM_RegWrite) & (EM_dstReg == DE_RegRs) & (EM_dstReg != 4'b0000) ) ? data_dstReg : data_in_RegRs;
endmodule
