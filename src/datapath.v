// Description: Single-cycle datapath, assembling verified components

module datapath (input wire clock, output wire [31:0] currentPc, output wire [31:0] inst, output wire [31:0] outP1, output wire [31:0] outP2, output wire [31:0] x3probe);
//clock, current program counter, instruction, and outputs instantiated to be observable for testbench

wire [31:0] pcounterPlus4;
//program counter + 4, the address of the next instruction

program_counter pcounter1 (.clock(clock), .nextPc(pcounterPlus4), .currentPc(currentPc));
//copying the program counter

instruction_memory imemory1 (.adrs(currentPc), .inst(inst));
//copying the instruction memory

assign pcounterPlus4 = currentPc + 4;
//actually assigning pcounterPlus4 equal to the next instruction by increments of adding 4 to the address

wire[4:0] rs1 = inst[19:15];
//bits 19:15 of the instruction select first operand register

wire[4:0] rs2 = inst[24:20];
//bits 24:20 of the instruction select second operand register

wire[4:0] rd = inst[11:7];
//bits 11:7 of the instruction select destination register

wire [31:0] inP;
//reg file input by alu result

wire writeE;
//register write enable by control unit

regFile regfile1 (.clock(clock), .writeE(writeE), .regSel1(rs1), .regSel2(rs2), .regOut(rd), .inP(inP), .outP1(outP1), .outP2(outP2), .regSel3(5'd3), .outP3(x3probe));
//copying regfile

wire [3:0] aluControl;
wire regWr;

control_unit controlunit1 (.instrClass(inst[6:0]), .opFam(inst[14:12]), .opBit(inst[30]), .aluControl(aluControl), .regWr(regWr));
//instantiates control unit; gets the low 7 bits and assigns that to the instruction class port, assigns the 3-bits that decide family to operation family port, assigns the second bit to operation bit (decides between add/sub), and then the regWr to regWr port

wire [31:0] immediate;

immediate_gen immediategen1 (.inst(inst), .immediate(immediate));
//copies immediate generator

wire [31:0] aluOp2;
assign aluOp2 = inst[5] ? outP2 : immediate;
//sets aluOp2 to outP2 if the 5th instruction bit is 1(register type); if not(immediate type), then assigns value immediate to it

wire [31:0] aluOut;
wire aluZero;

alu alu1(.WireA(outP1), .WireB(aluOp2), .aluControl(aluControl), .outP(aluOut), .zero(aluZero));
//copies alu; register read 1 into operand 1, second from multiplexer, operation from control unit, and result and zero flags as outputs

assign inP = aluOut;
//alu computed value goes into register

assign writeE = regWr;
//control unit write decision decides register file write enable

endmodule