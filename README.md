# Advanced VLSI Project — RISC-V RTL-to-GDS (Fusion Compiler, SAED14nm)

Full Place-and-Route implementation of a RISC-V core, from RTL to a routed,
filled, signed-off design. The flow mirrors the reference labs (HW1–HW3,
Labs 1–9) applied to the RISC-V design instead of `i2c_master_top`.

This git repo **is** the project root on the TAU VNC server
(`/project/advvlsi/users/yh3/ws/project_2026`). Push here, `git pull` there, run.

## Layout

```
Setup/     setup scripts (common/flow/tech/mcmm/utilities)
scripts/   stage drivers (01_syn … 09_signoff) + provided helpers
           (create_pg_network, insert_boundary_and_tap_cells, route, filler)
common/    committed project inputs: rtl/verilog/{riscv_core_all.v,riscv_defs.v}, sdc/riscv.sdc
work/      run directory — launch fc_shell here (git-ignored scratch)
results/   design library + final netlists/sdc/spef/gds/def   (tracked)
reports/   all .rpt deliverables (clock-skew, final timing, PG-DRC, …) (tracked)
```

Large SAED14 EDK data (tech file, tlup, NDMs, runsets, gds) is referenced by
absolute path via `EDK_ROOT` in `Setup/fc_common_setup.tcl` — never committed.

## Block progression

`rtl_read → inital_syn → final_floorplan → place_opt → clock_opt → route_opt → signoff`

## How to run

Each stage is an `fc_shell` script sourced from the `work/` directory, in order.
Run a stage, review it (GUI/logs), then run the next:

```sh
cd work
fc_shell -f ../scripts/01_syn.tcl        -output_log_file ../logs/01_syn.log      # build lib + RTL + initial map
fc_shell -f ../scripts/05_floorplan.tcl  -output_log_file ../logs/05_floorplan.log # floorplan + boundary/tap + PG
fc_shell -f ../scripts/06_place.tcl      -output_log_file ../logs/06_place.log     # placement + optimization
fc_shell -f ../scripts/07_cts.tcl        -output_log_file ../logs/07_cts.log       # clock tree synthesis (+ skew report)
fc_shell -f ../scripts/08_route.tcl      -output_log_file ../logs/08_route.log     # routing
fc_shell -f ../scripts/09_signoff.tcl    -output_log_file ../logs/09_signoff.log   # filler, ICV DRC, metal fill, write data
```

Add `-gui` to any invocation to inspect the layout interactively.

To rerun from scratch, remove the design library and outputs:

```sh
rm -rf results/*.dlib results/*.dlib_backup results/* reports/* work/* logs/*
```

## Deliverables (emailed to staff)

- Clock-skew report:  `reports/clock_opt_clock_skew.rpt`
- Final timing report: `reports/chip_finish_report_timing_setup.rpt` (+ `_hold`)
- Final PG-DRC report: `reports/signoff_pg_drc.rpt`
- Final scripts: this `scripts/` + `Setup/` tree
- Location of the final Fusion Compiler run: `/project/advvlsi/users/yh3/ws/project_2026`
