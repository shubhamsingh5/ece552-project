
module cpu(
input clk,
input rst_n,
output hlt,
output [15:0] pc
); 



//pipeline wires
wire [15:0] curr_pc, next_pc, if_id_npc, id_ex_npc, ex_mem_npc, mem_wb_npc;
wire [2:0] flag, ccc, en;
wire [3:0] rs, rt, rd, rt_fwd, destReg, id_ex_wreg, ex_mem_wreg, mem_wb_wreg;                                         //register file inputs
wire [3:0] id_ex_opc, ex_mem_opc;
wire [7:0] rsrt_fwd;
wire [15:0] instr, instr_if_id;                                         //instruction
wire [15:0] if_id_reg1, if_id_reg2, id_ex_reg1, id_ex_reg2, ex_mem_reg2, reg1_fwd, reg2_fwd;           //register file outputs
wire [15:0] ex_aluout, ex_mem_aluout, mem_wb_aluout;                                                     //output of ALU
wire [15:0] mem_memdata, mem_wb_memdata;                                                    //data output from memory
wire [15:0] wb_regdata;                                                    //data to write to register
wire [15:0] aluA, aluB;                                                 //ALU inputs
wire [15:0] id_imm, id_ex_immm;                                                  //immediate to be passed into ALU
wire [15:0] brAddr;                                                     //address of branch;

//pipeline control signals
wire stall, stall_if_id, stall_id_ex, flush, if_flush;
wire if_id_halt, id_ex_halt, ex_mem_halt, mem_wb_halt;                  //signal to halt PC increment
wire if_id_RegDst, id_ex_RegDst;                                        //select destination register
wire if_id_ALUSrc, id_ex_ALUSrc;                                        //select ALU input
wire if_id_MemRead, id_ex_MemRead, ex_mem_MemRead;                      //enable read from memory
wire if_id_MemWrite, id_ex_MemWrite, ex_mem_MemWrite;                   //enable writing to memory
wire if_id_MemtoReg, id_ex_MemtoReg, ex_mem_MemtoReg, mem_wb_MemtoReg;  //data to be written into a register
wire if_id_RegWrite, id_ex_RegWrite, ex_mem_RegWrite, mem_wb_RegWrite;  //write enable for register
wire if_id_Lower, id_ex_Lower;                                          //select for LLB
wire if_id_Higher, id_ex_Higher;                                        //select for LHB
wire if_id_BEn, id_ex_BEn;                      //branch enable
wire if_id_Br, id_ex_Br;                          //branch type
wire if_id_PCS, id_ex_PCS, ex_mem_PCS, mem_wb_PCS;                      //PCS

wire bTaken;

//select branch type
assign brAddr = (if_id_Br) ? if_id_reg1 : next_pc;
assign if_flush = ~rst_n | flush;
assign hlt = mem_wb_halt;
assign pc = curr_pc;


//*********************************************    IF STAGE      ********************************************************************
//pipeline register
IF_ID_latch if_id(.clk(clk), .rst(if_flush), .en(~stall_if_id), .npc_in(brAddr), .instr_in(instr), .npc_out(if_id_npc), .instr_out(instr_if_id));
//pc register
pc_reg pcReg(.clk(clk), .rst(~rst_n), .D(brAddr), .WriteEnable(~if_id_halt), .q(curr_pc));
//instruction memory
instr_memory iMem(.data_out(instr), .addr(curr_pc), .clk(clk), .rst(~rst_n));
//pc control unit
PC_control pcControl(.B(if_id_BEn), .C(instr[11:9]), .I(instr[8:0]), .F(flag), .PC_in(curr_pc), .PC_out(next_pc), .bTaken(bTaken));


//***********************************************************************************************************************************


//*********************************************    ID STAGE      ********************************************************************
//pipeline register
ID_EX_Latch id_ex(.clk(clk), .rst(~rst_n), .en(~stall_id_ex), .halt_in(if_id_halt), .RegDst_in(if_id_RegDst), .ALUSrc_in(if_id_ALUSrc), .MemRead_in(if_id_MemRead),
                    .MemWrite_in(if_id_MemWrite), .MemtoReg_in(if_id_MemtoReg),.RegWrite_in(if_id_RegWrite), .Lower_in(if_id_Lower),
                    .Higher_in(if_id_Higher), .BEn_in(if_id_BEn), .Br_in(if_id_Br), .PCS_in(if_id_PCS), .opc_in(instr_if_id[15:12]), .regs_in({rs,rt}), .npc_in(if_id_npc), .wreg_in(destReg), 
                    .a_in(if_id_reg1), .b_in(if_id_reg2), .imm_in(id_imm), .halt_out(id_ex_halt), .RegDst_out(id_ex_RegDst), .ALUSrc_out(id_ex_ALUSrc),
                    .MemRead_out(id_ex_MemRead), .MemWrite_out(id_ex_MemWrite), .MemtoReg_out(id_ex_MemtoReg), .RegWrite_out(id_ex_RegWrite),
                    .Lower_out(id_ex_Lower), .Higher_out(id_ex_Higher), .BEn_out(id_ex_BEn), .Br_out(id_ex_Br), .PCS_out(id_ex_PCS), .opc_out(id_ex_opc), .regs_fwd(rsrt_fwd),
                    .npc_out(id_ex_npc), .wreg_out(id_ex_wreg), .a_out(id_ex_reg1), .b_out(id_ex_reg2), .imm_out(id_ex_immm));
//register file
RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(rs), .SrcReg2(rt), .DstReg(mem_wb_wreg), .WriteReg(mem_wb_RegWrite), 
                .DstData(wb_regdata), .SrcData1(if_id_reg1), .SrcData2(if_id_reg2));
//cpu control unit
CPU_control cpuControl(.opc(instr_if_id[15:12]), .halt(if_id_halt), .RegDst(if_id_RegDst), .ALUSrc(if_id_ALUSrc), .MemRead(if_id_MemRead), 
                       .MemWrite(if_id_MemWrite), .MemtoReg(if_id_MemtoReg), .RegWrite(if_id_RegWrite), .Lower(if_id_Lower), 
                       .Higher(if_id_Higher), .BEn(if_id_BEn), .Br(if_id_Br), .PCS(if_id_PCS));
//flag_register
flag_register fr(.clk(clk), .rst(~rst_n), .flag_in(flag), .flag_out(ccc), .en(en));
//hazard detecion unit
hazard hzd(.br(if_id_BEn), .mem_opc(ex_mem_opc), .id_rs(rs), .mem_rd(ex_mem_wreg), .stall(stall));
//decode register numbers from instruction
assign rs = (if_id_Lower | if_id_Higher) ? rd : instr_if_id[7:4];
assign rt = (if_id_MemRead | if_id_MemWrite) ? instr_if_id[11:8] : instr_if_id[3:0];
assign rd = instr_if_id[11:8];
assign destReg = (if_id_RegDst) ? rd : rt;
assign id_imm = (if_id_MemRead | if_id_MemWrite) ? {{12{1'b0}},instr_if_id[3:0]} << 1 :
                   (if_id_Lower) ? {{8{1'b0}},instr_if_id[7:0]} : (instr_if_id[7:0] << 8);

//check for branch
assign stall_if_id = stall;
assign stall_id_ex = stall;
assign flush = if_id_BEn;
//***********************************************************************************************************************************


//*********************************************    EX STAGE      ********************************************************************
//pipeline register
EX_MEM_Latch ex_mem(.clk(clk), .rst(~rst_n), .en(1), .wreg_in(id_ex_wreg), .halt_in(id_ex_halt), .MemRead_in(id_ex_MemRead), .MemWrite_in(id_ex_MemWrite),
                    .MemtoReg_in(id_ex_MemtoReg), .RegWrite_in(id_ex_RegWrite), .PCS_in(id_ex_PCS), .rt_fwd_in(rsrt_fwd[3:0]), .npc_in(id_ex_npc), .b_in(id_ex_reg2),
                    .alu_in(ex_aluout), .opcode_in(id_ex_opc),.wreg_out(ex_mem_wreg), .halt_out(ex_mem_halt), .MemRead_out(ex_mem_MemRead), 
                    .MemWrite_out(ex_mem_MemWrite),.MemtoReg_out(ex_mem_MemtoReg), .RegWrite_out(ex_mem_RegWrite), .PCS_out(ex_mem_PCS),
                    .rt_fwd_out(rt_fwd), .npc_out(ex_mem_npc), .b_out(ex_mem_reg2), .alu_out(ex_mem_aluout), .opcode_out(ex_mem_opc));
//alu for execution
ALU_16bit aluEx(.ALU_Out(ex_aluout), .ALU_In1(aluA), .ALU_In2(aluB), .Opcode(id_ex_opc), .Flags(flag), .en(en));
//forwarding unit
forwarding_unit fwd(.em_regwrite(ex_mem_RegWrite), .em_memwrite(ex_mem_MemWrite), .mw_regwrite(mem_wb_RegWrite), .em_dstreg(ex_mem_wreg), .mw_dstreg(mem_wb_wreg),
                    .de_regRs(rsrt_fwd[7:4]), .de_RegRt(rsrt_fwd[3:0]), .em_RegRt(rt_fwd), .mw_regrd(mem_wb_wreg), .em_regrd(ex_mem_wreg), .data_dstReg(wb_regdata),
                    .data_in_RegRs(id_ex_reg1), .data_in_RegRt(id_ex_reg2), .data_mem(mem_memdata), .data_out_RegRs(reg1_fwd), .data_out_RegRt(reg2_fwd));
//select input for ALU
assign aluA = (id_ex_MemRead | id_ex_MemWrite) ? reg1_fwd & 16'hfffe : 
              (id_ex_Lower) ? (reg1_fwd & 16'hff00) :
              (id_ex_Higher) ? (reg1_fwd & 16'h00ff) : reg1_fwd;
assign aluB = (id_ex_ALUSrc) ? id_ex_immm : reg2_fwd;

//***********************************************************************************************************************************


//*********************************************    MEM STAGE      ********************************************************************
//pipeline register
MEM_WB_Latch mem_wb(.clk(clk), .rst(~rst_n), .en(1), .wreg_in(ex_mem_wreg), .halt_in(ex_mem_halt), .MemtoReg_in(ex_mem_MemtoReg), .RegWrite_in(ex_mem_RegWrite),
                    .PCS_in(ex_mem_PCS), .npc_in(ex_mem_npc), .mem_in(mem_memdata), .alu_in(ex_mem_aluout),.wreg_out(mem_wb_wreg), .halt_out(mem_wb_halt), .MemtoReg_out(mem_wb_MemtoReg),
                    .RegWrite_out(mem_wb_RegWrite), .PCS_out(mem_wb_PCS), .npc_out(mem_wb_npc), .mem_out(mem_wb_memdata), .alu_out(mem_wb_aluout));
//data memory
data_memory dMem(.data_out(mem_memdata), .data_in(ex_mem_reg2), .addr(ex_mem_aluout), .enable(ex_mem_MemRead), .wr(ex_mem_MemWrite), .clk(clk), .rst(~rst_n));

//if PCS, then write next_pc value to reg, otherwise default to alu output
assign wb_regdata = (mem_wb_MemtoReg) ? mem_wb_memdata : (mem_wb_PCS) ? mem_wb_npc : mem_wb_aluout;

//***********************************************************************************************************************************

endmodule
