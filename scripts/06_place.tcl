#####################################################################
#####		Step 06 — Placement + Optimization		#####
#####################################################################
#
# Adapted from Labs reference/labs/lab6_placement/scripts/place_opt.tcl.
# Runs unified placement + optimization on the floorplanned block.
# Defaults only (no high-effort knobs yet — see IMPLEMENTATION.md decision;
# turn them on only if timing fails to close).
#
# Produces block: <DESIGN_NAME>/place_opt
# Run headless from work/:
#   fc_shell -f ../scripts/06_place.tcl -output_log_file ../logs/06_place.log

#### Sourcing setup scripts
source -echo ../Setup/fc_common_setup.tcl
source -echo ../Setup/fc_flow_setup.tcl

#### Open the design library and branch a fresh block
open_lib ${RESULTS_PATH}/${DESIGN_LIBRARY}
# rerun-safe: drop a stale target block from a previous run if present
if {[sizeof_collection [get_blocks -quiet ${DESIGN_NAME}/place_opt]] > 0} {
	remove_blocks -force ${DESIGN_NAME}/place_opt
}
copy_block -from ${DESIGN_NAME}/final_floorplan -to ${DESIGN_NAME}/place_opt
open_block ${DESIGN_NAME}/place_opt

#### Placement application options
# No scandef in this flow — allow placement to continue without it.
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name opt.common.user_instance_name_prefix      -value place_opt

#### Placement + optimization (unified engine: coarse place, HFNS, opt, legalize)
place_opt

#### Connect PG nets to the now-placed standard cells
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]

#### Analyze the design
check_legality
report_congestion
report_utilization
report_pg_drc place_opt
collect_reports place_opt

get_blocks -all
save_block
save_lib

# NOTE: no 'exit' — block/lib already saved; run 'gui_start' to inspect, 'exit' when done.
