# Single-Cycle MIPS Processor

## 📌 Project Overview

This project implements a **32-bit Single-Cycle MIPS Processor** based on the MIPS instruction set architecture.

The processor executes each instruction in a **single clock cycle**, with all instructions passing through the required datapath components during that cycle.

The design focuses on understanding how a MIPS processor works internally, including the **datapath, register file, ALU, memories, multiplexers, branch logic, and control unit**.

## 🧩 Supported Instructions

The processor supports the following MIPS instructions:

### R-Type Instructions

* `add`
* `sub`
* `and`
* `or`
* `slt`

### Memory Instructions

* `lw` — Load Word
* `sw` — Store Word

### Branch Instruction

* `beq` — Branch if Equal

## 🏗️ Processor Architecture

The processor consists of the following main components:

* **Program Counter (PC)**
* **Instruction Memory**
* **Register File**
* **ALU**
* **ALU Control**
* **Sign Extension Unit**
* **Data Memory**
* **Multiplexers**
* **Branch Unit**
* **Next PC Logic**
* **Control Unit**

The datapath connects these components together to execute instructions according to their required operation.

## 🔄 Instruction Execution

### 1. Instruction Fetch

The **PC** contains the address of the current instruction.

Since MIPS instructions are 4 bytes long, the next sequential instruction address is:

```text
PC + 4
```

The instruction is then read from the Instruction Memory.

### 2. Register Read

For instructions that use registers, the processor reads the required source registers from the Register File.

The Register File contains:

* 32 registers
* 32-bit data width
* Two read ports
* One write port

### 3. ALU Operation

The ALU performs the required operation depending on the instruction.

Supported ALU operations include:

| ALU Control | Operation |
| ----------- | --------- |
| `000`       | AND       |
| `001`       | OR        |
| `010`       | ADD       |
| `110`       | SUB       |
| `111`       | SLT       |

### 4. Memory Access

For `lw` and `sw`, the ALU calculates the effective memory address by adding the base register value to the sign-extended immediate.

```text
Address = Register + SignExtended Immediate
```

### 5. Write Back

For R-type instructions, the ALU result is written back to the destination register.

For `lw`, the data read from Data Memory is written back to the destination register.

### 6. Branching

For `beq`, the two source registers are compared using subtraction.

If:

```text
ALU Result = 0
```

then the registers are equal and the branch is taken.

The branch target is calculated as:

```text
PC + 4 + (SignExtended Immediate << 2)
```

## 🎛️ Control Unit

The Control Unit generates the control signals required to control the datapath.

Important control signals include:

* `RegDst`
* `RegWrite`
* `ALUSrc`
* `ALUOp`
* `MemWrite`
* `MemRead`
* `MemToReg`
* `PCSrc`

The control signals depend mainly on the instruction opcode and, for R-type instructions, the function field.

## 📊 Control Signals

| Instruction | RegDst | RegWrite | ALUSrc | ALUOp | MemWrite | MemRead | MemToReg |
| ----------- | ------ | -------- | ------ | ----- | -------- | ------- | -------- |
| `add`       | 1      | 1        | 0      | 010   | 0        | 0       | 0        |
| `sub`       | 1      | 1        | 0      | 110   | 0        | 0       | 0        |
| `and`       | 1      | 1        | 0      | 000   | 0        | 0       | 0        |
| `or`        | 1      | 1        | 0      | 001   | 0        | 0       | 0        |
| `slt`       | 1      | 1        | 0      | 111   | 0        | 0       | 0        |
| `lw`        | 0      | 1        | 1      | 010   | 0        | 1       | 1        |
| `sw`        | X      | 0        | 1      | 010   | 1        | 0       | X        |
| `beq`       | X      | 0        | 0      | 110   | 0        | 0       | X        |

For `beq`, the `PCSrc` signal becomes active when the instruction is a branch and the ALU `Zero` output is asserted.

## 🧱 Datapath

The main datapath can be summarized as:

```text
             ┌─────────────┐
             │     PC      │
             └──────┬──────┘
                    │
                    ▼
          ┌──────────────────┐
          │ Instruction      │
          │ Memory           │
          └────────┬─────────┘
                   │
                   ▼
          ┌──────────────────┐
          │ Register File    │
          └───────┬──────────┘
                  │
          ┌───────┴────────┐
          │                │
          ▼                ▼
     Register Data    Sign Extension
          │                │
          │                ▼
          │          ┌───────────┐
          └─────────►│    MUX    │
                     └─────┬─────┘
                           │
                           ▼
                       ┌───────┐
                       │  ALU  │
                       └───┬───┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
         Data Memory              Write Back
                                      │
                                      ▼
                                Register File
```

## 🧪 Simulation and Verification

The processor can be verified by executing different instruction sequences and checking:

* Register values
* ALU results
* Memory read/write operations
* Program Counter updates
* Branch behavior
* Control signal values

A MIPS simulator such as **CPUlator** can also be used to test MIPS assembly programs and compare the expected processor behavior.

## 📚 Learning Objectives

This project provides practical experience with:

* MIPS Instruction Set Architecture
* Single-cycle processor architecture
* Datapath design
* Control Unit design
* ALU and ALU Control
* Register File design
* Instruction and Data Memory
* Multiplexer-based datapath control
* Sign extension
* Branch and PC selection logic
* Hardware implementation of assembly instructions

## 📖 Reference

The project is based on the study of a **Single-Cycle MIPS Processor**, including its datapath, instruction formats, memory system, branching hardware, and control unit.

---

## 👨‍💻 Author

**Mohamed Mahmoud Atef**

Electronics & Communication Engineering Student

### Tools

* Verilog HDL
* ModelSim
* MIPS Assembly
* CPUlator

---
