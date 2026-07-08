#####################################################################
#####           Phase 2: Logic Synthesis & Mapping              #####
#####################################################################

# 1. Define Variables & Paths
set DESIGN_NAME "riscv_core"
set DESIGN_LIBRARY "../results/${DESIGN_NAME}.dlib"

set RTL_DIR "/tech/synopsys/Adv_VLSI_2026/riscv_rtl"
set VERILOG_FILES [list \
    "${RTL_DIR}/riscv_defs.v" \
    "${RTL_DIR}/riscv_core_all.v" \
]
set SDC_FILE "${RTL_DIR}/riscv.sdc"

# -------------------------------------------------------------------

# 2. Open Library
echo "INFO: Opening Design Library..."
open_lib $DESIGN_LIBRARY

# 3. Read and Elaborate RTL
echo "INFO: Analyzing and Elaborating RTL..."
analyze -format verilog $VERILOG_FILES
elaborate $DESIGN_NAME
set_top_module $DESIGN_NAME

# Save block after reading RTL
save_block -as ${DESIGN_NAME}/rtl_read
current_block ${DESIGN_NAME}/rtl_read

# 4. Apply Constraints & MCMM Setup
echo "INFO: Sourcing MCMM and Constraints..."
# Note: Ensure your mcmm_setup.tcl points to the new SDC_FILE defined above
source -echo ../setup/mcmm_setup.tcl

# 5. Synthesis: Initial Mapping
echo "INFO: Running Initial Map..."
# Prevent usage of specific unwanted cells (as done in your labs)
set_lib_cell_purpose -include none {*/*_AO21* */*V2LP*}

# Run synthesis to map to technology-dependent gates
compile_fusion -to initial_map

# 6. Save the mapped block
save_block -as ${DESIGN_NAME}/initial_map
save_lib

# Optional: Generate reports to check baseline PPA
report_timing -delay_type max
report_power
report_area

echo "INFO: Phase 2 Complete. Initial mapping saved."
