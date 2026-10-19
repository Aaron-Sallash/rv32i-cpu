// Description: Array of 32-bit RV32i instruction words

module instruction_memory (input wire [31:0] adrs, output wire [31:0] inst);

//creates the module with input of current program position(what instruction is needed) as a 32-bit address, and outputs the instruction to be decoded in each other module

reg [31:0] memory [0:63];
//creates 64 entries of 32-bits each, to run multiple instructions from one program

assign inst = memory[adrs[7:2]];
//the low two bits are removed since not used for instructions, and next 6 bits are used to find which of the 64 entries to select

initial begin
for (integer i = 0; i < 64; i = i + 1)
memory[i] = 32'h00000000;
//writes every location to have a value of 00000000 so then when program runs, nothing has an undefined value

$readmemh("my_prog.hex", memory);

end

endmodule