// Description: 32-bit Arithmetic Logic Unit for rv32i Processor

module alu (input wire[31:0] bWireA, input wire[31:0] bWireB, 
input wire[3:0] aluControl, output reg [31:0] outP, output wire zero);

//first two inputs create 32-bit wide binary wires
//third input provides 4-bit operation code from Control Unit
//first output is the 32-bit output created by the alu
//second output is the 1-bit status flag (outputs 1 if result is 0)

//Zero FLag Generation (BEQ instruction)

assign zero = (result == 32'b0);
//actually checks the current 32-bit result

//Math and Logic Selector (Combinational Block)

always @(*) begin 
    //runs the specific operator whenever any input changes
    
    case (aluControl)
        //checks the aluControl to see which operation to run
        
        4'b0000: outP = a + b;
        4'b0001: outP = a - b;
        4'b0010: outP = a & b;
        4'b0011: outP = a | b;
        4'b0100: outP = a ^ b;
        default: outP = 32'b0;
        //outputs 0 if aluControl is unexpected binary
    
    endcase

end
