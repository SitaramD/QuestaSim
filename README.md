# MUX2_1 — 4-bit 2-to-1 Multiplexer

A 4-bit wide 2-to-1 multiplexer written in Verilog, verified with an exhaustive self-checking testbench in QuestaSim.

The multiplexer is the most basic "decision" element in digital hardware. Every `if`, `case` or `? :` you write in RTL ends up as one or more muxes in silicon, so it's a good first block for learning how code turns into hardware, and how to verify it properly.

---

## Function

```
        S
        │
   A ──►┌─────┐
        │ MUX ├──► Z        Z = (S == 0) ? A : B
   B ──►└─────┘
```

| S | Z |
|---|---|
| 0 | A |
| 1 | B |

### Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `A`  | input  | 4 | Data input, selected when `S = 0` |
| `B`  | input  | 4 | Data input, selected when `S = 1` |
| `S`  | input  | 1 | Select line |
| `Z`  | output | 4 | Selected data |

Purely combinational: no clock, no reset, no state.

---

## Files

| File | Description |
|------|-------------|
| `Mux_2to1.v` | RTL — behavioural model using `always @(*)` + `assign` |
| `tb_Mux_2to1.v` | Self-checking testbench, all 512 combinations of A, B, S |
| `run.do` | QuestaSim script: compile, simulate, add waves |
| `.gitignore` | Keeps simulator output (`work/`, `*.wlf`, `transcript`) out of the repo |

---

## How to run

### QuestaSim GUI

In the Transcript window (use forward slashes — the Transcript is a Tcl shell):

```tcl
cd D:/path/to/MUX2_1
do run.do
```

`run.do` deletes and recreates the `work` library, compiles both files, starts the simulation, adds `S`, `A`, `B`, `Z` to the wave window in hex and runs to the end.

### Command line (no GUI)

```
vlib work
vlog Mux_2to1.v tb_Mux_2to1.v
vsim -c work.tb_Mux_2to1 -do "run -all; quit -f"
```

### Expected output

```
---- Mux_2to1 test start ----
...
Info: S=x  ->  Z=0101 (if-else treats x as false, so B is selected)
---- PASS: all 512 combinations correct ----
```

Any mismatch prints a `FAIL` line with the time, inputs, actual and expected output, followed by the total error count.

---

## Design notes — things worth learning from this block

### 1. `always` needs a sensitivity list

The first version of this design used a bare `always`:

```verilog
always begin              // ✗ no sensitivity list, no delay
    if (S == 0) G = A;
    else        G = B;
end
```

It **compiles with 0 errors and 0 warnings**, but the simulation hangs at time 0. A bare `always` loops forever, and with no `@(...)` or `#delay` inside it, simulation time can never advance. The fix:

```verilog
always @(*) begin         // ✓ re-evaluates whenever any input it reads changes
    if (S == 0) G = A;
    else        G = B;
end
```

Lesson: **a clean compile proves only that the syntax is legal, not that the design works.** That's why every block here gets a testbench.

### 2. Keep bit ordering consistent

The first version declared the internal register as `reg [0:3] G` while the ports were `[3:0]`. Verilog assigns vectors by position (left-most to left-most), so the value still came out correct, but `G[0]` was the MSB while `A[0]` was the LSB. That kind of mismatch causes real bugs as soon as you index a single bit. Convention: use `[MSB:0]` everywhere.

### 3. Cover every branch in combinational logic

The `else` matters. If a combinational `always` block doesn't assign `G` on every path, synthesis infers a **latch** to hold the old value — almost never what you want. Writing both branches (or a default assignment at the top of the block) keeps it purely combinational.

### 4. Three equivalent ways to write the same mux

```verilog
// (a) Continuous assignment — the most common for a simple mux
assign Z = S ? B : A;

// (b) Behavioural — what this repo uses; scales well to larger case/if logic
always @(*) if (S) G = B; else G = A;

// (c) Gate level — shows what the hardware actually is, per bit
assign Z = ({4{~S}} & A) | ({4{S}} & B);
```

All three synthesize to the same hardware. On an FPGA each output bit is a 3-input function (`S`, `A[i]`, `B[i]`), so it maps into look-up tables.

### 5. `if` vs `? :` behave differently when `S` is X

In simulation, if `S` is unknown (`x`):

- `if (S == 0)` treats the unknown condition as false → takes the `else` branch → `Z = B`. The X is **hidden**.
- `S ? B : A` merges A and B bit by bit → matching bits come through, differing bits become `x`. The X is **propagated**.

Real hardware does neither; it picks one or the other. The testbench drives `S = x` on purpose to show this. Hidden X's are a classic source of simulation-vs-silicon mismatches, which is why many teams prefer the `? :` form or add X-checks.

---

## Verification approach

The testbench (`tb_Mux_2to1.v`) is:

- **Exhaustive**: 4-bit A × 4-bit B × 1-bit S = 16 × 16 × 2 = **512 cases**, i.e. every possible input. For a block this small, exhaustive testing proves correctness outright; for larger designs you'd move to constrained-random tests and coverage.
- **Self-checking**: a reference model (`expected = (S == 0) ? A : B`) is compared against the DUT output automatically. No need to eyeball waveforms to know whether it passed.
- **X-aware**: the compare uses `!==` (case inequality), so an `x` or `z` on `Z` counts as a failure instead of slipping through as it would with `!=`.
- **Settle time**: inputs are applied, then the testbench waits `#10` before checking, so the combinational output has updated.
- **Clear verdict**: ends with a single `PASS` / `FAIL: N mismatches` line.

---

## Possible extensions

- Parameterize the width: `module Mux_2to1 #(parameter W = 4)`.
- Build a 4-to-1 mux from three 2-to-1 instances (structural design).
- Rewrite the testbench in SystemVerilog with `assert` and functional coverage.
- Synthesize in Vivado and look at the elaborated schematic and LUT usage.

---

## Tools

- **Simulator:** QuestaSim 10.7c (also runs on Icarus Verilog / ModelSim)
- **Language:** Verilog-2001
- **Editor / project:** Xilinx Vivado

Author: **D. Sitaram** — [GitHub](https://github.com/SitaramD) · [LinkedIn](https://linkedin.com/in/dsitaram1)
