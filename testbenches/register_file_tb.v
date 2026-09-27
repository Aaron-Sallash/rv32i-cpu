// Description: Testbench for 32x32-bit Register File

`timescale 1ns / 1ps

//describes the time unit to nanoseconds, then the precision (how finely the simulation can resolve time in general) set to picoseconds

module register_file_tb;

reg clock;
reg writeE;
reg [4:0] regSel1;
reg [4:0] regSel2;
reg [4:0] regOut;
reg [31:0] inP;

//instantiates the clock signal, the control unit writeE, two 5-bit addresses to read at any register, 5-bit address that decides what register a write goes to, and the 32 bit value to be saved

wire [31:0] outP1;
wire [31:0] outP2;

//32-bit register file outputs

regFile dev (.clock(clock), .writeE(writeE), .regSel1(regSel1), .regSel2(regSel2), .regOut(regOut), .inP(inP), .outP1(outP1), .outP2(outP2));

//creates the module from regfile, and named dev for device

//names all port connections from the module, .portname(variable in tb)

always #5 clock = ~clock;
//this generates the clock; every 5 nanoseconds the clock is set to opposite of what it is; 10ns period--100MHz speed

initial begin
    $dumpfile("regfile_test.vcd");
    $dumpvars(0, register_file_tb);

    clock = 0;

//dumpfile names the waveform recording file, dumpvars describes to record everything in this module (0), register_file_tb is the over-arching module

//clock is set to 0

//Test 1: x0 must be read as 0

writeE = 0; regSel1 = 0; regSel2 = 0;
#10;
//turns write enable off, points read ports to x0(holds 0), waits for rising edge of clock

$display("Test 1: x0 read: outP1 = %h (expected: 00000000)", outP1);

//inserts outP1 as hexadecimal and prints

if (outP1 === 32'h00000000) $display("PASS");
else $display("FAIL");

//checks if outP1 is what it should be (32 bits of 0) prints out pass if it is

//Test 2: Write 42 into x5 and read it

writeE = 1; regOut = 5; inP = 32'h0000002A;
#10;
//turns write enable on, points to x5 to write value, sets inP to 42 in hexadecimal, THEN waits exactly one clock period to give time for one edge to happen, and writes

writeE = 0;
regSel1 = 5;
#10;
//turns off write, points read port at x5, waits a clock period

$display("Test 2: x5 read: outP1 = %h (expect 0000002A)", outP1);

if (outP1 === 32'h0000002A) $display("PASS");
else $display("FAIL");

//if outP1 is 42 in hexadecimal, pass

//Test 3: Read two registers

writeE = 1; regOut = 6; inP = 32'h11CAFE11;
#10;
//writes test value to x6 to be displayed

writeE = 0;
regSel1 = 5; regSel2 = 6;
#10;
//points read port 1 to x5 and read port 2 to x6

$display("Test 3: two reads: outP1 = %h, outP2 = %h (expect 0000002A, 11CAFE11)", outP1, outP2);

if (outP1 === 32'h0000002A && outP2 === 32'h11CAFE11) $display ("PASS");
else $display("FAIL");

//Test 4: Try an illegal write

writeE = 1; regOut = 0; inP = 32'h11111111;
#10;
//tries to illegally write a new value to x0, which is currently 00000000

writeE = 0; regSel1 = 0;
#10;
//points regSel1 to read x0

$display("Test 4: x0 after illegal write: outP1 = %h (expect 00000000)", outP1);

if (outP1 === 32'h00000000) $display("PASS");
else $display("FAIL");

$display("______________________________________________");
$display("Regfile testbench complete.");
$finish;
end

endmodule