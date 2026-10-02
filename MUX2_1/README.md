# MUX2_1 — 4-bit 2-to-1 Multiplexer

`Z = (S == 0) ? A : B`, where A, B and Z are 4 bits wide.

| File | Description |
|------|-------------|
| `Mux_2to1.v` | RTL (behavioural `always @(*)` + `assign`) |
| `tb_Mux_2to1.v` | Self-checking testbench, all 512 combinations of A, B, S |
| `run.do` | QuestaSim script: compile, simulate, add waves |

## Run in QuestaSim

```
cd <path-to>/MUX2_1
do run.do
```

Expected end of the transcript:

```
---- PASS: all 512 combinations correct ----
```
