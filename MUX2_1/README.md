# QuestaSim — Verilog Designs & Testbenches

A collection of digital design blocks written in Verilog, each with a self-checking testbench and a ready-to-run QuestaSim script.

The aim is to build up from basic combinational blocks to larger sequential designs, verifying every one properly rather than just checking that it compiles.

## Designs

| Folder | Design | Type | Verification |
|--------|--------|------|--------------|
| [`MUX2_1`](MUX2_1/) | 4-bit 2-to-1 multiplexer | Combinational | Exhaustive, 512 cases, self-checking |

More designs will be added over time.

## Folder layout

Each design folder follows the same structure:

```
<Design>/
├── <Design>.v        RTL
├── tb_<Design>.v     Self-checking testbench
├── run.do            QuestaSim script
├── README.md         Function, design notes, how to run
└── .gitignore        Keeps simulator output out of the repo
```

## Running any design

Open QuestaSim, then in the Transcript:

```tcl
cd D:/path/to/QuestaSim/<Design>
do run.do
```

Every testbench ends with a single `PASS` or `FAIL` line.

## Verification principles used here

- **Self-checking**: each testbench compares the design against a reference model automatically.
- **X-aware compares** with `!==`, so unknown values count as failures.
- **Exhaustive** testing where the input space is small; directed and random tests where it isn't.
- **A clean compile isn't a pass**: every design is simulated before it's committed.

## Tools

QuestaSim 10.7c · Verilog-2001 · Xilinx Vivado

Author: **D. Sitaram** — [GitHub](https://github.com/SitaramD) · [LinkedIn](https://linkedin.com/in/dsitaram1)
