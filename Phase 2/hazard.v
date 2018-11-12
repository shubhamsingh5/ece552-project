module hazard(
    input br,
    input [3:0] mem_opc,
    input [3:0] id_rs,
    input [3:0] mem_rd,
    output stall
);

assign stall = (br & (mem_opc == 4'h8 || 4'b00??) & id_rs == mem_rd);

endmodule