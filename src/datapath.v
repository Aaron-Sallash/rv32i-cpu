// Description: Single-cycle datapath, assembling verified components

module datapath (input wire clock, output wire [31:0] currentPc, output wire [31:0] inst, output wire [31:0] outP1, output wire [31:0] outP2);
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

reg [31:0] inP;
//placeholder until ALU exists

wire writeE = 1'b0;
//placeholder until control unit exists

regFile regfile1 (.clock(clock), .writeE(writeE), .regSel1(rs1), .regSel2(rs2), .regOut(rd), .inP(inP), .outP1(outP1), .outP2(outP2));
//copying regfile

endmodule