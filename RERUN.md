# Rerun the RISC-V RTL-to-GDS flow from scratch

Full flow on the TAU VNC, in `/project/advvlsi/users/yh3/ws/project_2026`.
Six stages, run in order; each reads the previous stage's block from the design library.

## 0. Prerequisites (once)
```sh
cd /project/advvlsi/users/yh3/ws/project_2026
git pull                                  # get the latest scripts

# inputs must be present (copied once from the EDK):
#   common/rtl/verilog/riscv_core_all.v
#   common/rtl/verilog/riscv_defs.v
#   common/sdc/riscv.sdc
ls common/rtl/verilog common/sdc          # confirm inputs exist
```
Large EDK data (tech file, NDMs, tlup, runsets, GDS) is referenced by absolute path in
`Setup/fc_common_setup.tcl` (`EDK_ROOT=/tech/synopsys/lib/SAED14_EDK`) — nothing to copy.

## 1. Clean (start from scratch)
Removes the design library, all outputs, and scratch so `01_syn` can recreate the library:
```sh
./clean.sh
mkdir -p logs                              # (clean leaves logs/ ignored)
```

## 2. Run the six stages (from `work/`)
```sh
cd work
fc_shell -f ../scripts/01_syn.tcl        -output_log_file ../logs/01_syn.log       # build lib + read RTL + initial map
fc_shell -f ../scripts/05_floorplan.tcl  -output_log_file ../logs/05_floorplan.log  # floorplan + boundary/tap + PG
fc_shell -f ../scripts/06_place.tcl      -output_log_file ../logs/06_place.log      # placement + optimization
fc_shell -f ../scripts/07_cts.tcl        -output_log_file ../logs/07_cts.log        # clock tree synthesis (+ skew report)
fc_shell -f ../scripts/08_route.tcl      -output_log_file ../logs/08_route.log      # signal routing
fc_shell -f ../scripts/09_signoff.tcl    -output_log_file ../logs/09_signoff.log    # filler + ICV DRC + metal fill + write GDS
```
Add `-gui` to any line to watch that stage. Each script saves its block and library and does
**not** exit, so the shell/GUI stays open for inspection (type `exit` when done).

### Alternative: already inside `fc_shell`
Run all six back-to-back in one session (per-stage logs still written):
```tcl
foreach s {01_syn 05_floorplan 06_place 07_cts 08_route 09_signoff} \
    {redirect -file ../logs/$s.log {source -echo ../scripts/$s.tcl}}
```

## 3. Notes
- Stages are **rerun-safe**: `01_syn` creates the library (needs a clean first, or `create_lib`
  errors that it exists); `05`–`09` drop any stale target block before re-creating it, so a
  single stage can be rerun without a full clean.
- Numbering follows the lab labs (1,5,6,7,8,9). Labs 2–4 (constraints, MCMM, compile_flow) are
  folded into `Setup/mcmm_setup.tcl` + the synthesis/placement stages.
- Block chain: `rtl_read -> inital_syn -> final_floorplan -> place_opt -> clock_opt -> route_opt -> signoff`.

## 4. After the run — where the outputs land
- Reports: `reports/<stage>_*.rpt` (clock skew, timing, power, area, qor, PG-DRC, …).
- Design data: `results/riscv_core.{v,pg.v,sdc,gds}` and `results/riscv_core.spef.*`.
- ICV sign-off DRC details: `work/signoff_drc_run/riscv_core.RESULTS` and `.LAYOUT_ERRORS`.
- Logs: `logs/NN_<stage>.log` (read with `grep -a`; some tool output has control characters).

## 5. Commit results back (optional)
```sh
cd /project/advvlsi/users/yh3/ws/project_2026
git add -A && git commit -m "flow rerun" && git push
```
GDS and SPEF are git-ignored (>100 MB) — they stay on the VNC; reports and small netlists are tracked.
