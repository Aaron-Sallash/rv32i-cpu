// Description: Testbench for R-type control unit decoder

`timescale 1ns / 1ps

module control_unit_tb;

reg [6:0] instrClass;
reg [2:0] opFam;
reg opBit;
wire [3:0] aluControl;
wire regWr;

//instantiates the instruction class register to confirm its R-type, operation family register which decides what family the iunstruction is of, operation bit register that decides if its add or sub, alu control wire that sends the control to alu, and register write wire that decides if it gets written to a register

integer errors = 0;

//error counter

control_unit dev (.instrClass(instrClass), .opFam(opFam), .opBit(opBit), .aluControl(aluControl), .regWr(regWr));

task check(input [6:0] op, input [2:0] fam3, input addsub, input [3:0] expectedC, input expectedWr);

//creates a repeatable task with inputs matching control unit, and two outputs to check if the actual outputs when ran through the checker match these expected values

begin

instrClass = op; opFam = fam3; opBit = addsub;
#10;
//makes sure the inputs have time to change to reflect these values

if (aluControl === expectedC && regWr === expectedWr)
$display("PASS: op=%b family=%b addsub=%b -> alu=%b regWr=%b", op, fam3, addsub, aluControl, regWr);

else begin
$display("FAIL: op=%b family=%b addsub=%b -> alu=%b (exp %b), regWr=%b (exp %b)", op, fam3, addsub, aluControl, expectedC, regWr, expectedWr);
errors = errors + 1;
//adds to errors if the alu that is calculated doesn't equal the expected or if the regwrite value that decides if it gets written is equal to the expected value


end

end

endtask

initial begin
check(7'b0110011, 3'b000, 1'b0, 4'b0000, 1'b1);
//add

check(7'b0110011, 3'b000, 1'b1, 4'b0001, 1'b1);
//sub

check(7'b0110011, 3'b111, 1'b0, 4'b0010, 1'b1);
//and

check(7'b0110011, 3'b110, 1'b0, 4'b0011, 1'b1);
//or

check(7'b0110011, 3'b100, 1'b0, 4'b0100, 1'b1);
//xor

check(7'b0000011, 3'b000, 1'b0, 4'b0000, 1'b0);
//feeds the code for loads(0000011) and checks if it outputs the add code 0000 like it should

check(7'b0100011, 3'b010, 1'd0, 4'b0000, 1'b0);
//does same as load check except feeds in code for store instruction

if (errors == 0) $display("All Tests Passed");
else             $display("%0d Test(s) failed", errors);
$finish;
end

endmodule