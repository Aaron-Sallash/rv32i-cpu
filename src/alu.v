// Description: 32-bit Arithmetic Logic Unit for RV32I Processor

module alu (input wire[31:0] a, input wire[31:0] b, 
input wire[3:0] aluControl, output reg [31:0] result, output wire zero);

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
        
        4'b0000: result = a + b;
        4'b0001: result = a - b;
        4'b0010: result = a & b;
        4'b0011: result = a | b;
        4'b0100: result = a ^ b;
        default: result = 32'b0;
        //outputs 0 if aluControl is unexpected binary
    
    endcase

end
