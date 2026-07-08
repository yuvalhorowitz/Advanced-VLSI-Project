# RISC-V RTL-to-GDS — Implementation Documentation

Running log of how the Advanced VLSI final project is built, one stage at a time.
Each step is added here **after it runs successfully on the VNC**, with a results-analysis
table interpreting that stage's reports (area, timing, power, utilization, PG/DRC).

Design: **RISC-V core** (`riscv_core`) · Technology: **SAED14nm (1p9m)** · Tool: **Synopsys Fusion Compiler**
Flow mirrors reference Labs 1–9, applied to RISC-V instead of `i2c_master_top`.

---

## 0. Project setup & structure

The git repo **is** the project root on the TAU VNC (`/project/advvlsi/users/yh3/ws/project_2026`).
We develop locally, `git push`, and `git pull` on the VNC to run.

```
Setup/     configuration sourced by every stage
  fc_common_setup.tcl   design name, clock/reset ports, EDK paths, 3-Vt ref libs, I/O paths
  fc_flow_setup.tcl     flow switches (tf/tlup/verilog), PVT corners, host cores
  tech_setup.tcl        default site, parasitic tech, routing directions
  mcmm_setup.tcl        3 corners (Fast/Typ/Slow) + FUNC mode + scenarios + read_sdc
  utilities.tcl         collect_reports + report_clock_skew + report_pg_drc procs
scripts/   one driver per stage (01_syn … 09_signoff) + provided helper scripts
common/    committed inputs: rtl/verilog/{riscv_core_all.v,riscv_defs.v}, sdc/riscv.sdc
work/      run directory — fc_shell is launched here (git-ignored scratch)
results/   design library (.dlib) + final netlists/def/gds  (tracked)
reports/   all .rpt deliverables                              (tracked)
clean.sh   resets results/reports/work/logs for a fresh rerun (labs' `make clean`)
```

**Key setup facts**
- Large SAED14 EDK data (tech file, tlup, NDMs, runsets, GDS) is referenced by absolute
  path via `EDK_ROOT=/tech/synopsys/lib/SAED14_EDK` — never copied into git.
- Reference libraries: all three Vt flavors are linked
  (`saed14{lvt,rvt,hvt}_base_frame_timing.ndm`) so the optimizer can trade Vt for power/timing.
- Clock is `clk_i` (period 10 ns), reset `rst_i` — read from `riscv.sdc`.
- Paths are relative to `work/` (one level under the repo root): inputs `../common`,
  outputs `../results` / `../reports`, config `../Setup`.

**How to run a stage** (from `work/`):
```sh
./clean.sh                                 # optional: reset before a full rerun
cd work
fc_shell -f ../scripts/<NN_stage>.tcl -output_log_file ../logs/<NN>.log
```

---

## Step 1 — Build library, read RTL, initial synthesis  (`scripts/01_syn.tcl`)

**Goal:** create the design library against the SAED14 references, read the RISC-V RTL,
elaborate the top module, and run initial technology mapping. (Based on Lab 1.)

**What the script does**
1. `source ../Setup/fc_common_setup.tcl` + `fc_flow_setup.tcl` — load all variables.
2. `create_lib results/riscv_core.dlib -technology <tf> -ref_libs {LVT RVT HVT}` — the design
   library, built on the tech file and the three Vt reference NDMs.
3. `report_ref_libs` — sanity check that all three libraries linked.
4. `analyze -format verilog` over `common/rtl/verilog/*.v`, then `elaborate riscv_core` and
   `set_top_module riscv_core` — build and link the design (VER-130 warnings suppressed during analyze).
5. `save_block -as riscv_core/rtl_read` — the pre-synthesis block later stages branch from.
6. `compile_fusion -to initial_map` — technology-independent → technology-dependent mapping.
7. `report_timing` / `report_power` / `report_area` — quick PPA sanity (timing is expected to
   be empty here — no constraints are read until the floorplan stage).
8. `write_verilog results/riscv_core_initial_syn.v` — gate-level netlist after mapping.
9. `save_block -as riscv_core/inital_syn` + `save_lib`.

**Blocks produced:** `riscv_core/rtl_read`, `riscv_core/inital_syn`.
**Outputs:** `results/riscv_core.dlib`, `results/riscv_core_initial_syn.v`.

**Run result (verified on VNC, `logs/01_syn.log`):** ✅ success.
- All three Vt reference libraries linked (`report_ref_libs`): `saed14lvt/rvt/hvt_base_frame_timing.ndm`.
- Full `riscv_core` hierarchy elaborated; **0 black boxes** — the Xilinx `RAM16X1D` /
  `SUPPORT_REGFILE_XILINX` path is not instantiated, so the register file maps to real cells.
- `compile_fusion -to initial_map` completed (balanced-flow mode).
- Netlist: **14,104 nets · 11,962 cells · 2,319 sequential**.
- Area: combinational 3628.55 + noncombinational 2820.87 → **total cell area ≈ 6449 µm²**.
- Timing report empty — expected (no SDC/clock read until the floorplan stage).
- `rtl_read` + `inital_syn` blocks and the library saved successfully.

**Benign messages (no action):** `POW-034` (no clocks in `default` mode — expected, no SDC yet),
`POW-046` ×13k (power info, suppressed), `VER-*` RTL lint (unnamed generate blocks; a few `reg`
nets not driven by an `always`).

**Results analysis:** (Step 1 uses `report_*` to console, captured in `logs/01_syn.log` —
no `collect_reports` at this stage.)
| Metric | Value | Reading | Source |
|---|---|---|---|
| Total cells | 11,962 | reasonable for a small RV32 core | `logs/01_syn.log` (`report_area`) |
| Combinational | 9,643 | — | `logs/01_syn.log` (`report_area`) |
| Sequential (flops) | 2,319 | register file + pipeline mapped to real flops (no Xilinx RAM) | `logs/01_syn.log` (`report_area`) |
| Buf/Inv | 1,157 | pre-opt; CTS/opt will rebalance | `logs/01_syn.log` (`report_area`) |
| References (cell types) | 56 | multi-Vt library cells in use | `logs/01_syn.log` (`report_area`) |
| Total cell area | 6,449.4 µm² | netlist area *before* floorplan/placement | `logs/01_syn.log` (`report_area`) |
| Timing | none | expected — constraints not read until Step 2 | `logs/01_syn.log` (`report_timing`) |
| Black boxes | 0 | RTL fully synthesizable against SAED14 | `logs/01_syn.log` (`report_area`) |

Takeaway: a healthy technology-mapped netlist with **0 black boxes** — the RTL is fully
synthesizable against SAED14 and ready to floorplan.



**⚠ Known issue — GUI crash:** running with `-gui` segfaults in the Qt idle loop
(`QTimer::timeout → QApplication::notify`) *after* the flow finishes and the library is saved.
It is a GUI-over-VNC instability and does **not** affect results. **Run every stage headless**
(no `-gui`); when you need to inspect the layout, type `gui_start` at the `fc_shell>` prompt
(`gui_stop` to close).

---

## Step 2 — Floorplan + PG network  (`scripts/05_floorplan.tcl`)  — ✅ verified

Based on Lab 5.2 (manual floorplan) + 5.3 (PG). Branches `inital_syn` → `final_floorplan`
(the **mapped** block — `initialize_floorplan -core_utilization` needs real cell area; the lab
used `rtl_read` only because it read a pre-built `floorplan.def`). Then:
1. `source ../Setup/tech_setup.tcl`, `read_sdc ../common/sdc/riscv.sdc`, `source ../Setup/mcmm_setup.tcl`
   — constraints/MCMM enter here (this is why timing was empty in Step 1).
2. `initialize_floorplan` (core util 0.60 / offset 5 / shape R / square) + `set_block_pin_constraints`
   (M3/M4, left+bottom) + `set_individual_pin_constraints` for the **`clk_i`** pin (top, M5) + `place_pins`.
3. `source ../scripts/insert_boundary_and_tap_cells.tcl` (boundary/tap, `SAEDRVT14` prefix).
4. `source ../scripts/create_pg_network.tcl` (rails/rings/mesh/vias + connect + checks; M4-strategy bug fixed).
5. `write_floorplan` + `write_def` → `results/`; `report_utilization`, `report_pg_drc final_floorplan`,
   `collect_reports final_floorplan`; save block+lib (no `exit`).

**Prerequisite fix:** the provided `riscv.sdc` had to be corrected first — it used
`remove_sdc` / `remove_from_collection` / `get_port` which `read_sdc` rejects (see
`ISSUES_AND_FIXES.md`). Also made `write_floorplan` rerun-safe (`file delete -force` its dir)
and the block copy rerun-safe (drop stale `final_floorplan`).

**Run result (verified on VNC, `logs/05_floorplan.log`):** ✅ success.
- SDC loaded into all 3 scenarios with **no `CMD-005`/`SDC-5`** (clock clk_i @10 ns + uncertainty
  + case_analysis on rst_i + input/output delays + clock transition).
- Floorplan **utilization 60.28%**; pins placed; boundary/tap cells inserted.
- **PG `check_pg_drc` = "No errors found."** (VDD 4719 wires/7570 vias; VSS 168 wires/784 vias.)
- Timing now real: setup **MET** (e.g. +3.34 ns), **0 setup-violating paths** Slow/Typical; minor
  hold (FUNC_Slow 124 paths, TNS −0.44 ns) + 2 max-trans/cap — **expected pre-CTS/route**.
- Reached `write_floorplan`/`write_def` + `collect_reports final_floorplan` + save.

**Expected caveat:** `check_pg_connectivity` shows many floating std cells (9453 VDD / 11161 VSS)
— normal at floorplan stage (cells not on rows yet); resolves after placement (Step 3).

**Results analysis:**
| Metric | Value | Reading | Source |
|---|---|---|---|
| Ports | 1,801 | large I/O count → pin placement is the tight constraint, not core area | `reports/final_floorplan_report_area.rpt` |
| Core area | 10,699.2 µm² | site-row area for cells | `reports/final_floorplan_report_design.rpt` |
| Chip area | 12,867.9 µm² | includes the 5 µm core-to-die offset + PG rings | `reports/final_floorplan_report_design.rpt` |
| Core utilization | 60.28% | matches the 0.60 target; comfortable headroom | `logs/05_floorplan.log` (`report_utilization`) |
| Master clocks | 1 (`clk_i`) | SDC applied correctly | `reports/final_floorplan_report_design.rpt` |
| Setup (Slow/Typical) | 0 violating paths; worst slack +3.34 ns (Slow), +6.48 ns (Typ) | 10 ns period is very relaxed → large positive slack (Fast has setup disabled) | `reports/final_floorplan_report_qor.rpt` |
| Hold (FUNC_Typical) | 124 paths, TNS −0.44 ns, worst −0.00 ns | tiny; hold fixed at CTS/route. Fast hold = 0; Slow does not check hold | `reports/final_floorplan_report_qor.rpt` |
| Max-trans / max-cap | 2 / 2 | minor DRV, cleaned during opto/route | `reports/final_floorplan_report_qor.rpt` |
| Dynamic power | 1.13 mW (Fast) / 0.45 mW (Typ) / 0.32 mW (Slow) | **clock_network ≈ 95–98%** — ideal high-fanout clock pre-CTS; drops after a real tree | `reports/final_floorplan_report_power.rpt` |
| Leakage power | N/A (Fast) / 3.15e6 pW (Typ) / 4.94e4 pW (Slow) | N/A on Fast only because leakage analysis is **disabled** for that scenario, not a data gap | `reports/final_floorplan_report_power.rpt` |
| PG `check_pg_drc` | No errors | PG mesh/rings/rails DRC-clean | `reports/final_floorplan_pg_drc.rpt` |

Takeaway: the floorplan is healthy — ample timing margin at the 10 ns target, DRC-clean PG,
and utilization on target. Total power is dominated by the still-ideal clock network (pre-CTS)
and will shift once a real clock tree is built. Only pre-placement hold/DRV noise remains,
expected to clear downstream. Ready for placement.




---

## Step 3 — Placement + optimization  (`scripts/06_place.tcl`)  — NEXT

Planned (Lab 6). Branches `final_floorplan` → `place_opt`, then:
`set_app_options place.coarse.continue_on_missing_scandef true` + `place_opt.*` (defaults —
no effort knobs yet, per decision) → `compile_fusion -to initial_opto` → `place_opt` →
`connect_pg_net` → `check_legality` / `report_congestion` / `report_utilization` →
`collect_reports place_opt`. Rerun-safe (drop stale `place_opt` block); no `exit`.

**Decision:** run with **default** effort first. Only if setup/hold fails to close do we add the
Lab 3 knobs (`compile.flow.high_effort_timing` etc.).
**To watch:** legality clean, congestion overflows, whether PG floating std cells drop to ~0
after placement, and setup/hold slack across the 3 scenarios.



