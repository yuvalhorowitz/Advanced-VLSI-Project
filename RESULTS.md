# RISC-V RTL-to-GDS — Results & Deliverables

Advanced VLSI final project — RISC-V core (`riscv_core`), SAED14nm 1p9m, Synopsys Fusion Compiler.
This file is the single reference for **where the deliverables live** and **every metric
extractable from the run reports** (non-GUI). Values are the final signed-off design
(`chip_finish` / `signoff` block). See `IMPLEMENTATION.md` for the build log and
`ISSUES_AND_FIXES.md` for provided-file bugs and the accepted residual DRCs.

---

## 1. Project directory structure

```
project_2026/                 (== /project/advvlsi/users/yh3/ws/project_2026 on the VNC)
  Setup/        configuration sourced by every stage
                  fc_common_setup.tcl  fc_flow_setup.tcl  tech_setup.tcl
                  mcmm_setup.tcl  utilities.tcl
  scripts/      flow drivers + provided helper scripts
                  01_syn.tcl 05_floorplan.tcl 06_place.tcl 07_cts.tcl
                  08_route.tcl 09_signoff.tcl
                  create_pg_network.tcl  insert_boundary_and_tap_cells.tcl
                  route.tcl  filler.tcl
  common/       committed inputs: rtl/verilog/{riscv_core_all.v,riscv_defs.v}, sdc/riscv.sdc
  work/         fc_shell run directory (launch stages here)
  results/      design library + netlists/sdc  (GDS & SPEF are on the VNC only — >100 MB, git-ignored)
  reports/      all .rpt reports (tracked)
  logs/         per-stage run logs (tracked)
```

Block progression (design library `results/riscv_core.dlib`):
`rtl_read -> inital_syn -> final_floorplan -> place_opt -> clock_opt -> route_opt -> signoff`

---

## 2. Required deliverables (per Adv_VLSI_Project_2026.pdf)

| Required item | Location |
|---|---|
| Final scripts | `Setup/*.tcl`, `scripts/01_syn.tcl … 09_signoff.tcl` (+ provided helpers) |
| Clock-skew report | `reports/clock_opt_clock_skew.rpt`  (`report_clock_timing -type skew`) |
| Final timing report | `reports/chip_finish_report_timing_setup.rpt`  (+ `_hold`) |
| Final PG-DRC report | `reports/chip_finish_pg_drc.rpt`; ICV sign-off DRC: `work/signoff_drc_run/riscv_core.RESULTS` and `.LAYOUT_ERRORS` |
| Final GDS | `results/riscv_core.gds`  (on the VNC; git-ignored, ~200 MB) |
| Final netlists / constraints / parasitics | `results/riscv_core.v`, `riscv_core.pg.v`, `riscv_core.sdc`, `riscv_core.spef.*` |
| Location of the final Fusion Compiler run | `/project/advvlsi/users/yh3/ws/project_2026` |
| Email deliverable | to `webb@tauex.tau.ac.il`, `adiinbar2@mail.tau.ac.il` — team names + IDs + run location |

---

## 3. Metrics summary (final design — `chip_finish`)

### Area / design  (`chip_finish_report_area.rpt`, `_report_design.rpt`, `_report_qor.rpt`)
| Metric | Value |
|---|---|
| Ports | 1,868 |
| Nets | 14,503 |
| Total cells | 12,334 |
| Combinational cells | 10,015 |
| Sequential cells | 2,319 |
| Buf/Inv cells | 1,318 |
| Cell references (masters) | 136 |
| Combinational area | 3,865.82 µm² |
| Noncombinational area | 2,879.65 µm² |
| Buf/Inv area | 266.13 µm² |
| **Total cell area (netlist)** | **6,745.47 µm²** |
| Cell area (netlist + physical-only) | 10,699.16 µm² |
| **Core area** | **10,699.16 µm²** |
| **Chip area** | **12,867.90 µm²** |
| Master clocks | 1 (`clk_i`) |

### Timing  (`chip_finish_report_qor.rpt`, `_report_timing_setup/hold.rpt`) — clock `clk_i`, 10 ns
| Scenario (corner) | Setup WNS | Setup TNS | Setup viol. | Hold viol. | Met? |
|---|---|---|---|---|---|
| FUNC_Slow (ss0p72vm40c) | +4.09 ns | 0 | 0 | not checked | YES |
| FUNC_Typical (tt0p8v25c) | +7.07 ns | 0 | 0 | 0 | YES |
| FUNC_Fast (ff0p88v125c) | not checked | – | – | 0 | YES |

Setup checked in Slow/Typical, hold in Fast/Typical (per `mcmm_setup.tcl` scenario status).
All corners meet timing; no violating paths.

### Power  (`chip_finish_report_power.rpt`) — total, per corner
| Corner | Total dynamic power | Cell leakage |
|---|---|---|
| FUNC_Fast | 0.760 mW | N/A (leakage disabled in this scenario) |
| FUNC_Typical | 0.587 mW | 1.59e6 pW (≈1.6 µW) |
| FUNC_Slow | 0.442 mW | 4.66e4 pW (≈47 nW) |

### Clock tree / CTS  (`clock_opt_clock_skew.rpt`, `logs/07_cts.log`)
| Metric | Value |
|---|---|
| Worst clock skew | 0.10 ns (Slow) |
| Clock-pin latency range | 0.03 – 0.13 ns |
| Clock buffers inserted | 62 (3 levels) |
| Target skew | 0.1 ns |

### Placement / routing quality
| Metric | Value | Source |
|---|---|---|
| Utilization | 63.05 % | `route_opt_utilization.rpt` |
| Global-route overflow | 821 (0.84 %) | `route_opt_congestion.rpt` |
| Signal-route DRCs | 0 | `route_opt_check_routes.rpt` |
| Total wires | 137,743 | `route_opt_check_routes.rpt` |
| Redundant-via (double-cut) rate | 38.3 % | `route_opt_check_routes.rpt` |

### DRC — ICV sign-off (authoritative)  (`logs/09_signoff.log`, `work/signoff_drc_run/`)
| Metric | Value |
|---|---|
| Total ICV DRC violations | **5** (accepted) |
| Breakdown | 3× `M5.S.2.1`, 2× `M9.S.3.1` (minor M5/M9 metal spacing) |
| History | 61 → 5 after the M6 PG-mesh spacing fix + ICV auto-repair |

### PG connectivity / built-in PG-DRC  (`chip_finish_pg_drc.rpt`)
| Metric | Value |
|---|---|
| Floating std cells (VDD / VSS) | 0 / 0 |
| Floating wires / terminals | 0 / 0 |
| Built-in `check_pg_drc` entries | 1,245 (M1/VIA0) — **net-tracing artifacts, not real** (ICV is clean; see `ISSUES_AND_FIXES.md`) |

### LVS  (`route_opt_check_lvs.rpt`)
Built-in `check_lvs` reports shorts/opens that are the same **PG net-tracing artifacts**
(VDD/VSS have no top-level port pins). A true sign-off LVS was not run (not a project
deliverable). See `ISSUES_AND_FIXES.md`.

### Metal density after fill  (`post_metal_fill_density.rpt`)
| Layer | M2 | M3 | M4 | M5 | M6 | M7 | M8 | M9 |
|---|---|---|---|---|---|---|---|---|
| Density % | 40.5 | 37.6 | 46.3 | 50.7 | 45.3 | 6.3 | 0.8 | 0.07 |

---

## 4. Report file index

Each stage writes a set of `reports/<stage>_*.rpt` (via `collect_reports` in
`Setup/utilities.tcl`), so metrics can be compared stage-to-stage
(`final_floorplan_` → `place_opt_` → `clock_opt_` → `route_opt_` → `chip_finish_`).

| Report file (per stage) | Produced by | Holds |
|---|---|---|
| `<stage>_report_area.rpt` | `report_area` | cell counts, combinational/noncomb/total cell area |
| `<stage>_report_design.rpt` | `report_design` | core/chip area, clocks, library cell summary |
| `<stage>_report_qor.rpt` | `report_qor` | WNS/TNS/violating-paths per scenario, cell area netlist vs physical, DRC count |
| `<stage>_report_timing_setup.rpt` | `report_timing -delay_type max` | setup critical paths / slack |
| `<stage>_report_timing_hold.rpt` | `report_timing -delay_type min` | hold critical paths / slack |
| `<stage>_report_power.rpt` | `report_power -scenarios [all_scenarios]` | dynamic/leakage/total power per corner |
| `<stage>_pg_drc.rpt` | `report_pg_drc` (`check_pg_connectivity` + `check_pg_drc`) | PG floating count + PG-DRC |
| `clock_opt_clock_skew.rpt` | `report_clock_skew` (`report_clock_timing -type skew`) | worst clock skew + latency |
| `route_opt_check_routes.rpt` | `check_routes` | routing DRCs, wire/via counts |
| `route_opt_check_lvs.rpt` / `_full.rpt` | `check_lvs` | shorts / opens / floating routes |
| `route_opt_congestion.rpt` | `report_congestion` | global-route overflow |
| `route_opt_utilization.rpt` | `report_utilization` | core utilization ratio |
| `pre_/post_metal_fill_density.rpt` | `signoff_report_metal_density` | per-layer metal density |

Logs of every stage are in `logs/NN_<stage>.log` (full command transcripts; note some tool
output uses control characters — read with `grep -a`).
