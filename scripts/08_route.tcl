#####################################################################
#####		Step 08 — Signal Routing			#####
#####################################################################
#
# Adapted from Labs reference/labs/lab8_routing/scripts/route_opt.tcl (HW4, Lab 8).
# Routes the signal nets (global -> track -> detail), optimizes, adds redundant
# vias, and checks routes/LVS. Uses the project-provided routing rules in
# scripts/route.tcl (metal directions, on-grid, min_routing_layer M2).
#
# Requires a CTS'd block (clock_opt).
# Produces block: <DESIGN_NAME>/route_opt
# Run headless from work/:
#   fc_shell -f ../scripts/08_route.tcl -output_log_file ../logs/08_route.log

#### Sourcing setup scripts
source -echo ../Setup/fc_common_setup.tcl
source -echo ../Setup/fc_flow_setup.tcl

#### Open the design library and branch a fresh block
open_lib ${RESULTS_PATH}/${DESIGN_LIBRARY}
# rerun-safe: drop a stale target block from a previous run if present
if {[sizeof_collection [get_blocks -quiet ${DESIGN_NAME}/route_opt]] > 0} {
	remove_blocks -force ${DESIGN_NAME}/route_opt
}
copy_block -from ${DESIGN_NAME}/clock_opt -to ${DESIGN_NAME}/route_opt
open_block ${DESIGN_NAME}/route_opt

#### Timing-driven routing application options
set_app_options -name route.global.timing_driven                     -value true
set_app_options -name route.track.timing_driven                      -value true
set_app_options -name route.detail.timing_driven                     -value true
set_app_options -name route.global.force_rerun_after_global_route_opt -value true

#### Project routing rules (metal directions, on-grid, min_routing_layer M2)
source -echo ../scripts/route.tcl

#### Pre-route info + routability check
sizeof_collection [get_nets -hierarchical *]
report_ignored_layers
report_scenarios
check_routability

#### Signal routing: global -> track -> detail  (route_auto runs all three)
route_auto

#### Routing optimization + DFM redundant vias + ECO fix
route_opt
add_redundant_vias
route_eco

#### Check routing quality
check_routes
check_lvs

#### Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]

#### Analyze the design + collect reports
check_legality
report_congestion
report_utilization
report_pg_drc route_opt        ;# post-route PG check (should now resolve the pre-route NULL-net shorts)
collect_reports route_opt

get_blocks -all
save_block
save_lib

# NOTE: no 'exit' — block/lib already saved; run 'gui_start' to inspect, 'exit' when done.
