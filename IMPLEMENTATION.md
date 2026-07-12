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

## Step 3 — Placement + optimization  (`scripts/06_place.tcl`)  — ✅ verified

Based on Lab 6. Branches `final_floorplan` → `place_opt`; sets
`place.coarse.continue_on_missing_scandef true`; runs `place_opt` (unified engine: coarse
place → HFNS → opt → legalize) at **default effort** (no Lab-3 effort knobs, per decision);
reconnects PG; `check_legality`/`report_congestion`/`report_utilization`/`report_pg_drc`/
`collect_reports place_opt`. Rerun-safe; no `exit`.

**Run result (verified, `logs/06_place.log`):** ✅ success.
| Metric | Value | Source |
|---|---|---|
| `check_legality` | succeeded | `logs/06_place.log` |
| Utilization | 62.51% | `logs/06_place.log` (`report_utilization`) |
| Congestion | 0 overflow on M4–MRDL (final phase) | `logs/06_place.log` |
| Setup | 0 violating paths, worst slack +3.42 ns (Slow) | `reports/place_opt_report_qor.rpt` |
| Hold | 0 violations (all scenarios) | `reports/place_opt_report_qor.rpt` |
| Max-trans / max-cap | 0 / 0 | `reports/place_opt_report_qor.rpt` |
| PG connectivity | VDD/VSS symmetric (6955/6876 wires), **0 floating std cells** both nets | `reports/place_opt_pg_drc.rpt` |

**PG-DRC caveat (tracked):** `check_pg_drc` reports 1,444 shorts — but **all are PG-net-vs-NULL-net
on M1/VIA0 at the standard cells** (zero VDD↔VSS shorts). This is the built-in checker
over-reporting on the library cells' internal M1/VIA0 taps at the pre-route stage (nets not yet
resolved into the frames). The authoritative gate is ICV `signoff_check_drc` after routing
(Step 6). See `ISSUES_AND_FIXES.md` and the PG Option B fix (Issue 4).

---

## Step 4 — Clock Tree Synthesis  (`scripts/07_cts.tcl`)  — ✅ verified

Based on HW4 / `lab7_cts/clock_opt.tcl`. Branches `place_opt` → `clock_opt`, then:
1. CTS app options (`cts.common.max_fanout 50`, `enable_cell_relocation timing_aware`,
   `size_pre_existing_cell_to_cts_references true`) + on-grid routing options.
2. `set_driving_cell SAEDRVT14_BUF_16 [get_ports clk_i]` (clock port has no I/O pad).
3. `set_lib_cell_purpose -include cts {…RVT INV/BUF…}` — restrict CTS to RVT inverters/buffers.
4. `create_routing_rule CLK_NDR` (2× width/spacing + shielding) + `set_clock_routing_rules`
   (M2–M5) + `set_clock_tree_options -target_skew 0.1`.
5. `clock_opt` 3 stages (`build_clock` → `route_clock` → `final_opto`),
   `remove_routes -global_route`, then `create_shields … -with_ground VSS`.
6. Reconnect PG; analyze; `collect_reports clock_opt` **+ `report_clock_skew clock_opt`**.

**Run result (verified, `logs/07_cts.log`):** ✅ success.
| Metric | Value | Source |
|---|---|---|
| Clock tree | `clk_i` — 62 buffers, 3 levels, wirelen 4329, NetsWithDRC 0 | `logs/07_cts.log` (CTS-037) |
| **Worst clock skew** | **0.09 ns** (Slow); latency 0.03–0.12 ns | `reports/clock_opt_clock_skew.rpt` (deliverable) |
| Global skew (build) | 0.037/0.055/0.043 (Fast/Slow/Typ) | `logs/07_cts.log` |
| Setup | 0 violating paths, worst slack +3.20 ns (Slow), +6.70 (Typ) | `reports/clock_opt_report_qor.rpt` |
| Hold | 0 violations (all scenarios) — real tree fixed the floorplan-stage hold | `reports/clock_opt_report_qor.rpt` |
| Max-trans / max-cap | 0 / 0 | `reports/clock_opt_report_qor.rpt` |
| Legality | succeeded; clock shielded with VSS on M2–M5 | `logs/07_cts.log` |

Takeaway: clock tree is tight (skew 0.09 ns), timing has margin at 10 ns, hold and DRVs clean.
Ready for signal routing (Step 5).

---

## Step 5 — Signal routing  (`scripts/08_route.tcl`)  — written, run pending

Based on HW4 / `lab8_routing/route_opt.tcl`. Branches `clock_opt` → `route_opt`, then:
1. Timing-driven routing options (`route.{global,track,detail}.timing_driven true`,
   `route.global.force_rerun_after_global_route_opt true`).
2. `source ../scripts/route.tcl` — project routing rules: metal directions, on-grid layers,
   `set_ignored_layers -min_routing_layer M2` (M1 reserved for cell pins/PG rails).
3. Pre-route info (`get_nets` count, `report_ignored_layers`, `report_scenarios`) + `check_routability`.
4. `route_auto` (global → track → detail) → `route_opt` → `add_redundant_vias` → `route_eco`.
5. `check_routes` / `check_lvs`; reconnect PG; `report_pg_drc route_opt` + `collect_reports route_opt`.

Rerun-safe (drops stale `route_opt`); no `exit`. Skips the lab's demo `create_routing_blockage`
(our placement created no matching blockage).

**To watch:** `check_routes` DRC count (target 0 after route_opt/eco); `check_lvs` shorts/opens
(target 0); congestion overflow; **`report_pg_drc route_opt`** — this is where the pre-route
NULL-net PG shorts should resolve now that nets are detail-routed into the cells; setup/hold
slack across the 3 scenarios.

---

## Step 6 — Sign-off / chip finish  (`scripts/09_signoff.tcl`)  — written, run pending

Based on HW4 / `lab9_signoff/{signoff,write_data}.tcl`. Branches `route_opt` → `signoff`, then:
1. `source ../scripts/filler.tcl` (provided filler) → `check_legality`;
   `remove_placement_blockages -all` → re-fill → `check_legality`; reconnect PG; `save_block`.
2. **ICV in-design signoff DRC**: `set_host_options -target ICV -max_cores 2`, set
   `signoff.check_drc.runset`/`run_dir`/`layer_map_file`, then
   `signoff_check_drc` → `signoff_fix_drc` (reruns router to fix) → `signoff_check_drc` again.
3. **Metal fill**: `signoff_create_metal_fill -select_layers {M2 M3 M4 M5 M6}` + pre/post density reports.
4. Final analyze + **deliverables**: `report_pg_drc chip_finish` (**final PG-DRC report**) and
   `collect_reports chip_finish` (**final timing report** = `chip_finish_report_timing_setup.rpt`).
5. **Write data**: `write_verilog` (logical + `.pg.v`), `write_sdc`, `write_parasitics` (SPEF),
   `write_gds` (merging the 3 Vt GDS libs). `save_block -as ${DESIGN_NAME}`.

Rerun-safe (drops stale `signoff` + top block); no `exit`. Uses the confirmed EDK signoff paths
(`icv_drc/…_drc_rules.rs`, `…_mfill_rules.rs`, `…_gdsin_gdsout.map`, 3× Vt GDS).

**This is the authoritative gate for the PG/DRC question** from Step 5: ICV `signoff_check_drc`
uses real foundry rules with full net resolution. If it comes back clean (or `signoff_fix_drc`
clears it), the route-stage `check_lvs` 4,417 shorts were PG-tracing artifacts (VDD/VSS shown
"open"); if it reports real shorts, we fix from concrete ICV geometry (PG pins / RVT-only).

**Deliverables produced:** `reports/clock_opt_clock_skew.rpt` (Step 4),
`reports/chip_finish_report_timing_setup.rpt` (+hold), `reports/chip_finish_pg_drc.rpt`, and
`results/riscv_core.{v,pg.v,sdc,spef,gds}`.







