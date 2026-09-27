// Description: Testbench for rv32i ALU (add, sub, and, or, xor)

`timescale 1ns / 1ps

module alu_tb;

reg [31:0] WireA;
reg [31:0] WireB;
reg [3:0]  aluControl;
wire [31:0] outP;
wire zero;

//instantiates the two input operands, the operation selector(aluControl), the result, and the zero FLag

integer errors = 0;

//creates an error counter so that every time a check fails the errors will go up by one

alu dev (.WireA(WireA), .WireB(WireB), .aluControl(aluControl), .outP(outP), .zero(zero));

//inserts a copy of the alu to be tested(like the register tb), named dev for device

task check(input [3:0] operation, input [31:0] x, input [31:0] y, input [31:0] expectedR, input expectedZ);

//creates a check routine with five inputs matching the copied alu: 4 bit operation code to test, 2 32-bit operands to be tested, a 32-bit expected result, and a 1-bit expected 0 flag

begin
WireA = x; WireB = y; aluControl = operation;
#10;
//opens the body of the task, waits so that outP and zero stabilize

if (outP === expectedR && zero === expectedZ)
$display("PASS: operation=%b %h,%h -> %h zero=%b", operation, x, y, outP, zero);
//checks if output is equal to the expected result, and uses === instead of == since it can see if it is also unknown value(which would make it fail)
//if it passes prints the operation the two inputs in hex, then the output and the zero flag, in different value types(binary or hexadecimal)


else begin
$display("FAIL: operation=%b %h,%h -> %h (expected %h), zero=%b (expected %b)",
operation, x, y, outP, expectedR, zero, expectedZ);
//else prints the failed values

errors = errors + 1;
//then adds 1 to error if else function is ran

end
//ends the else begin

end
//ends the task's body

endtask
//ends the "check" task overall

initial begin
//begins tests

//ADD (0000)
check(4'b0000, 32'd3, 32'd4, 32'd7, 1'b0); 
//adds 3 and 4 and checks to see if it is expected result 7

check(4'b0000, 32'd0, 32'd0, 32'd0, 1'b1);
//adds one and zero, and zero flag is set to 1 since it is supposed to equal 0

//SUB (0001)
check(4'b0001, 32'd9, 32'd2, 32'd7, 1'b0);
//subtracts 2 from 9 and checks if it is the expected result 7

check(4'b0001, 32'd3, 32'd3, 32'd0, 1'b1);
//subtracts 3 from 3 and checks if it is the expected result 0

//AND (0010)
check(4'b0010, 32'h0440, 32'h0044, 32'h0040, 1'b0);
//checks two inputs and if the value returned is ONLY the bits that are in common

//OR (0011)
check (4'b0011, 32'h0B0B, 32'hB0B0, 32'hBBBB, 1'b0);
//checks if the value returned is the union of the bits of the two inputs

//XOR (0100)
check (4'b0100, 32'hAA00, 32'h0AA0, 32'hA0A0, 1'b0);
//checks if the value returned is only the bits that are exclusive to each input

check (4'b0100, 32'hAAAA, 32'hAAAA, 32'h0000, 1'b1);
//checks if when both inputs are same(no exclusive bits), the output is what is expected (0)

check (4'b0100, 32'h00BB, 32'h0111, 32'h01AA, 1'b0);
//checks what bits are exclusive for each bit that is in same digit place but have different values ((B = 1011) ^ (1 = 0001) = (A = 1010))

//DEFAULT (1111)
check (4'b1111, 32'd50, 32'd25, 32'd0, 1'b1);
//unexpected operation outputs 0

if (errors == 0) $display ("All tests passed");
else $display("%0d Test(s) failed", errors);
$finish;
//prints if tests passed or not, and if not shows how many errors, finishes printing

end
//ends testing

endmodule