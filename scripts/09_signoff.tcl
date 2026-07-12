#####################################################################
#####		Step 09 — Sign-off (chip finish)		#####
#####################################################################
#
# Adapted from Labs reference/labs/lab9_signoff/scripts/{signoff,write_data}.tcl
# (HW4, Lab 9). Inserts filler cells, runs ICV signoff DRC (+fix), metal fill,
# collects final reports, and writes out the design data (Verilog/SDC/SPEF/GDS).
#
# ICV (IC Validator) must be available on the host. Requires a routed block.
# Produces block: <DESIGN_NAME>/signoff  and top block <DESIGN_NAME>.
# Run headless from work/:
#   fc_shell -f ../scripts/09_signoff.tcl -output_log_file ../logs/09_signoff.log

#### Sourcing setup scripts
source -echo ../Setup/fc_common_setup.tcl
source -echo ../Setup/fc_flow_setup.tcl

#### Open the design library and branch a fresh block
open_lib ${RESULTS_PATH}/${DESIGN_LIBRARY}
# rerun-safe: drop stale target blocks from a previous run if present
if {[sizeof_collection [get_blocks -quiet ${DESIGN_NAME}/signoff]] > 0} {
	remove_blocks -force ${DESIGN_NAME}/signoff
}
if {[sizeof_collection [get_blocks -quiet ${DESIGN_NAME}]] > 0} {
	remove_blocks -force ${DESIGN_NAME}
}
copy_block -from ${DESIGN_NAME}/route_opt -to ${DESIGN_NAME}/signoff
open_block ${DESIGN_NAME}/signoff

#### Filler cell insertion (provided project script)
source -echo ../scripts/filler.tcl
check_legality

#### Remove placement blockages and re-fill those areas
remove_placement_blockages -all
source -echo ../scripts/filler.tcl
check_legality

#### Connect PG of the newly added filler cells
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
save_block

#### ICV in-design signoff DRC
set_host_options -target ICV -max_cores 2
set_app_options -name signoff.check_drc.runset             -value ${DRC_RUNSET_FILE}
set_app_options -name signoff.check_drc.max_errors_per_rule -value 1000
set_app_options -name signoff.check_drc.run_dir            -value "./signoff_drc_run/"
set_app_options -name signoff.physical.layer_map_file      -value ${GDS_MAP_FILE}
save_block

signoff_check_drc                  ;# authoritative foundry-rule DRC (results in ./signoff_drc_run/)
signoff_fix_drc                    ;# reruns the router to fix detected DRCs
save_block
signoff_check_drc                  ;# re-check after fixing

#### Signoff metal fill (density rules)
set_app_options -name signoff.create_metal_fill.runset -value ${MFILL_RUNSET_FILE}
signoff_report_metal_density -output ${REPORTS_PATH}/pre_metal_fill_density.rpt
signoff_create_metal_fill -select_layers {M2 M3 M4 M5 M6}
signoff_report_metal_density -output ${REPORTS_PATH}/post_metal_fill_density.rpt

#### Analyze the final design + deliverables
check_legality
report_congestion
report_utilization
report_pg_drc chip_finish          ;# Final PG (Power/Ground) DRC report (deliverable)
collect_reports chip_finish        ;# Final timing/power/area/qor reports (deliverables)

#### Write out design data (from lab9 write_data.tcl)
# Verilog netlist (logical cells only) and PG-annotated netlist
write_verilog -exclude {physical_only_cells} ${RESULTS_PATH}/${DESIGN_NAME}.v
write_verilog -include {pg_objects pg_netlist} ${RESULTS_PATH}/${DESIGN_NAME}.pg.v
# Constraints
write_sdc -output ${RESULTS_PATH}/${DESIGN_NAME}.sdc
# Parasitics
write_parasitics -format SPEF -output ${RESULTS_PATH}/${DESIGN_NAME}.spef
# GDS (merge the three linked Vt GDS libraries)
write_gds -design ${DESIGN_NAME} \
	-layer_map ${GDS_MAP_FILE} \
	-keep_data_type \
	-fill include \
	-output_pin all \
	-merge_files ${GDS_FILE} \
	-long_names \
	-lib_cell_view frame \
	${RESULTS_PATH}/${DESIGN_NAME}.gds

#### Save the final block under the design name
save_block
save_block -as ${DESIGN_NAME}
get_blocks -all
save_lib

# NOTE: no 'exit' — block/lib already saved; run 'gui_start' to inspect, 'exit' when done.
