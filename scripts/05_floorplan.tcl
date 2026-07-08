#####################################################################
#####		Step 05 — Floorplan + PG Network		#####
#####################################################################
#
# Adapted from Labs reference lab5 (5.2 manual floorplan + 5.3 read/PG).
# Creates the floorplan from scratch (no pre-made DEF), inserts boundary/tap
# cells, and builds the Power/Ground network.
#
# NOTE: we branch from the MAPPED block 'inital_syn' (not 'rtl_read'):
# initialize_floorplan sizes the die by -core_utilization, which needs real
# standard-cell area. The lab branched from rtl_read only because it read a
# pre-built floorplan.def with an absolute die size.
#
# Produces block: <DESIGN_NAME>/final_floorplan
# Run headless from work/:
#   fc_shell -f ../scripts/05_floorplan.tcl -output_log_file ../logs/05_floorplan.log

#### Sourcing setup scripts
source -echo ../Setup/fc_common_setup.tcl
source -echo ../Setup/fc_flow_setup.tcl

#### Open the design library and branch a fresh block
open_lib ${RESULTS_PATH}/${DESIGN_LIBRARY}
copy_block -from ${DESIGN_NAME}/inital_syn -to ${DESIGN_NAME}/final_floorplan
open_block ${DESIGN_NAME}/final_floorplan

#### Tech setup (site defs, parasitics, routing directions)
source -echo ../Setup/tech_setup.tcl

#### Constraints + MCMM (timing becomes real from here on)
read_sdc -echo ${SDC_FILE}
source -echo ../Setup/mcmm_setup.tcl

#### Initialize the floorplan (tune these for the RISC-V core size)
initialize_floorplan \
	-control_type core \
	-core_utilization 0.60 \
	-core_offset 5 \
	-shape R \
	-side_ratio {1 1} \
	-flip_first_row true

#### Pin placement constraints
# Signal pins on M3/M4, left+bottom sides; clock pin on top (M5).
set ports [remove_from_collection [get_ports] [get_ports {VDD VSS}]]

set_block_pin_constraints -self \
	-allowed_layers {M3 M4} \
	-sides {1 4} \
	-pin_spacing_distance 1 \
	-width 0.11 \
	-length 0.11

set_individual_pin_constraints \
	-ports [get_ports ${CLOCK_PORT}] \
	-sides 2 \
	-allowed_layers M5

place_pins -self -ports ${ports}

#### Insert boundary and TAP cells (provided script; SAEDRVT14 prefix)
source -echo ../scripts/insert_boundary_and_tap_cells.tcl

#### Create the Power/Ground network (provided script; rails/rings/mesh/vias + checks)
source -echo ../scripts/create_pg_network.tcl

#### Save the floorplan for the record (script form + DEF)
write_floorplan -output ${RESULTS_PATH}/write_floorplan_files
write_def ${RESULTS_PATH}/${DESIGN_NAME}_floorplan.def

#### Analyze and collect reports
report_utilization
report_pg_drc final_floorplan
collect_reports final_floorplan

get_blocks -all
save_block
save_lib

# NOTE: no 'exit' — block/lib already saved; run 'gui_start' to inspect, 'exit' when done.
