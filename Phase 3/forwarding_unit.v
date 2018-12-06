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
    output extoex_fwdA,
    output extoex_fwdB,
    output memtomem_fwdB,
    output memtoex_fwdA,
    output memtoex_fwdB
);

assign extoex_fwdA = ( (em_regwrite) & (em_dstreg == de_regRs) & (em_dstreg != 4'b0000) );
assign extoex_fwdB = ( (em_regwrite) & (em_dstreg == de_RegRt) & (em_dstreg != 4'b0000) );
assign memtomem_fwdB = ((em_memwrite) & (mw_regwrite) & (mw_dstreg!= 4'b0000) & (mw_dstreg == em_RegRt));
assign memtoex_fwdA = ((mw_regwrite) & (mw_regrd != 4'h0) & (~((em_regwrite) & (em_regrd != 4'h0) & (em_regrd == de_regRs))) & (mw_regrd == de_regRs));
assign memtoex_fwdB = ((mw_regwrite) & (mw_regrd != 4'h0) & (~((em_regwrite) & (em_regrd != 4'h0) & (em_regrd == de_RegRt))) & (mw_regrd == de_RegRt));

endmodule