// Description: Testbench for 32-bit immediate instruction generator

`timescale 1ns / 1ps

module immediate_gen_tb;

reg [31:0] inst;
wire [31:0] immediate;

//

integer errors = 0;
//error counter

immediate_gen dev(.inst(inst), .immediate(immediate));

task check(input [31:0] expected);
if (immediate !== expected)
begin

$display("FAIL: expected=%h got=%h (time %0t)", expected, immediate, $time);

errors = errors + 1;

end else

$display("PASS: immediate=%h (time %0t)", immediate, $time);
endtask

initial begin

//checks for same instruction with different immediate, addi x1, x0, (immediate val)

inst = 32'h00700093;
#10
check(32'h00000007);
//checks to make sure that the output is the first bit * 20, 00000, plus the 12-bit instruction, 007
//immediate value is 7

inst = 32'hFF900093;
#10
check(32'hFFFFFFF9);
//checks to make sure that the output is the first bit * 20, FFFFF, plus the 12-bit instruction, FF9
//immediate value is -7

inst = 32'h00000093;
#10
check(32'h00000000);
//checks same instruction on when immediate value is 0

if (errors == 0)
$display("All Tests Passed");

else
$display("%d Test(s) Failed", errors);

$finish;

end

endmodule