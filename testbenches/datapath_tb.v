// Description: Testbench for CPU datapath skeleton

`timescale 1ns / 1ps

module datapath_tb;

reg clock;
wire [31:0] currentPc;
wire [31:0] inst;
wire [31:0] outP1;
wire [31:0] outP2;

//instantiates the clock, current program counter to keep track, the instruction, and the two outputs all as wires

integer errors = 0;
//error counter

datapath dev(.clock(clock), .currentPc(currentPc), .inst(inst), .outP1(outP1), .outP2(outP2));

always #5 clock = ~clock;
//toggles every 5ns

task check(input [31:0] expOutP1, input [31:0] expOutP2);
if (outP1 !== expOutP1 || outP2 !== expOutP2)
begin

$display("FAIL: expOutP1=%h expOutP2=%h outP1=%h outP2=%h at pCounter=%h (time %0t)", expOutP1, expOutP2, outP1, outP2, currentPc, $time);

errors = errors + 1;

end

else
$display("PASS: outP1=%h outP2=%h at pCounter=%h (time %0t)", outP1, outP2, currentPc, $time);

endtask

initial begin

clock = 0;
//checking for each program in program.hex

#2
check(32'h00000000, 32'h00000000);
//t2 before first edge, store x0 + 6 in x1, while rs1 and 2 are holding 0 since they are read outputs

#10
check(32'h00000000, 32'h00000000);
//t12 after first edge, store x0 + 4 in x2, while rs1 and 2 are holding 0

#10
check(32'h00000000, 32'h00000000);
//t22 after second edge, store and of x1 and x2 in x3, register reads x1 and x2 which don't actually receive 6 and 4 since no ALU, so gets 0 and 0

#10
check(32'h00000000, 32'h00000000);
//t32 after third edge, verifies that after programs are done, the zero fill works

if (errors == 0)
$display("All Tests Passed");

else
$display("%d Test(s) Failed", errors);
$finish;

end

endmodule