// Description: Integration testbench for full single-cycle datapath

`timescale 1ns / 1ps

module datapath_full_tb;

reg clock;
wire [31:0] currentPc;
wire [31:0] inst;
wire [31:0] outP1;
wire [31:0] outP2;
wire [31:0] x3probe;

//instantiates the clock, program counter, instruction, register reads, and the x3 probe

integer errors = 0;
//error counter

datapath dev(.clock(clock), .currentPc(currentPc), .inst(inst), .outP1(outP1), .outP2(outP2), .x3probe(x3probe));
//the full datapath, wired for observation

always #5 clock = ~clock;
//toggles every 5ns

task check(input [31:0] expOutP1, input [31:0] expOutP2, input [31:0] expX3, input [31:0] expPc);
if (outP1 !== expOutP1 || outP2 !== expOutP2 || x3probe !== expX3 || currentPc !== expPc)
begin

$display("FAIL: expOutP1=%h expOutP2=%h expx3=%h expPc=%h | got P1=%h P2=%h X3=%h Pc=%h (time %0t)", expOutP1, expOutP2, expX3, expPc, outP1, outP2, x3probe, currentPc, $time);

errors = errors + 1;

end

else
$display("PASS: P1=%h P2=%h x3=%h Pc=%h (time %0t)", outP1, outP2, x3probe, currentPc, $time);

endtask

initial begin

clock = 0;

#2
check(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
//t2 before first edge: addi x1,x0,6 fetched but nothing executed yet, all registers still 0

#10
check(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000004);
//t12 after first edge: x1=6 landed; now executing addi x2,x0,4, reads x0 so P1/P2 are 0

#10
check(32'h00000006, 32'h00000004, 32'h00000000, 32'h00000008);
//t22 after second edge: x2=4 landed; now executing and x3,x1,x2, reads x1=6 and x2=4; x3 not written until next edge

#10
check(32'h00000000, 32'h00000000, 32'h00000004, 32'h0000000c);
//t32 after third edge: the and executed, x3=4 landed; Pc now past the program

if (errors == 0)
$display("All Tests Passed");

else
$display("%d Test(s) Failed", errors);
$finish;

end

endmodule