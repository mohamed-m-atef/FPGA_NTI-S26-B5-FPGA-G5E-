# 1-Bit ALU Design in Verilog

## Overview

This project implements a **1-Bit Arithmetic Logic Unit (ALU)** using **Verilog HDL**. It was developed as a mini project while learning digital design and Verilog.

The primary goal of this project was **learning and practicing different Verilog design styles** rather than creating the most optimized implementation. I intentionally tried to use most of the concepts I learned throughout my Verilog course, including:

* Structural modeling
* Dataflow modeling
* Module hierarchy
* Gate-level design
* Decoder-based control logic
* Modular design

Because of this educational objective, some parts of the design do not strictly rely on the previously created gate modules and instead use Verilog operators directly where appropriate.

---

# Features

The ALU supports four operations selected using two control bits (`f1`, `f0`).

|  f1 |  f0 | Operation             |
| :-: | :-: | --------------------- |
|  0  |  0  | AND                   |
|  0  |  1  | OR                    |
|  1  |  0  | NOT B                 |
|  1  |  1  | Addition (Full Adder) |

Inputs:

* `A`
* `B`
* `Cin`
* `f1`
* `f0`

Outputs:

* `result`
* `Cout`

---

# Project Structure

```
├── and_gate.v
├── or_gate.v
├── xor_gate.v
├── not_gate.v
├── decoder.v
├── logic_unit.v
├── full_adder.v
├── Top_module_ALU_1_bit.v
└── testbench.v
```

---

# Module Description

## Basic Logic Gates

The project starts with reusable gate modules:

* AND Gate
* OR Gate
* XOR Gate
* NOT Gate

These modules were created mainly for practicing hierarchical structural design.

---

## Decoder

The decoder converts the two function select inputs (`f0`, `f1`) into four control signals.

```
00 → AND
01 → OR
10 → NOT
11 → ADD
```

Only one control signal becomes active at a time.

---

## Logic Unit

The Logic Unit performs the logical operations:

* AND
* OR
* NOT (on input B)

Each operation is enabled through the decoder outputs.

---

## Full Adder

The Full Adder performs one-bit addition using:

* A
* B
* Carry In

It generates:

* Sum
* Carry Out

The adder is only enabled when the decoder selects the ADD operation.

---

## Top Module

The top module connects:

* Decoder
* Logic Unit
* Full Adder

Finally, the selected operation is forwarded to the output `result`.

---

# Design Methodology

This project intentionally combines multiple Verilog design techniques.

Some modules are implemented structurally using reusable gate modules, while other parts use direct Verilog operators (`assign`, `&`, `|`, `^`, `~`) to demonstrate different implementation styles learned during the course.

The objective was to gain practical experience with various Verilog modeling approaches instead of focusing solely on hardware optimization.

---

# Simulation

The design was verified using a Verilog testbench by applying different combinations of:

* A
* B
* Cin
* f0
* f1

The simulation confirms that the ALU correctly performs all four supported operations.

---

# Learning Outcomes

Through this project, I practiced:

* Hierarchical module design
* Structural Verilog
* Dataflow Verilog
* Gate-level implementation
* Decoder-based control
* Modular circuit organization
* Building and testing a complete digital system

---

# Future Improvements

Possible enhancements include:

* Expanding the design to a 4-bit or 8-bit ALU.
* Supporting additional arithmetic and logical operations.
* Optimizing the design to reduce hardware resources.
* Creating a more comprehensive verification environment with automated test cases.

---

# Notes

This project was developed as part of my Verilog learning journey. The implementation intentionally demonstrates multiple design styles and coding techniques for educational purposes rather than aiming for the smallest or most optimized hardware implementation.
