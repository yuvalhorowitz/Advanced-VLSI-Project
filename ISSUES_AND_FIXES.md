# Issues Found in Course-Provided Files — and Fixes

Advanced VLSI final project (RISC-V, SAED14nm, Fusion Compiler `V-2023.12-SP3`).

While bringing up the RTL-to-GDS flow we hit three defects in the **course-provided input
files** (`scripts/create_pg_network.tcl` and the constraints file `riscv.sdc`). Each aborts a
tool command at runtime. Below is the exact symptom, root cause, and the minimal fix applied.
All fixes are one-liners and preserve the original intent; originals are kept as comments in
the files.

---

## Issue 1 — `create_pg_network.tcl`: PG strategy name mismatch (M4 straps)

- **File:** `scripts/create_pg_network.tcl` (provided)
- **Location:** the "Create M4 Vertical PG Straps" block.
- **Original code:**
  ```tcl
  create_pg_mesh_pattern M4_PG -layers { {vertical_layer: M4} ... }
  set_pg_strategy M5_PG_Strategy \                 ;# <-- names the strategy M5_PG_Strategy
      -core -pattern { {name: M4_PG} {nets:{VSS VDD}} } ...
  compile_pg -strategies {M4_PG_Strategy} -via_rule VIA_NIL   ;# <-- compiles M4_PG_Strategy
  ```
- **Symptom:** `compile_pg` is asked to compile `M4_PG_Strategy`, which was never defined
  (the strategy was created under the name `M5_PG_Strategy`), so the M4 power/ground straps
  are not built — and the later real `M5_PG_Strategy` (defined further down for the M5 straps)
  collides in name.
- **Root cause:** copy/paste typo — the M4 strap strategy was named `M5_PG_Strategy`.
- **Fix:** rename the strategy to match what is compiled:
  ```tcl
  set_pg_strategy M4_PG_Strategy -core -pattern { {name: M4_PG} {nets:{VSS VDD}} } ...
  compile_pg -strategies {M4_PG_Strategy} -via_rule VIA_NIL
  ```
- **Status:** fixed (rename). Note: Issue 4 (below) later **removed the M4 strap block
  entirely** in favor of the lab's M5→M1 distribution, so this block no longer runs in our
  flow — but the name mismatch remains a real defect in the provided input file.
- **Where to see it:** the true untouched provided file is
  `backups/create_pg_network.provided_ORIGINAL.tcl` (line 55 = `set_pg_strategy M5_PG_Strategy`,
  line 60 = `compile_pg -strategies {M4_PG_Strategy}`). The other backup,
  `backups/create_pg_network.provided_M4stack.tcl`, already has **this** rename applied (it was
  captured while fixing Issue 4), so it does *not* show the mismatch — only the M4-vs-tech
  direction issue.

---

## Issue 2 — `riscv.sdc`: Tcl/app commands invalid inside `read_sdc`

- **File:** `common/sdc/riscv.sdc` (provided constraints), lines 2 and 17.
- **Context:** the lab constraint file (`i2c_master_top.sdc`) is **pure SDC** — only
  `create_clock`, `set_clock_uncertainty`, `set_clock_transition`, `get_ports`/`get_clocks`
  and Tcl `set` — so `read_sdc` worked there. The provided `riscv.sdc` additionally uses
  **application/Tcl commands** that `read_sdc`'s restricted interpreter does not expose:
  - line 2: `remove_sdc -design`
  - line 17: `set_input_delay ... [remove_from_collection [all_inputs] [get_ports clk_i]]`
- **Symptom (from `logs/05_floorplan.log`):**
  ```
  remove_sdc -design
  Error: unknown command 'remove_sdc' (CMD-005)
  script '.../riscv.sdc' stopped at line 2 due to error. (CMD-081)
  Error: Errors reading SDC file: ... (SDC-5)
  ```
  and after fixing line 2, the next run hit:
  ```
  set_input_delay -max 0.2 -clock clk_i [remove_from_collection [all_inputs] [get_ports clk_i]]
  Error: unknown command 'remove_from_collection' (CMD-005)
  script '.../riscv.sdc' stopped at line 22 due to error. (CMD-081)
  ```
- **Impact:** each unknown command **aborts the whole file at that line**. On the first run no
  clock/constraints loaded at all; on the second run the clock loaded but the input/output-delay
  and clock-transition constraints were dropped. Either way the design is under-constrained.
- **Root cause:** `remove_sdc` and `remove_from_collection` are shell/collection commands, not
  part of the SDC command set that `read_sdc` accepts.
- **Fix:**
  - line 2 — comment out `remove_sdc -design` (unnecessary; each MCMM scenario reads a fresh SDC).
  - line 17 — replace `[remove_from_collection [all_inputs] [get_ports clk_i]]` with `[all_inputs]`
    (SDC-native). The clock port also receiving a 0.2 input delay is harmless — it is driven by
    `create_clock`.
- **Status:** fixed and **verified** — after the fixes, `read_sdc` loads all constraints into
  the 3 MCMM scenarios with no `CMD-005`/`SDC-5`, the clock `clk_i` is created, and setup timing
  is reported (Step 2 floorplan run, `logs/05_floorplan.log`).

---

## Issue 3 — `riscv.sdc`: `get_port` should be `get_ports`

- **File:** `common/sdc/riscv.sdc` (provided constraints), line 11.
- **Original code:**
  ```tcl
  set_case_analysis 0 [get_port rst_i]
  ```
- **Symptom:** `get_port` (singular) is not a valid Fusion Compiler command; like Issue 2 it
  aborts `read_sdc` at that line, dropping every constraint after it.
- **Root cause:** typo — the correct accessor is `get_ports` (plural).
- **Fix:**
  ```tcl
  set_case_analysis 0 [get_ports rst_i]
  ```
- **Status:** fixed.

---

## Issue 4 — `create_pg_network.tcl`: M4 vertical straps conflict with the M4 routing direction (VSS never reaches M1)

- **File:** `scripts/create_pg_network.tcl` (project-provided PG script).
- **Context:** the project PG script builds **M4 as a vertical strap** and stitches vias
  **M4→M1**:
  ```tcl
  create_pg_mesh_pattern M4_PG -layers { {vertical_layer: M4} ... }
  create_pg_vias -from_layers M4 -to_layers M1 -nets {VDD VSS}
  ```
  But `tech_setup.tcl` (inherited from the lab) declares **M4 = horizontal**, and the M1
  follow-pin rails are horizontal. Two horizontal layers can't via-connect cleanly, so the
  M4→M1 stitch does not land. The **lab's** PG script never used M4 at all — it distributed on
  M5 and stitched **M5→M1**.
- **Symptom (found only *after placement*, `reports/place_opt_pg_drc.rpt`):** `check_pg_drc`
  was clean at floorplan (no cells yet), but after `place_opt` + `connect_pg_net`:
  - VDD floating std cells = 0, **VSS floating std cells = 13,230** (≈ all cells),
  - **1,401 PG shorts** (1,067 on M1, 334 on VIA0).
  GUI inspection confirmed: M1 VDD/VSS rails alternate correctly, but **no VSS connection/vias
  are built from M1 up to M4**.
- **Root cause:** M4 is used as a vertical PG layer by the project script while the tech/route
  setup (from the lab) treats M4 as horizontal — an inconsistency between two provided course
  files that were never meant to run together.
- **Fix (Option B — match the lab's proven metal stack):** keep the lab's clean alternating
  directions (odd=V, even=H) and route PG vertically on **M5** like the lab: drop the M4 strap
  block and change the via chain from `M4→M1 ; M5→M4 ; …` to **`M5→M1 ; M6→M5 ; M7→M6`**. This
  yields an orthogonal M5(V)/M6(H)/M7(V) mesh feeding the horizontal M1 rails, so both VDD and
  VSS connect. The original M4-strap version is preserved in
  `backups/create_pg_network.provided_M4stack.tcl`.
- **Status:** fixed; re-run of floorplan+placement pending to confirm VSS connects and PG DRC
  is clean.

---

## Informational (not a bug, no fix required)

- **`insert_boundary_and_tap_cells.tcl` — `compile_boundary_cells` deprecation:** the tool
  prints `CMD-100` advising `compile_targeted_boundary_cells` instead. The command still works;
  we left it as provided. Worth updating in a future revision of the course scripts.
- **Layer-map warnings during `read_parasitic_tech`:** `Tech layer 'M1_3'/'M2_3'/'M3_3' ...
  cannot be found in technology section` — the shared `saed14nm_tf_itf_tluplus.map` lists
  layers beyond this tech's stack; warnings only, no impact.

---

### Summary

| # | File (provided) | Defect | Effect | Fix |
|---|---|---|---|---|
| 1 | `create_pg_network.tcl` | M4 strap strategy named `M5_PG_Strategy` but compiled as `M4_PG_Strategy` | M4 straps not built / name collision | rename strategy to `M4_PG_Strategy` (block later removed by fix 4) |
| 2 | `riscv.sdc` (l.2, l.17) | `remove_sdc` / `remove_from_collection` — Tcl/app commands invalid in `read_sdc` | whole SDC aborts (CMD-005) → clock and/or I/O constraints not loaded | comment `remove_sdc`; use `[all_inputs]` |
| 3 | `riscv.sdc` (l.11) | `get_port` (singular) invalid | aborts SDC → drops constraints | use `get_ports` |
| 4 | `create_pg_network.tcl` | M4 used as vertical strap + M4→M1 vias, but tech/route setup has M4 horizontal | VSS never reaches M1 → 13,230 floating VSS cells + 1,401 M1/VIA0 shorts (post-place) | drop M4 straps; distribute M5→M1 like the lab |

*Note:* the lab SDC (`i2c_master_top.sdc`) is pure SDC, which is why `read_sdc` worked in the
labs; the project `riscv.sdc` additionally used shell/Tcl commands that `read_sdc` rejects.
