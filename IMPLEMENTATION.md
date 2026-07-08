# RISC-V RTL-to-GDS — Implementation Documentation

Running log of how the Advanced VLSI final project is built, one stage at a time.
Each step is added here **after it runs successfully on the VNC**.

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

**Run result:** _pending — to be filled in after the VNC run (ref-lib count, any unresolved
modules from the Xilinx `RAM16X1D`/regfile, area/power numbers)._

---

<!-- Steps 2–6 (floorplan+PG, place, CTS, route, sign-off) will be documented here as each is verified. -->
