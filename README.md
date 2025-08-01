# ECE 310 – Serial BCD Adder/Subtractor (Verilog)

This repository contains my final project for ECE 310: Design of Complex Digital Systems at NC State University, completed in Spring 2025. The goal was to build a **serial binary-coded decimal (BCD) arithmetic unit** in Verilog, capable of performing addition and subtraction on multi-digit decimal values transmitted over a single-bit data stream.

## Project Description

The module receives a 41-bit packet serially:
- `8-bit header (0xA5)`
- `1-bit opcode (0 = add, 1 = subtract)`
- `16-bit operand A`
- `16-bit operand B`

It performs the selected operation (add or subtract) using parallel BCD arithmetic, then outputs the result in a 28-bit packet:
- `8-bit header (0x96)`
- `5-digit BCD result` serialized using a PISO shift register

## Features

- **Bit-serial packet reception** using 41-bit SIPO
- **Header detection** for packet alignment
- **1-digit BCD adder module** with +6 correction logic
- **4-digit BCD adder chain** for full operand handling
- **9’s complement logic** for subtraction support
- **Operation decoding** and control FSM
- **Result serialization** using 28-bit PISO module
- **Comprehensive simulation** using ModelSim and 64 test vectors
- **RTL synthesis** with successful timing analysis

## Tools Used

- **Verilog**
- **ModelSim** for simulation and waveform analysis
- **Vivado** for synthesis and timing analysis
- **Text-based testbench** for verifying edge cases

## File Structure

- `Project3.v` – Top-level design with FSM, datapath, I/O logic
- `Project3_Report.pdf` – Full design explanation and results

## Key Outcomes

- Designed a full datapath and control architecture for packet-based decimal arithmetic
- Verified behavioral and synthesized correctness via simulation and analysis tools
- Demonstrated modular RTL development using best practices (FSM, SIPO/PISO, clean module hierarchy)
