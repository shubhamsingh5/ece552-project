
module cpu(
input clk,
input rst_n,
output hlt,
output [15:0] pc
); 

wire [15:0] curr_pc, next_pc;

//control signals
wire halt;                       //signal to halt PC increment
wire RegDst;                    //select destination register
wire ALUSrc;                    //select ALU input
wire MemRead;                   //enable read from memory
wire MemWrite;                  //enable writing to memory
wire MemtoReg;                  //data to be written into a register
wire RegWrite;                  //write enable for register
wire Lower;                     //select for LLB
wire Higher;                    //select for LHB
wire BEn;                       //branch enable
wire Br;                        //branch type
wire PCS;                       //PCS

wire [2:0] flag, ccc, en;
wire [3:0] rs, rt, rd, destReg; //register file inputs
wire [15:0] instr;              //instruction
wire [15:0] reg1, reg2;         //register file outputs
wire [15:0] aluOut;             //output of ALU
wire [15:0] memData;            //data output from memory
wire [15:0] regData;            //data to write to register
wire [15:0] aluA, aluB;         //ALU inputs
wire [15:0] immediate;          //immediate to be passed into ALU
wire [15:0] memAddr;            //memory address
wire [15:0] brAddr;             //address of branch;

//flag_register
flag_register fr(.clk(clk), .rst(~rst_n), .flag_in(flag), .flag_out(ccc), .en(en));
//pc register
pc_reg pcReg(.clk(clk), .rst(~rst_n), .D(brAddr), .WriteEnable(~halt), .q(curr_pc));
//instruction memory
instr_memory iMem(.data_out(instr), .addr(curr_pc), .clk(clk), .rst(~rst_n));
//data memory
data_memory dMem(.data_out(memData), .data_in(reg2), .addr(aluOut), .enable(MemRead), .wr(MemWrite), .clk(clk), .rst(~rst_n));
//register file
RegisterFile rf(.clk(clk), .rst(~rst_n), .SrcReg1(rs), .SrcReg2(rt), .DstReg(destReg), .WriteReg(RegWrite), 
                .DstData(regData), .SrcData1(reg1), .SrcData2(reg2));
//pc control unit
PC_control pcControl(.B(BEn), .C(instr[11:9]), .I(instr[8:0]), .F(flag), .PC_in(curr_pc), .PC_out(next_pc));
//cpu control unit
CPU_control cpuControl(.opc(instr[15:12]), .halt(halt), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemRead(MemRead), 
                       .MemWrite(MemWrite), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .Lower(Lower), 
                       .Higher(Higher), .BEn(BEn), .Br(Br), .PCS(PCS));
//alu for execution
ALU_16bit aluEx(.ALU_Out(aluOut), .ALU_In1(aluA), .ALU_In2(aluB), .Opcode(instr[15:12]), .Flags(flag), .en(en));

//inputs
assign rs = (Lower | Higher) ? rd : instr[7:4];
assign rt = (MemRead | MemWrite) ? instr[11:8] : instr[3:0];
assign rd = instr[11:8];

//muxes
//if LLB or LHB, then set rs to be rd to allow reading
//select which register to write to
assign destReg = (RegDst) ? rd : rt;
//select immediate
assign immediate = (MemRead | MemWrite) ? {{12{1'b0}},instr[3:0]} << 1 :
                   (Lower) ? {{8{1'b0}},instr[7:0]} :
                   (Higher) ? (instr[7:0] << 8) : {{12{1'b0}},instr[3:0]};

//select input for ALU
assign aluA = (MemRead | MemWrite) ? reg1 & 16'hfffe : 
              (Lower) ? (reg1 & 16'hff00) :
              (Higher) ? (reg1 & 16'h00ff) : reg1;

assign aluB = (ALUSrc) ? immediate : reg2;

//if PCS, then write next_pc value to reg, otherwise default to alu output
assign regData = (MemtoReg) ? memData : (PCS) ? next_pc : aluOut;
//select branch type
assign brAddr = (Br) ? reg1 : next_pc;

assign hlt = halt;
assign pc = curr_pc;

endmodule
