// Description: Instruction decoder for rv32i R-type instructions

module control_unit (input wire [6:0] instrClass, input wire [2:0] opFam, input wire opBit, output reg [3:0] aluControl, output wire regWr);

//instrClass is 7-bit input that decides what instruction class the instruction is in

//opFam is 3-bit input that decides if the instruction is a certain instruction family

//opBit is 1-bit input that decides if its add or sub only if opFam is add/sub family since it is mapped to 000

//aluControl is 3-bit output that decides what instruction is sent to alu

//regWr is 1-bit output that decides if the output instruction gets actually saved to register (1 if yes)

assign regWr = (instrClass == 7'b0110011);

//assigns regWr to if instrClass is equal to an R-type instruction 

always @(*) begin
if (instrClass == 7'b0110011) begin
//if instrClass is R-type, decode the operation family

case ({opBit, opFam})
4'b0_000: aluControl = 4'b0000;
4'b1_000: aluControl = 4'b0001;
4'b0_111: aluControl = 4'b0010;
4'b0_110: aluControl = 4'b0011;
4'b0_100: aluControl = 4'b0100;
default: aluControl = 4'b0000;

//add, sub, and, or, xor, unknown operation(outputs add if unknown operation is passed in)

endcase

end else begin

aluControl = 4'b0000;

end

end

endmodule