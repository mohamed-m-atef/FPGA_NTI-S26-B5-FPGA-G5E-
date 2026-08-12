# 32-bit Single-Cycle MIPS Processor

## 1. Project Overview

This project implements a simplified **32-bit Single-Cycle MIPS Processor** using **Verilog HDL**.

The processor is designed to demonstrate the fundamental concepts of CPU architecture, including:

* Instruction Fetch
* Instruction Decode
* Register File
* Main Control Unit
* ALU Control Unit
* Arithmetic Logic Unit (ALU)
* Sign Extension
* Data Memory
* Branch Handling
* Jump Handling
* Program Counter (PC)
* Multiplexers
* Next-PC Generation

Each instruction is executed in a **single clock cycle**.

The project was developed as a modular Verilog design where each major CPU component is implemented as an independent module and then integrated inside the `mips_top` module.

---

# 2. Processor Architecture

The processor follows the general architecture of a **Single-Cycle MIPS CPU**.

The basic instruction flow is:

```text
             ┌────────────────────┐
             │   Program Counter  │
             │        (PC)        │
             └─────────┬──────────┘
                       │
                       ▼
             ┌────────────────────┐
             │ Instruction Memory │
             └─────────┬──────────┘
                       │
                       ▼
             ┌────────────────────┐
             │   Main Control     │
             │       Unit         │
             └─────────┬──────────┘
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
 ┌──────────────────┐      ┌──────────────────┐
 │  Register File   │      │   Sign Extend    │
 └────────┬─────────┘      └────────┬─────────┘
          │                         │
          │                         ▼
          │                ┌──────────────────┐
          └───────────────►│      MUX         │
                           │     ALUSrc       │
                           └────────┬─────────┘
                                    │
                                    ▼
                           ┌──────────────────┐
                           │       ALU        │
                           └────────┬─────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
             ┌─────────────┐                 ┌─────────────┐
             │ Data Memory │                 │ Branch Unit │
             └──────┬──────┘                 └──────┬──────┘
                    │                               │
                    └──────────────┬────────────────┘
                                   ▼
                              Next PC Logic
                                   │
                                   ▼
                                   PC
```

---

# 3. Main Modules

The project contains the following major modules:

| Module               | Function                                   |
| -------------------- | ------------------------------------------ |
| `mips_top`           | Top-level CPU integration                  |
| `PC`                 | Stores the current program counter         |
| `Instruction_Memory` | Stores and provides instructions           |
| `Main_Control`       | Generates control signals                  |
| `ALU_Control`        | Determines the ALU operation               |
| `ALU_32`             | Performs arithmetic and logical operations |
| `Register_File`      | Stores 32 general-purpose registers        |
| `Sign_Extend`        | Extends 16-bit immediate values to 32 bits |
| `Data_Memory`        | Stores and retrieves data                  |
| `mux_2x1`            | Generic 2-to-1 multiplexer                 |
| `ALU_adder`          | Performs 32-bit addition                   |
| `Shift_Left_2`       | Shifts branch offset left by 2             |
| `Branch_Unit`        | Determines whether a branch is taken       |

---

# 4. Top-Level Module

## `mips_top`

The `mips_top` module connects all processor components together.

### Inputs

```verilog
input wire CLK
input wire RST
```

* `CLK`: Processor clock.
* `RST`: Reset signal.

### Main Responsibilities

The top-level module:

1. Fetches the instruction.
2. Decodes the instruction.
3. Reads the required registers.
4. Generates the immediate value.
5. Selects the second ALU operand.
6. Performs the ALU operation.
7. Accesses data memory when required.
8. Selects the value written back to the register file.
9. Calculates branch addresses.
10. Calculates jump addresses.
11. Selects the next PC value.

---

# 5. Program Counter

## `PC`

The Program Counter stores the address of the current instruction.

```verilog
module PC (
    input wire clk,
    input wire reset,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);
```

The PC is updated on the rising edge of the clock.

When reset is asserted:

```text
PC = 0
```

Otherwise:

```text
PC = PC_next
```

The processor therefore follows:

```text
PC → Instruction Memory → Next PC
```

---

# 6. Instruction Memory

## `Instruction_Memory`

The instruction memory is implemented as a 64-word ROM-like memory.

```verilog
reg [31:0] mem [0:63];
```

Each memory location stores one 32-bit instruction.

The instruction is accessed using:

```verilog
assign instruction = mem[pc_addr[31:2]];
```

The PC is shifted right by two bits because MIPS instructions are **word aligned**.

For example:

```text
PC = 0   → memory[0]
PC = 4   → memory[1]
PC = 8   → memory[2]
PC = 12  → memory[3]
```

---

# 7. Instructions Implemented

The instruction memory contains sample MIPS instructions.

## LW

```assembly
lw $t0, 0($zero)
```

Machine code:

```text
8C080000
```

Purpose:

```text
$t0 = Memory[0]
```

---

## SW

```assembly
sw $t0, 4($zero)
```

Machine code:

```text
AC080004
```

Purpose:

```text
Memory[4] = $t0
```

---

## ADD

```assembly
add $t2, $t0, $t1
```

Machine code:

```text
01095020
```

Operation:

```text
$t2 = $t0 + $t1
```

---

## SUB

```assembly
sub $t3, $t1, $t0
```

Machine code:

```text
01285822
```

Operation:

```text
$t3 = $t1 - $t0
```

---

## AND

```assembly
and $t4, $t0, $t1
```

Machine code:

```text
01096024
```

Operation:

```text
$t4 = $t0 & $t1
```

---

## OR

```assembly
or $t5, $t0, $t1
```

Machine code:

```text
01096825
```

Operation:

```text
$t5 = $t0 | $t1
```

---

## SLT

```assembly
slt $t6, $t0, $t1
```

Machine code:

```text
0109702A
```

Operation:

```text
$t6 = ($t0 < $t1) ? 1 : 0
```

The implementation uses signed comparison.

---

## BEQ

```assembly
beq $t0, $t0, +2
```

Machine code:

```text
11080002
```

The branch is taken when:

```text
$t0 == $t0
```

Since both operands are equal, the ALU produces zero during subtraction.

---

## JUMP

```assembly
j 12
```

Machine code:

```text
0800000C
```

The processor constructs the jump target using:

```verilog
assign jump_address =
{
    ALU_adder_out_one[31:28],
    instruction[25:0],
    2'b00
};
```

---

# 8. Register File

## `Register_File`

The register file contains:

```text
32 registers × 32 bits
```

Declaration:

```verilog
reg [31:0] registers [0:31];
```

There are two asynchronous read ports:

```text
Read_Reg1 → Read_Data1
Read_Reg2 → Read_Data2
```

and one synchronous write port:

```text
Write_Reg
Write_Data
RegWrite
```

### Register Write

A register is written on the rising clock edge:

```verilog
if (RegWrite && Write_Reg != 0)
    registers[Write_Reg] <= Write_Data;
```

Register `$zero` is protected and cannot be modified.

Therefore:

```text
$zero = 0
```

---

# 9. Main Control Unit

## `Main_Control`

The Main Control Unit receives the 6-bit opcode:

```verilog
input wire [5:0] instruction
```

and generates the processor control signals.

### Control Signals

| Signal     | Function                                    |
| ---------- | ------------------------------------------- |
| `RegDst`   | Selects destination register                |
| `Branch`   | Enables branch operation                    |
| `MemRead`  | Enables memory read                         |
| `MemtoReg` | Selects memory data for register write-back |
| `ALUOP`    | Determines ALU operation type               |
| `MemWrite` | Enables memory write                        |
| `ALUSrc`   | Selects ALU second operand                  |
| `RegWrite` | Enables register write                      |
| `jump`     | Enables jump                                |

---

# 10. Main Control Truth Table

| Instruction | RegDst | Branch | MemRead | MemtoReg | ALUOp | MemWrite | ALUSrc | RegWrite | Jump |
| ----------- | -----: | -----: | ------: | -------: | ----- | -------: | -----: | -------: | ---: |
| R-Type      |      1 |      0 |       0 |        0 | 10    |        0 |      0 |        1 |    0 |
| BEQ         |      0 |      1 |       0 |        0 | 01    |        0 |      0 |        0 |    0 |
| J           |      0 |      0 |       0 |        0 | 00    |        0 |      0 |        0 |    1 |
| LW          |      0 |      0 |       1 |        1 | 00    |        0 |      1 |        1 |    0 |
| SW          |      0 |      0 |       0 |        0 | 00    |        1 |      1 |        0 |    0 |

---

# 11. ALU Control

## `ALU_Control`

The ALU Control Unit receives:

```text
ALUOp
funct
```

and generates:

```text
ALUControl
```

For R-Type instructions, the `funct` field determines the exact operation.

### ALU Control Table

| Operation | ALUControl |
| --------- | ---------- |
| AND       | `000`      |
| OR        | `001`      |
| ADD       | `010`      |
| SUB       | `110`      |
| SLT       | `111`      |

### ALUOp Meaning

```text
ALUOp = 00 → ADD
ALUOp = 01 → SUB
ALUOp = 10 → R-Type → decode funct
```

This allows the processor to use the same ALU for multiple instruction types.

---

# 12. ALU

## `ALU_32`

The ALU performs the main arithmetic and logical operations.

### Inputs

```text
A
B
ALUControl
```

### Outputs

```text
out
Zero
```

Supported operations:

```text
AND
OR
ADD
SUB
SLT
```

### Zero Flag

The Zero output is generated using:

```verilog
assign Zero = (out == 32'b0);
```

Therefore:

```text
out = 0 → Zero = 1
out ≠ 0 → Zero = 0
```

The Zero flag is especially important for the `BEQ` instruction.

---

# 13. Branch Unit

## `Branch_Unit`

The Branch Unit determines whether a branch should be taken.

```verilog
assign Branch_Result = Branch & Zero;
```

Therefore:

```text
Branch = 1
AND
Zero = 1
```

results in:

```text
Branch_Result = 1
```

For `BEQ`:

```text
A - B = 0
```

means:

```text
A = B
```

so the branch is taken.

---

# 14. Sign Extension

## `Sign_Extend`

MIPS immediate fields are 16 bits, while the processor uses 32-bit data.

The Sign Extend module converts:

```text
16-bit immediate
```

into:

```text
32-bit signed value
```

Implementation:

```verilog
assign extended =
    {{16{immediate[15]}}, immediate};
```

The most significant bit of the immediate is replicated.

Example:

```text
Immediate = 0000 0000 0000 0101

Extended = 0000 0000 0000 0000 0000 0000 0000 0101
```

For negative values:

```text
Immediate = 1111 1111 1111 1100

Extended = 1111 1111 1111 1111 1111 1111 1111 1100
```

---

# 15. ALUSrc Multiplexer

The ALU needs two operands.

The first operand comes from:

```text
Read_Data1
```

The second operand can be either:

```text
Read_Data2
```

or:

```text
Sign-Extended Immediate
```

This is controlled by `ALUSrc`.

```text
ALUSrc = 0 → Register Data
ALUSrc = 1 → Immediate
```

This is necessary for instructions such as `LW` and `SW`.

---

# 16. Data Memory

## `Data_Memory`

The data memory contains:

```text
256 words × 32 bits
```

Declaration:

```verilog
reg [31:0] memory [0:255];
```

Initially:

```text
Memory[0] = 10
```

### Memory Read

Read operation is combinational:

```text
MemRead = 1
        ↓
read_data = memory[address]
```

### Memory Write

Write operation occurs on the rising edge of the clock:

```verilog
if (mem_write)
    memory[address[31:2]] <= write_data;
```

---

# 17. Memory Addressing

Because each word is 32 bits:

```text
32 bits = 4 bytes
```

the lower two address bits are ignored.

Therefore:

```verilog
address[31:2]
```

is used as the memory index.

For example:

| Address | Memory Index |
| ------: | -----------: |
|       0 |            0 |
|       4 |            1 |
|       8 |            2 |
|      12 |            3 |

---

# 18. Write-Back MUX

After the ALU or Data Memory produces a result, the processor needs to determine what value should be written into the register file.

The `MemtoReg` signal controls this multiplexer.

```text
MemtoReg = 0
    ↓
ALU result

MemtoReg = 1
    ↓
Data Memory result
```

Therefore:

### R-Type

```text
Register ← ALU result
```

### LW

```text
Register ← Data Memory
```

---

# 19. RegDst MUX

The destination register depends on the instruction type.

For R-Type instructions:

```text
Destination = instruction[15:11]
```

For LW:

```text
Destination = instruction[20:16]
```

The `RegDst` signal selects between them.

```text
RegDst = 0 → rt
RegDst = 1 → rd
```

---

# 20. Branch Address Calculation

For a branch instruction, the target address is:

```text
PC + 4 + (SignExtended Immediate << 2)
```

The processor first calculates:

```text
PC + 4
```

using `ALU_adder_one`.

Then the immediate is shifted left by 2:

```text
extended_shifted = extended_instruction << 2
```

Finally:

```text
Branch Target =
    PC + 4 + extended_shifted
```

This calculation is performed by `ALU_adder_Two`.

---

# 21. Jump Address Calculation

For a MIPS jump instruction, the target address is constructed using:

```text
PC + 4 upper 4 bits
+
26-bit instruction index
+
00
```

Implementation:

```verilog
assign jump_address =
{
    ALU_adder_out_one[31:28],
    instruction[25:0],
    2'b00
};
```

This produces the final 32-bit jump address.

---

# 22. Next PC Logic

The processor has three possible sources for the next PC:

### Normal Execution

```text
PC + 4
```

### Branch

```text
PC + 4 + Branch Offset
```

### Jump

```text
Jump Target
```

The selection is performed using two multiplexers.

First:

```text
Branch_Result = 0 → PC + 4
Branch_Result = 1 → Branch Target
```

Then:

```text
jump = 0 → Branch/PC+4 result
jump = 1 → Jump Address
```

Therefore:

```text
                ┌──────────────┐
PC + 4 ────────►│              │
                │ Branch MUX   ├─────┐
Branch Target ─►│              │     │
                └──────────────┘     ▼
                              ┌──────────────┐
                              │   Jump MUX   ├──► Next PC
Jump Target ─────────────────►│              │
                              └──────────────┘
```

---

# 23. Complete Instruction Execution

## R-Type Instruction

Example:

```assembly
add $t2, $t0, $t1
```

Execution:

```text
1. Fetch instruction
2. Decode opcode = 000000
3. Main Control selects R-Type
4. Register File reads $t0 and $t1
5. ALU Control decodes funct = 100000
6. ALU performs ADD
7. RegDst selects rd
8. MemtoReg selects ALU result
9. RegWrite stores result in $t2
10. PC becomes PC + 4
```

---

# 24. LW Instruction Execution

Example:

```assembly
lw $t0, 0($zero)
```

Execution:

```text
1. Fetch instruction
2. Decode opcode = 100011
3. Read base register $zero
4. Sign-extend immediate
5. ALUSrc selects immediate
6. ALU performs addition
7. Address is generated
8. Data Memory performs read
9. MemtoReg selects memory data
10. RegWrite writes data into $t0
11. PC becomes PC + 4
```

---

# 25. SW Instruction Execution

Example:

```assembly
sw $t0, 4($zero)
```

Execution:

```text
1. Fetch instruction
2. Decode opcode = 101011
3. Read $zero and $t0
4. Sign-extend immediate
5. ALUSrc selects immediate
6. ALU calculates address
7. Data Memory receives $t0
8. Memory writes data on clock edge
9. No register write occurs
10. PC becomes PC + 4
```

---

# 26. BEQ Instruction Execution

Example:

```assembly
beq $t0, $t0, +2
```

Execution:

```text
1. Fetch instruction
2. Decode opcode = 000100
3. Read both registers
4. ALU performs subtraction
5. If result = 0 → Zero = 1
6. Branch Unit calculates Branch_Result
7. Branch target is calculated
8. Branch MUX selects target
9. PC is updated
```

The branch condition is:

```text
Branch_Result = Branch AND Zero
```

---

# 27. Jump Instruction Execution

Example:

```assembly
j 12
```

Execution:

```text
1. Fetch instruction
2. Decode opcode = 000010
3. Main Control sets jump = 1
4. Jump target is constructed
5. Jump MUX selects jump address
6. PC is updated with jump target
```

---

# 28. MIPS Instruction Formats

The processor uses the standard MIPS instruction formats.

## R-Type

```text
31        26 25    21 20    16 15    11 10     6 5      0
+-----------+--------+--------+--------+--------+--------+
|   opcode  |   rs   |   rt   |   rd   | shamt  | funct  |
+-----------+--------+--------+--------+--------+--------+
```

Used for:

```text
ADD
SUB
AND
OR
SLT
```

---

## I-Type

```text
31        26 25    21 20    16 15                    0
+-----------+--------+--------+------------------------+
|   opcode  |   rs   |   rt   |       immediate        |
+-----------+--------+--------+------------------------+
```

Used for:

```text
LW
SW
BEQ
```

---

## J-Type

```text
31        26 25                                  0
+-----------+-------------------------------------+
|   opcode  |             address                 |
+-----------+-------------------------------------+
```

Used for:

```text
J
```

---

# 29. Control and Datapath Interaction

The processor can be divided into two major sections.

## Datapath

Responsible for moving and processing data.

Includes:

```text
PC
Instruction Memory
Register File
MUXes
Sign Extend
ALU
Data Memory
Adders
```

## Control Path

Responsible for generating control signals.

Includes:

```text
Main Control
ALU Control
Branch Unit
```

The two paths work together to execute each instruction.

---

# 30. Example Control Flow

For an R-Type instruction:

```text
Instruction
     │
     ▼
Main Control
     │
     ├── RegDst = 1
     ├── RegWrite = 1
     └── ALUOp = 10
              │
              ▼
         ALU Control
              │
              ▼
            ALU
              │
              ▼
        Write Back
```

For `LW`:

```text
Instruction
     │
     ▼
Main Control
     │
     ├── ALUSrc = 1
     ├── MemRead = 1
     ├── MemtoReg = 1
     └── RegWrite = 1
              │
              ▼
             ALU
              │
              ▼
         Data Memory
              │
              ▼
         Write Back
```

---

# 31. Instruction Set Supported

The current processor supports the following instructions:

| Instruction | Type | Operation        |
| ----------- | ---- | ---------------- |
| ADD         | R    | `rd = rs + rt`   |
| SUB         | R    | `rd = rs - rt`   |
| AND         | R    | `rd = rs & rt`   |
| OR          | R    | `rd = rs \| rt`  |
| SLT         | R    | `rd = (rs < rt)` |
| LW          | I    | Load word        |
| SW          | I    | Store word       |
| BEQ         | I    | Branch if equal  |
| J           | J    | Jump             |

---

# 32. Hardware Resources

The design contains:

```text
32 × 32-bit Register File
64 × 32-bit Instruction Memory
256 × 32-bit Data Memory
32-bit ALU
32-bit PC
32-bit Adders
32-bit Multiplexers
Control Units
Branch Logic
```

---

# 33. Clocking

The design uses a single clock signal:

```verilog
CLK
```

Sequential elements are updated on:

```verilog
posedge CLK
```

The main sequential components are:

* Program Counter
* Register File
* Data Memory write operation

Combinational components continuously calculate their outputs based on the current inputs.

---

# 34. Reset

The processor uses an active-high reset:

```verilog
RST
```

When reset is asserted:

```text
PC = 0
Register File = 0
```

The Instruction Memory and Data Memory are initialized using Verilog `initial` blocks.

---

# 35. Project Directory Recommendation

A clean project structure can be:

```text
MIPS-Processor/
│
├── README.md
│
├── src/
│   ├── mips_top.v
│   ├── PC.v
│   ├── Instruction_Memory.v
│   ├── Register_File.v
│   ├── Main_Control.v
│   ├── ALU_Control.v
│   ├── ALU_32.v
│   ├── Sign_Extend.v
│   ├── Data_Memory.v
│   ├── Branch_Unit.v
│   ├── mux_2x1.v
│   ├── ALU_adder.v
│   └── Shift_Left_2.v
│
├── testbench/
│   └── mips_top_tb.v
│
├── simulation/
│
└── docs/
    └── architecture.png
```

---

# 36. Simulation

The processor can be simulated using HDL simulation tools such as:

* ModelSim
* QuestaSim
* Vivado Simulator
* Icarus Verilog
* Verilator

The simulation should verify:

```text
PC behavior
Instruction fetching
Register operations
ALU operations
Memory read
Memory write
Branch behavior
Jump behavior
Reset behavior
```

---

# 37. Recommended Test Cases

## Test Case 1 — Reset

Expected:

```text
PC = 0
All registers = 0
```

---

## Test Case 2 — LW

Instruction:

```assembly
lw $t0, 0($zero)
```

Initial:

```text
Memory[0] = 10
```

Expected:

```text
$t0 = 10
```

---

## Test Case 3 — ADD

Instruction:

```assembly
add $t2, $t0, $t1
```

If:

```text
$t0 = 10
$t1 = 5
```

Expected:

```text
$t2 = 15
```

---

## Test Case 4 — SUB

If:

```text
$t1 = 5
$t0 = 10
```

Instruction:

```assembly
sub $t3, $t1, $t0
```

Expected:

```text
$t3 = -5
```

In 32-bit two's complement:

```text
FFFFFFFB
```

---

## Test Case 5 — AND

If:

```text
$t0 = 1010
$t1 = 1100
```

Expected:

```text
$t4 = 1000
```

---

## Test Case 6 — OR

If:

```text
$t0 = 1010
$t1 = 1100
```

Expected:

```text
$t5 = 1110
```

---

## Test Case 7 — SLT

If:

```text
$t0 = 5
$t1 = 10
```

Expected:

```text
$t6 = 1
```

---

## Test Case 8 — BEQ

If:

```text
$t0 = $t0
```

Expected:

```text
Zero = 1
Branch_Result = 1
```

Therefore the branch target should be selected.

---

## Test Case 9 — Jump

For:

```assembly
j 12
```

Expected:

```text
PC = jump_address
```

---

# 38. Design Characteristics

The processor is:

```text
Architecture: MIPS
Data Width: 32-bit
Execution: Single-Cycle
HDL: Verilog
Instruction Memory: 64 × 32-bit
Data Memory: 256 × 32-bit
Registers: 32 × 32-bit
```

---

# 39. Advantages of the Design

This project demonstrates several important digital design concepts:

* Modular Verilog design
* CPU datapath design
* Control signal generation
* ALU implementation
* Register file design
* Memory design
* Multiplexer usage
* Branch logic
* Jump logic
* Instruction decoding
* Synchronous digital design
* Combinational logic
* Sequential logic

It also provides a foundation for more advanced processor designs.

---

# 40. Possible Future Improvements

The processor can be extended by adding:

### More MIPS Instructions

For example:

```text
ADDI
ANDI
ORI
BNE
JAL
JR
```

### More Memory Instructions

```text
LB
SB
LH
SH
```

### Hardware Division and Multiplication

```text
MULT
DIV
```

### Pipeline Architecture

The single-cycle architecture could be upgraded to:

```text
IF
ID
EX
MEM
WB
```

creating a **5-stage pipelined MIPS processor**.

### Hazard Detection

A pipelined version could include:

```text
Forwarding Unit
Hazard Detection Unit
Stall Logic
```

### Better Memory Initialization

Instruction and data memory could be loaded from external files using:

```verilog
$readmemh()
```

instead of hard-coding instructions inside the module.

---

# 41. Conclusion

This project implements a functional **32-bit Single-Cycle MIPS Processor** using Verilog HDL.

The processor integrates the essential components of a CPU:

```text
Program Counter
       ↓
Instruction Memory
       ↓
Control Unit
       ↓
Register File
       ↓
ALU
       ↓
Data Memory
       ↓
Write Back
       ↓
Next PC
```

The design supports fundamental MIPS instructions including:

```text
ADD
SUB
AND
OR
SLT
LW
SW
BEQ
J
```

The project demonstrates how a complete processor can be constructed from smaller digital modules and how the datapath and control path cooperate to execute instructions.

It can serve as a foundation for developing more advanced processors, including pipelined MIPS architectures and eventually more complex CPU designs.
