// Description: 32x32-bit Register File for RV32I Processor

module regFile (input wire clk, input wire WrEn, input wire [4:0] r1, 
input wire [4:0] r2, input wire [4:0] rd, input wire [31:0] wd, 
output wire [31:0] rd1, output wire [31:0] rd2);

//clk is 1-bit pulse that signals on and off as 1 and 0; new data only is written on switch from 0 to 1

//WrEn is write enable switch, a 1-bit control from control unit, decides if data from input wd should be saved to rd 

//r1 and r2 are 5-bit wires to select a specific register and get whatever 32-bit value is stored there

//rd is a 5-bit wire that specifies which register will receive the calculated answer

reg [31:0] regs [0:31];
//creates 32 registers each 32 bits wide

assign rd1 = (r1 == 5'd0) ? 32'b0 : regs[r1];
assign rd2 = (r2 == 5'd0) ? 32'b0 : regs[r2];
//if r1 or r2 are 5 bit decimal 0, then return 32 bits of 0s; if not, then output whatever value reg is at r1 or r2 to these wires

always @(posedge clk) begin
//Runs only at the clocks rising edge (0-1)
    
if (WrEn && rd != 5'd0)
//Checks if write enable switch is 1 from control unit, and if the register is not x0
        
regs[rd] <= wd;
//Since in a clocked block (rising edge), <= is used to assign the register slot the wd 32-bit value from ALU or memory, <= is used to prevent sequential assigning that = would, instantly committing updates at each rising clock edge

end

endmodule

