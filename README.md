# RISC-V SoC

Fully-functional RISC-V SoC designed using SystemVerilog

# Table of Contents

1. [Project Features](#features)
2. [Example Programs](#examples)
    - [Hello World (Zync-7000 board)](#hello-world)
3. [Future Features](#future-features)

<a name="features"></a>

# Project Features

- [:heavy_check_mark:] Five-stage pipeline.
- [:heavy_check_mark:] Native Memory-mapped IO*

\*This is hardware-dependent. Right now, only 4 seven-segment displays (common-cathode) are mapped. I plan to add other IO devices supported on different types of FPGAs.

<a name="examples"></a>

# Example Programs

Here are some example programs that currently run on the SoC:

<a name="hello-world"></a>

## Hello World (Xilinx Blackboard)

![hello-demo](./examples/hello%20world/hello2you.gif)

This program demonstrates basic RV32I instructions as well as the memory-mapped IO present on the SoC. Four seven-segment displays are mapped to address 0x400 with each display using 8 bits (7 segments + 1 decimal point). This allows the entire set of displays to fit in one 32-bit word.

Each "frame" contains data for the state of all 4 displays packed into a 32-bit word. All frames are precalculated and are stored in order in this [coefficient file](./examples/hello%20world/hello_mem.coe). They are then written to the FPGA block RAM.

The source code can be found [here](./examples/hello%20world/hello.s). It is written in Assembly, and uses a nested for-loop for the delay between each "frame."  
The resulting machine code is only 20 instructions and can be found [here](./examples/hello%20world/hello_code.mem)

<a name="future-features"></a>

# Future Features

- [ ] Multiplication and division instructions.
- [ ] System-calls and exceptions.
- [ ] CPU cache.
- [ ] Support for [Egos-2000](https://github.com/yhzhang0128/egos-2000) operating system.
- [ ] RV32M and RV32A implementation.