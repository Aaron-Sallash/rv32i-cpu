// Description: Testbench for 32x32-bit Register File

`timescale 1ns / 1ps

//describes the time unit to nanoseconds, then the precision (how finely the simulation can resolve time in general) set to picoseconds

module register_file_tb;

reg clk;
reg WrEn;
reg [4:0] r1;
reg [4:0] r2;
reg [4:0] rd;
reg [31:0] wd;

//instantiates the clock signal, the control unit WrEn, two 5-bit addresses to read at any register, 5-bit address that decides what register a write goes to, and the 32 bit value to be saved

wire [31:0] rd1;
wire [31:0] rd2;

//32-bit register file outputs

regFile dev (.clk(clk), .WrEn(WrEn), .r1(r1), .r2(r2), 
.rd(rd), .wd(wd), .rd1(rd1), .rd2(rd2));

//creates the module from regfile, and named dev for device

//names all port connections from the module, .portname(variable in tb)

always #5 clk = ~clk;
//this generates the clock; every 5 nanoseconds the clk is set to opposite of what it is; 10ns period--100MHz speed

initial begin
    $dumpfile("regfile_test.vcd");
    $dumpvars(0, register_file_tb);

    clk = 0;

//dumpfile names the waveform recording file, dumpvars describes to record everything in this module (0), register_file_tb is the over-arching module

//clk is set to 0

//Test 1: x0 must be read as 0

WrEn = 0; r1 = 0; r2 = 0;
#10;
//turns write enable off, points read ports to x0(holds 0), waits for rising edge of clock

$display("Test 1: x0 read: rd1 = %h (expected: 00000000)", rd1);

//inserts rd1 as hexadecimal and prints

if (rd1 === 32'h00000000) $display("PASS");
else $display("FAIL");

//checks if rd1 is what it should be (32 bits of 0) prints out pass if it is

//Test 2: Write 42 into x5 and read it

WrEn = 1; rd = 5; wd = 32'h0000002A;
#10;
//turns write enable on, points to x5 to write value, sets wd to 42 in hexadecimal, THEN waits exactly one clock period to give time for one edge to happen, and writes

WrEn = 0;
r1 = 5;
#10;
//turns off write, points read port at x5, waits a clock period

$display("Test 2: x5 read: rd1 = %h (expect 0000002A)", rd1);

if (rd1 === 32'h0000002A) $display("PASS");
else $display("FAIL");

//if rd1 is 42 in hexadecimal, pass

//Test 3: Read two registers

WrEn = 1; rd = 6; wd = 32'h11CAFE11;
#10;
//writes test value to x6 to be displayed

WrEn = 0;
r1 = 5; r2 = 6;
#10;
//points read port 1 to x5 and read port 2 to x6

$display("Test 3: two reads: rd1 = %h, rd2 = %h (expect 0000002A, 11CAFE11)", rd1, rd2);

if (rd1 === 32'h0000002A && rd2 === 32'h11CAFE11) $display ("PASS");
else $display("FAIL");

//Test 4: Try an illegal write

WrEn = 1; rd = 0; wd = 32'h11111111;
#10;
//tries to illegally write a new value to x0, which is currently 00000000

WrEn = 0; r1 = 0;
#10;
//points r1 to read x0

$display("Test 4: x0 after illegal write: rd1 = %h (expect 00000000)", rd1);

if (rd1 === 32'h00000000) $display("PASS");
else $display("FAIL");

$display("______________________________________________");
$display("Regfile testbench complete.");
$finish;
end

endmodule