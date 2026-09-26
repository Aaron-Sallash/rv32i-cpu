# rv32i-cpu

## Research Question
How does increasing the depth of pipeline stages in a RISC-V processor impact its instructions per cycle rate and power consumption?

## Abstract
This project utilizes a 32-bit RISC-V processor in Verilog, progressing through first a single-cycle design, then a 3-stage pipelined design. Through cycle-accurate simulation, I compare instruction throughput and architectural tradeoffs. As processors have become increasingly relevant, especially with recent hardware needs for AI development, understanding these architectural tradeoffs has great significance for hardware design.

## Current Status
[x] Project initialized
[x] ALU Created - add, sub, and, or, xor, slt; zero flag
[x] Register File - 32 x 32-bit, verified through 4 testbench tests
[ ] Control unit
[ ] Datapath assembly
[ ] Single-cycle benchmark runs
[ ] 3-stage pipelined variant runs
[ ] Throughput comparison and conclusions

## Repository Structure
- `src/` - Verilog source files for CPU components
- `testbenches/` - Testbench files for each component's verification
- `benchmarks/` - Benchmark programs and experimental result data (planned)
- `docs/` - Research and simulation results

## Tools Used
Icarus Verilog (simulated)
GTKWave (visualization of waveforms)

## References
[1] S. Harris and D. Harris, *Digital Design and Computer 
Architecture: RISC-V Edition*. Cambridge, MA: Morgan 
Kaufmann, 2021.

[2] RISC-V International, "The RISC-V Instruction Set 
Manual, Volume I: Unprivileged ISA," 
Jan. 2026. [Online]. Available: https://riscv.org/technical/specifications/

## Methodology
Two processor variants are implemented in Verilog: a single-cycle design and a 3-stage pipelined desingn. Each variant executes identical benchmark programs designed to stress arithmetic operations, memory access, and branch instructions. Instructions per cycle is measured through cycle-accurate simulation. In the future, power consumption is planned to be estimated through Vivado's power analysis for the variants under identical workloads, which allows for direct comparison of architectural efficiency tradeoffs.