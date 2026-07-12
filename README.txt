========================================================================
 RISC-V RTL-to-GDS - Results & Deliverables
========================================================================
 Advanced VLSI final project - RISC-V core (riscv_core), SAED14nm 1p9m,
 Synopsys Fusion Compiler.

 This file lists WHERE the deliverables live and EVERY metric extractable
 from the run reports (non-GUI). Values are the final signed-off design
 (chip_finish / signoff block).
 See IMPLEMENTATION.md for the build log and ISSUES_AND_FIXES.md for the
 provided-file bugs and the accepted residual DRCs.


------------------------------------------------------------------------
 1. PROJECT DIRECTORY STRUCTURE
------------------------------------------------------------------------
 project_2026/   (== /project/advvlsi/users/yh3/ws/project_2026 on VNC)

   Setup/      configuration sourced by every stage:
                 fc_common_setup.tcl  fc_flow_setup.tcl  tech_setup.tcl
                 mcmm_setup.tcl  utilities.tcl
   scripts/    flow drivers + provided helper scripts:
                 01_syn.tcl 05_floorplan.tcl 06_place.tcl 07_cts.tcl
                 08_route.tcl 09_signoff.tcl
                 create_pg_network.tcl  insert_boundary_and_tap_cells.tcl
                 route.tcl  filler.tcl
   common/     committed inputs: rtl/verilog/{riscv_core_all.v,riscv_defs.v},
                 sdc/riscv.sdc
   work/       fc_shell run directory (launch stages here)
   results/    design library + netlists/sdc
                 (GDS & SPEF are on the VNC only - >100 MB, git-ignored)
   reports/    all .rpt reports (tracked)
   logs/       per-stage run logs (tracked)

 Block progression (design library results/riscv_core.dlib):
   rtl_read -> inital_syn -> final_floorplan -> place_opt -> clock_opt
   -> route_opt -> signoff


------------------------------------------------------------------------
 2. REQUIRED DELIVERABLES (per Adv_VLSI_Project_2026.pdf)
------------------------------------------------------------------------
 Final scripts .............. Setup/*.tcl, scripts/01_syn.tcl .. 09_signoff.tcl
 Clock-skew report .......... reports/clock_opt_clock_skew.rpt
                              (report_clock_timing -type skew)
 Final timing report ........ reports/chip_finish_report_timing_setup.rpt
                              (and _hold)
 Final PG-DRC report ........ reports/chip_finish_pg_drc.rpt
                              ICV: work/signoff_drc_run/riscv_core.RESULTS
                                   and .LAYOUT_ERRORS
 Final GDS .................. results/riscv_core.gds  (on VNC; git-ignored)
 Final netlists/constraints . results/riscv_core.v, riscv_core.pg.v,
                              riscv_core.sdc, riscv_core.spef.*
 Location of final FC run ... /project/advvlsi/users/yh3/ws/project_2026
 Email deliverable .......... to webb@tauex.tau.ac.il, adiinbar2@mail.tau.ac.il
                              (team names + IDs + run location)


------------------------------------------------------------------------
 3. METRICS SUMMARY (final design - chip_finish)
------------------------------------------------------------------------

 AREA / DESIGN  (chip_finish_report_area/design/qor.rpt)
   Ports ............................ 1,868
   Nets ............................. 14,503
   Total cells ...................... 12,334
   Combinational cells .............. 10,015
   Sequential cells ................. 2,319
   Buf/Inv cells .................... 1,318
   Cell references (masters) ........ 136
   Combinational area ............... 3,865.82 um2
   Noncombinational area ............ 2,879.65 um2
   Buf/Inv area ..................... 266.13 um2
   Total cell area (netlist) ........ 6,745.47 um2
   Cell area (netlist + phys-only) .. 10,699.16 um2
   Core area ........................ 10,699.16 um2
   Chip area ........................ 12,867.90 um2
   Master clocks .................... 1 (clk_i)

 TIMING  (chip_finish_report_qor/timing_setup/hold.rpt) - clk_i, 10 ns
   Scenario          Setup WNS   Setup TNS   Setup viol.  Hold viol.  Met?
   FUNC_Slow         +4.09 ns    0           0            (not chkd)  YES
   FUNC_Typical      +7.07 ns    0           0            0           YES
   FUNC_Fast         (not chkd)  -           -            0           YES
   (setup checked in Slow/Typical, hold in Fast/Typical; all met.)

 POWER  (chip_finish_report_power.rpt) - total per corner
   FUNC_Fast ........ dynamic 0.760 mW   leakage N/A (disabled in scenario)
   FUNC_Typical ..... dynamic 0.587 mW   leakage 1.59e6 pW (~1.6 uW)
   FUNC_Slow ........ dynamic 0.442 mW   leakage 4.66e4 pW (~47 nW)

 CLOCK TREE / CTS  (clock_opt_clock_skew.rpt, logs/07_cts.log)
   Worst clock skew ................. 0.10 ns (Slow)
   Clock-pin latency range .......... 0.03 - 0.13 ns
   Clock buffers inserted ........... 62 (3 levels)
   Target skew ...................... 0.1 ns

 PLACEMENT / ROUTING QUALITY
   Utilization ...................... 63.05 %   (route_opt_utilization.rpt)
   Global-route overflow ............ 821 (0.84 %)  (route_opt_congestion.rpt)
   Signal-route DRCs ................ 0         (route_opt_check_routes.rpt)
   Total wires ...................... 137,743   (route_opt_check_routes.rpt)
   Redundant-via (double-cut) rate .. 38.3 %    (route_opt_check_routes.rpt)

 DRC - ICV SIGN-OFF (authoritative)  (logs/09_signoff.log, work/signoff_drc_run/)
   Total ICV DRC violations ......... 5 (accepted)
   Breakdown ........................ 3x M5.S.2.1, 2x M9.S.3.1
                                      (minor M5/M9 metal spacing)
   History .......................... 61 -> 5 after M6 PG-mesh spacing fix
                                      + ICV auto-repair

 PG CONNECTIVITY / BUILT-IN PG-DRC  (chip_finish_pg_drc.rpt)
   Floating std cells (VDD / VSS) ... 0 / 0
   Floating wires / terminals ....... 0 / 0
   Built-in check_pg_drc entries .... 1,245 (M1/VIA0) - net-tracing artifacts,
                                      NOT real (ICV is clean; see
                                      ISSUES_AND_FIXES.md)

 LVS  (route_opt_check_lvs.rpt)
   Built-in check_lvs shorts/opens are the same PG net-tracing artifacts
   (VDD/VSS have no top-level port pins). A true sign-off LVS was not run
   (not a project deliverable). See ISSUES_AND_FIXES.md.

 METAL DENSITY AFTER FILL  (post_metal_fill_density.rpt)
   M2 40.5 %   M3 37.6 %   M4 46.3 %   M5 50.7 %
   M6 45.3 %   M7 6.3 %    M8 0.8 %    M9 0.07 %


------------------------------------------------------------------------
 4. REPORT FILE INDEX
------------------------------------------------------------------------
 Each stage writes reports/<stage>_*.rpt via collect_reports
 (Setup/utilities.tcl), so metrics compare stage-to-stage:
 final_floorplan_ -> place_opt_ -> clock_opt_ -> route_opt_ -> chip_finish_

 <stage>_report_area.rpt ......... report_area
     cell counts, comb/noncomb/total cell area
 <stage>_report_design.rpt ....... report_design
     core/chip area, clocks, library cell summary
 <stage>_report_qor.rpt .......... report_qor
     WNS/TNS/violating-paths per scenario, cell area netlist vs physical, DRC
 <stage>_report_timing_setup.rpt . report_timing -delay_type max  (setup)
 <stage>_report_timing_hold.rpt .. report_timing -delay_type min  (hold)
 <stage>_report_power.rpt ........ report_power -scenarios [all_scenarios]
     dynamic/leakage/total power per corner
 <stage>_pg_drc.rpt .............. report_pg_drc
     (check_pg_connectivity + check_pg_drc): PG floating count + PG-DRC
 clock_opt_clock_skew.rpt ........ report_clock_skew
     (report_clock_timing -type skew): worst clock skew + latency
 route_opt_check_routes.rpt ...... check_routes: routing DRCs, wire/via counts
 route_opt_check_lvs.rpt(_full) .. check_lvs: shorts / opens / floating routes
 route_opt_congestion.rpt ........ report_congestion: global-route overflow
 route_opt_utilization.rpt ....... report_utilization: core utilization
 pre_/post_metal_fill_density.rpt  signoff_report_metal_density: metal density

 Full command transcripts are in logs/NN_<stage>.log
 (some tool output uses control characters - read with 'grep -a').
========================================================================
