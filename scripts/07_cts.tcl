#####################################################################
#####		Step 07 — Clock Tree Synthesis (CTS)		#####
#####################################################################
#
# Adapted from Labs reference/labs/lab7_cts/scripts/clock_opt.tcl (HW4, Lab 7).
# Synthesizes and optimizes the clock tree, detail-routes the clock with an NDR,
# shields the clock nets with VSS, then reports skew (project deliverable).
#
# Requires a placed + legalized + optimized block (place_opt).
# Produces block: <DESIGN_NAME>/clock_opt
# Run headless from work/:
#   fc_shell -f ../scripts/07_cts.tcl -output_log_file ../logs/07_cts.log

#### Sourcing setup scripts
source -echo ../Setup/fc_common_setup.tcl
source -echo ../Setup/fc_flow_setup.tcl

#### Open the design library and branch a fresh block
open_lib ${RESULTS_PATH}/${DESIGN_LIBRARY}
# rerun-safe: drop a stale target block from a previous run if present
if {[sizeof_collection [get_blocks -quiet ${DESIGN_NAME}/clock_opt]] > 0} {
	remove_blocks -force ${DESIGN_NAME}/clock_opt
}
copy_block -from ${DESIGN_NAME}/place_opt -to ${DESIGN_NAME}/clock_opt
open_block ${DESIGN_NAME}/clock_opt

#### CTS application options (restrict fanout, enable relocation + sizing)
set_app_options -name cts.common.max_fanout                                -value 50
set_app_options -name cts.compile.enable_cell_relocation                   -value timing_aware
set_app_options -name cts.compile.size_pre_existing_cell_to_cts_references  -value true
set_app_options -name cts.common.user_instance_name_prefix                 -value clock_opt

#### Improve routability
set_app_options -name route.common.wire_on_grid_by_layer_name -value {{M1 true } {M2 true} {M3 true}}
set_app_options -name route.common.via_on_grid_by_layer_name  -value {{VIA1 false} {VIA2 true}}

#### Specify the driving cell on the clock input port (no I/O pad in this design)
set_driving_cell -lib_cell ${CELL_PREFIX}_BUF_16 [get_ports ${CLOCK_PORT}]

#### Restrict which cells CTS may use (RVT inverters/buffers)
set_lib_cell_purpose -include cts \
	{*/SAEDRVT14_INV_1 */SAEDRVT14_INV_2 */SAEDRVT14_INV_4 */SAEDRVT14_INV_8 */SAEDRVT14_INV_16 */SAEDRVT14_INV_20 \
	 */SAEDRVT14_BUF_2 */SAEDRVT14_BUF_4 */SAEDRVT14_BUF_6 */SAEDRVT14_BUF_8 */SAEDRVT14_BUF_16 */SAEDRVT14_BUF_20 }

#### Non-Default Routing rule for the clock (2x width/spacing + shielding)
create_routing_rule CLK_NDR \
	-default_reference_rule \
	-multiplier_width 2 \
	-multiplier_spacing 2 \
	-shield \
	-shield_widths {M1 0 M2 0 M3 0 M4 0} \
	-snap_to_track

# Apply the NDR and bound the clock routing layers
set_clock_routing_rules -rules CLK_NDR \
	-min_routing_layer M2 \
	-max_routing_layer M5

#### Target skew for the clock tree
set_clock_tree_options -clocks [all_clocks] -target_skew 0.1

#### clock_opt flow
get_clocks
clock_opt -list_only

# 1. Synthesize + optimize the clock tree (clock globally routed)
clock_opt -to build_clock
# 2. Detail-route the clock nets per the NDR
clock_opt -from build_clock -to route_clock
# 3. Final optimization + legalization
clock_opt -to final_opto

#### Remove global routes before creating shields (shielding requires no global route)
remove_routes -global_route

#### Shield the clock nets with VSS
set clock_nets [get_nets -hierarchical -filter "net_type == clock"]
create_shields -nets ${clock_nets} -with_ground VSS -preferred_direction_only true -align_to_shape_end true

#### Connect PG nets (CTS added buffers/inverters)
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]

#### Analyze the design + collect reports
check_legality
report_congestion
report_utilization
collect_reports clock_opt
report_clock_skew clock_opt        ;# project deliverable: report_clock_timing -type skew

get_blocks -all
save_block
save_lib

# NOTE: no 'exit' — block/lib already saved; run 'gui_start' to inspect, 'exit' when done.
