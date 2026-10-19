// Description: Testbench to verify what imemory returns when pcounter makes its address

`timescale 1ns / 1ps

module pcounter_imemory_tb;

reg clock;
wire [31:0] currentPc;
wire [31:0] inst;
wire [31:0] pcounterPlus4;

integer errors = 0;
//error counter

program_counter dev (.clock(clock), .nextPc(pcounterPlus4), .currentPc(currentPc));
//assigns the clock, nextPc, and currentPc to copy program_counter

instruction_memory imemory1 (.adrs(currentPc), .inst(inst));
//assigns the input address to be the pcounter's output: currentPc, and assigns copy instruction to be pcounters output

assign pcounterPlus4 = currentPc + 4;
//since each next instruction is 4 bytes from the last, the next program counter starts at 4 bytes from last address

always #5 clock = ~clock; 
//every 5ns clock flips edge

task check(input [31:0] expected);
if (inst !== expected)
//checks if the instruction is the expected

begin
$display("FAIL: expected %h, got %h at program_counter=%h (time %0t)", expected, inst, currentPc, $time);
//returns time of failure since behavior is time dependent; checking at a time before an edge would hold a different value than after

errors = errors + 1;
end
else begin
$display("PASS: program_counter=%h fetched %h at time %0t", currentPc, inst, $time);
//if passed, returns what program counter's address was and the instruction that was fetched

end
endtask

initial begin
clock = 0;

//my_prog.hex's values:
//addi x1, x0, 6 -> 00600093
//addi x2, x0, 4 -> 00400113
//and x3, x1, x2 -> 0020F1B3

#2
check(32'h00600093);
//t2 before first edge so inst 0

#10
check(32'h00400113);
//t12 after first edge, prog counter + 4, inst 1

#10
check(32'h0020F1B3);
//t22 after second edge, prog counter 8, inst 2

#10
check(32'h00000000);
//t32 after third edge, prog counter 12, confirm it got past

if (errors == 0) $display("All Tests Passed");
else $display("%0d Test(s) Failed", errors);

$finish;

end

endmodule