// Description: Program counter to hold byte address of current instruction -> goes by 4 each clock

module program_counter (input wire clock, input wire [31:0] nextPc, output wire [31:0] currentPc);
//creates the clock, the 32-bit value to become current at clock edge, and the 32-bit output that always holds current address

reg [31:0] adrs;
//instantiates a reg to remember the address while clock runs

initial begin
adrs = 32'd0;
end
//starts at instruction 0

always @(posedge clock) begin
adrs <= nextPc;
end
//at each clock edge loads the nextPc instruction into adrs

assign currentPc = adrs;
//currentPc mirrors the adrs at all times, and can't be assigned directly to have nextPc, unless currentPc was a register

endmodule