// Description: 32x32-bit Register File for rv32i Processor

module regFile (input wire clock, input wire writeE, input wire [4:0] regSel1, 
input wire [4:0] regSel2, input wire [4:0] regOut, input wire [31:0] inP, 
output wire [31:0] outP1, output wire [31:0] outP2);

//clock is 1-bit pulse that signals on and off as 1 and 0; new data only is written on switch from 0 to 1

//writeE is write enable switch, a 1-bit control from control unit, decides if data from input(inP) should be saved to regOut 

//regSel1 and regSel2 are 5-bit wires to select a specific register location and get whatever 32-bit value is stored there

//regOut is a 5-bit wire that specifies which register will receive the calculated answer

//outP1 and outP2 are outputted operand input values
//inP is inputted value into the registers, or the value that gets put into certain registers

reg [31:0] regs [0:31];
//creates 32 registers each 32 bits wide

assign outP1 = (regSel1 == 5'd0) ? 32'b0 : regs[regSel1];
assign outP2 = (regSel2 == 5'd0) ? 32'b0 : regs[regSel2];
//if regSel1 or regSel2 are 5 bit decimal 0, then return 32 bits of 0s; if not, then output whatever value reg is at regSel1 or regSel2 to these wires

always @(posedge clock) begin
//Runs only at the clocks rising edge (0-1)
    
if (writeE && regOut != 5'd0)
//Checks if write enable switch is 1 from control unit, and if the register is not x0
        
regs[regOut] <= inP;
//Since in a rising edge, <= is used to assign the register slot the wd 32-bit value from ALU or memory, <= is used to prevent sequential assigning that = would, instantly committing updates at each rising clock edge

end

endmodule