#####################################################################
#####		Step 01 — Build Lib + Read RTL + Initial Synth	#####
#####################################################################
#
# Adapted from Labs reference/labs/lab1_inital_syn/scripts/inital_syn.tcl.
# Creates the design library against the three-Vt reference NDMs, reads the
# RISC-V RTL, elaborates, and runs initial technology mapping.
# Produces blocks: <DESIGN_NAME>/rtl_read and <DESIGN_NAME>/inital_syn.
#
# Run from the work/ directory:  fc_shell -f ../scripts/01_syn.tcl

#### Sourcing setup scripts
source -echo ../Setup/fc_common_setup.tcl
source -echo ../Setup/fc_flow_setup.tcl

#### Create the design library (TECH_FILE + three-Vt frame_timing ref libs)
create_lib ${RESULTS_PATH}/${DESIGN_LIBRARY} -technology ${TECH_FILE} -ref_libs ${REFERENCE_LIBRARY}

#### Report reference libraries
report_ref_libs

#### Read RTL — analyze the HDL
suppress_message VER-130
if {[string equal verilog ${HDL}]} {
	analyze -format verilog [glob ${VERILOG_PATH}/*.v]
} elseif {[string equal vhdl ${HDL}]} {
	analyze -format vhdl [glob ${VHDL_PATH}/*.vhd]
} else {
	echo "Error: HDL variable's value is not verilog or vhdl. Please fix the value."
}
unsuppress_message VER-130

#### Elaborate and link the top design
elaborate ${DESIGN_NAME}
set_top_module ${DESIGN_NAME}

#### Save the RTL-read block for later stages (floorplan copies this block)
save_block -as ${DESIGN_NAME}/rtl_read

#### Initial technology mapping
compile_fusion -to initial_map

#### Quick PPA sanity reports
report_timing
report_power
report_area

#### Gate-level netlist after initial mapping
write_verilog ${RESULTS_PATH}/${DESIGN_NAME}_initial_syn.v

#### Save blocks and library
current_block
save_block
save_block -as ${DESIGN_NAME}/inital_syn

get_blocks -all
save_lib

exit
