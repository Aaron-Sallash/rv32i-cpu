// Description: Extracts 12-bit instruction from an I-type instruction, extends to 32-bits

module immediate_gen (input wire [31:0] inst, output wire [31:0] immediate);
//instantiates the 32-bit instruction and the 32-bit immediate output

assign immediate = {{20{inst[31]}}, inst[31:20]};
//takes the top-end bit and copies it 20 times, and combines with the 12-bit original instruciton to make it 32-bits

endmodule