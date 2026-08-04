# 32-bit Register File (4 × 32) - Verilog

## Overview
This project implements a **4-register, 32-bit Register File** in Verilog HDL.

The design supports:
- 4 registers, each 32 bits wide.
- One write port.
- One read port.
- 2-bit write address.
- 2-bit read address.
- Asynchronous reset.
- Decoder-based register selection.
- Tri-state bus for read operation.

---

## Features

- 32-bit data width
- 4 general-purpose registers
- Synchronous write (positive clock edge)
- Asynchronous active-high reset
- Write Enable (`w_en`)
- Read Enable (`r_en`)
- Separate read and write addresses
- Modular design

---

## Module Hierarchy

```
top_Module_register_file
│
├── decoder (Write Decoder)
├── decoder (Read Decoder)
├── register_32 ×4
├── driver ×4
│
├── and_gate_2in
├── and_gate_3in
├── or_gate
├── xor_gate
└── not_gate
```

---

## Inputs

| Signal | Width | Description |
|---------|-------|-------------|
| clk | 1 | Clock |
| reset_reg | 1 | Asynchronous reset |
| w_data | 32 | Data to write |
| w_addr_0 | 1 | Write address bit 0 |
| w_addr_1 | 1 | Write address bit 1 |
| w_en | 1 | Write enable |
| r_addr_0 | 1 | Read address bit 0 |
| r_addr_1 | 1 | Read address bit 1 |
| r_en | 1 | Read enable |

---

## Output

| Signal | Width | Description |
|---------|-------|-------------|
| r_data | 32 | Data read from the selected register |

---

## Operation

### Write Operation

When:
- `w_en = 1`

the write decoder activates one register according to the write address.

The selected register stores `w_data` on the rising edge of the clock.

---

### Read Operation

When:
- `r_en = 1`

the read decoder enables one driver, allowing only the selected register to drive the shared output bus (`r_data`).

---

### Reset

When `reset_reg` is asserted:

- All registers are cleared to zero immediately.

---

## Files

- `top_Module_register_file.v`
- `decoder.v`
- `register_32.v`
- `driver.v`
- Basic logic gate modules

---

## Simulation

The design has been verified using a Verilog testbench in ModelSim.

---

## Future Improvements

- Increase the number of registers (8, 16, or 32).
- Use parameterized register width.
- Support dual read ports.
- Replace tri-state buses with multiplexers for FPGA implementation.
- Add initialization from memory files.

---

## Author

**Mohamed Mahmoud Atef**

Electronics & Communication Engineering Student

Interested in Digital IC Design, Analog IC Design, and FPGA Design.
