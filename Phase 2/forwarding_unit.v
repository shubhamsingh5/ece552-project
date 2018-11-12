module forwarding_unit(
    input em_regwrite,
    input em_memwrite,
    input mw_regwrite,
    input [3:0] em_dstreg,
    input [3:0] mw_dstreg,
    input [3:0] de_regRs,
    input [3:0] de_RegRt,
    input [3:0] em_RegRt,
    input [3:0] mw_regrd,
    input [3:0] em_regrd,
    input [15:0] data_dstReg,
    input [15:0] data_in_RegRs,
    input [15:0] data_in_RegRt,
    input [15:0] data_mem,
    output [15:0] data_out_RegRs,
    output [15:0] data_out_RegRt
);

wire extoex_fwdA, extoex_fwdB, memtomem_fwdA, memtomem_fwdB, memtoex_fwdA, memtoex_fwdB;

assign extoex_fwdB = ( (em_regwrite) & (em_dstreg == de_RegRt) & (em_dstreg != 4'b0000) );
assign extoex_fwdA = ( (em_regwrite) & (em_dstreg == de_regRs) & (em_dstreg != 4'b0000) );
assign memtomem_fwdB = ((em_memwrite) & (mw_regwrite) & (mw_dstreg!= 4'b0000) & (mw_dstreg == em_RegRt));
assign memtoex_fwdA = ((mw_regwrite) & (mw_regrd != 4'h0) & (~((em_regwrite) & (em_regrd != 4'h0) & (em_regrd == de_regRs))) & (mw_regrd == de_regRs)) ? 2'b11 : 2'b00;
assign memtoex_fwdB = ((mw_regwrite) & (mw_regrd != 4'h0) & (~((em_regwrite) & (em_regrd != 4'h0) & (em_regrd == de_RegRt))) & (mw_regrd == de_RegRt)) ? 2'b11 : 2'b00;

assign data_out_RegRs = extoex_fwdA ? data_dstReg :
                        memtoex_fwdA ? data_mem : data_in_RegRs;
assign data_out_RegRt = (extoex_fwdA || memtomem_fwdB) ? data_dstReg :
                        memtoex_fwdB ? data_mem : data_in_RegRt;

endmodule