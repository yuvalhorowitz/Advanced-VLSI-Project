#####################################################################
#####      Common Setup Script for Fusion Compiler (Project)    #####
#####################################################################
#
# Adapted from Labs reference/labs/setup/fc_common_setup.tcl for the
# Advanced VLSI final project (RISC-V core, SAED14nm, Fusion Compiler).
#
# Runs from the project's work/ directory, one level under the repo root
# (== /project/advvlsi/users/yh3/ws/project_2026 on the VNC), so project
# inputs/outputs are reached with a single "../".
#
# Large SAED14 EDK data is referenced by absolute server path (EDK_ROOT)
# and is NOT committed to git. Only the small RISC-V RTL/SDC live in common/.

set DESIGN_NAME		"riscv_core"			; # top module (confirmed: riscv_core_all.v line 42)
set DESIGN_LIBRARY	"${DESIGN_NAME}.dlib"		; # design library name
set WORK_DIR		"[pwd]"				; # current working directory (expected: <repo>/work)

set CLOCK_PORT		"clk_i"				; # clock port (riscv.sdc: create_clock -period 10 [get_ports clk_i])
set RESET_PORT		"rst_i"				; # reset port (riscv.sdc: set_case_analysis 0 [get_port rst_i])

set LIBNAME		"saed14rvt"			; # primary std-cell library name
set CELL_PREFIX		"SAEDRVT14"			; # RVT cell prefix (used by PG/boundary/tap/CTS scripts)
set TECH_NODE		"saed14nm"			; # technology node name
set METAL_STACK		"1p9m"				; # metal stack

#####################################################################
#####      SAED14 EDK reference data (absolute server paths)    #####
#####################################################################

set EDK_ROOT		"/tech/synopsys/lib/SAED14_EDK"
set TECH_DATA		"${EDK_ROOT}/SAED14nm_EDK_TECH_DATA"

# Technology file (confirmed by project PDF)
set TECH_FILE		"${TECH_DATA}/tf/${TECH_NODE}_${METAL_STACK}.tf"
set TECH_NDM		"path/to/tech_ndm/if/exist"	; # only used when TECH_BASED == ndm

# Reference libraries: link all three Vt (LVT + RVT + HVT) frame_timing NDMs.
set REF_NDM		"base_frame_timing"		; # project uses *_base_frame_timing.ndm
set LVT_NDM		"${EDK_ROOT}/SAED14nm_EDK_STD_LVT/ndm/saed14lvt_${REF_NDM}.ndm"
set RVT_NDM		"${EDK_ROOT}/SAED14nm_EDK_STD_RVT/ndm/saed14rvt_${REF_NDM}.ndm"
set HVT_NDM		"${EDK_ROOT}/SAED14nm_EDK_STD_HVT/ndm/saed14hvt_${REF_NDM}.ndm"
set REFERENCE_LIBRARY	[list ${LVT_NDM} ${RVT_NDM} ${HVT_NDM}]

# Parasitics (tlup, confirmed by project PDF)
set TLUP_PATH		"${TECH_DATA}/tlup"
set TLUP_MIN_FILE	"${TLUP_PATH}/${TECH_NODE}_${METAL_STACK}_Cmin.tlup"
set TLUP_NOM_FILE	"${TLUP_PATH}/${TECH_NODE}_${METAL_STACK}_Cnom.tlup"
set TLUP_MAX_FILE	"${TLUP_PATH}/${TECH_NODE}_${METAL_STACK}_Cmax.tlup"

# nxtgrd alternative (only used when PARASITIC == nxtgrd)
set NXTGRD_PATH		"${TECH_DATA}/nxtgrd"
set NXTGRD_MIN_FILE	"${NXTGRD_PATH}/${TECH_NODE}_${METAL_STACK}_Cmin.nxtgrd"
set NXTGRD_NOM_FILE	"${NXTGRD_PATH}/${TECH_NODE}_${METAL_STACK}_Cnom.nxtgrd"
set NXTGRD_MAX_FILE	"${NXTGRD_PATH}/${TECH_NODE}_${METAL_STACK}_Cmax.nxtgrd"

# Layer map for read_parasitic_tech (needed from the floorplan stage on). Confirmed on VNC.
set MAP_PATH		"${TECH_DATA}/map"
set LAYER_MAP_FILE	"${MAP_PATH}/${TECH_NODE}_tf_itf_tluplus.map"

# Sign-off / GDS data (used at step 09). Confirmed on VNC.
set GDS_MAP_FILE	"${MAP_PATH}/${TECH_NODE}_${METAL_STACK}_gdsin_gdsout.map"
set DRC_RUNSET_FILE	"${TECH_DATA}/icv_drc/${TECH_NODE}_${METAL_STACK}_drc_rules.rs"
set MFILL_RUNSET_FILE	"${TECH_DATA}/icv_drc/${TECH_NODE}_${METAL_STACK}_mfill_rules.rs"

# GDS merge files — one per linked Vt library (write_gds -merge_files).
set GDS_FILE		[list \
	"${EDK_ROOT}/SAED14nm_EDK_STD_LVT/gds/saed14lvt.gds" \
	"${EDK_ROOT}/SAED14nm_EDK_STD_RVT/gds/saed14rvt.gds" \
	"${EDK_ROOT}/SAED14nm_EDK_STD_HVT/gds/saed14hvt.gds" ]

# Liberty .db (only used for a frame_only fallback; set from fc_flow_setup.tcl)
set LIBERTY_PATH	"${EDK_ROOT}/liberty"

#####################################################################
#####      Project inputs (committed under ../common)           #####
#####################################################################

set RTL_PATH		"${WORK_DIR}/../common/rtl"
set VERILOG_PATH	"${RTL_PATH}/verilog"			; # riscv_core_all.v, riscv_defs.v
set VHDL_PATH		"${RTL_PATH}/vhdl"
set SDC_PATH		"${WORK_DIR}/../common/sdc"
set SDC_FILE		"${SDC_PATH}/riscv.sdc"

#####################################################################
#####      Project outputs (committed under ../results, ../reports) #####
#####################################################################

set RESULTS_PATH	"${WORK_DIR}/../results"			; # design library + final netlists/gds/def
set REPORTS_PATH	"${WORK_DIR}/../reports"			; # all .rpt deliverables

#### Source the reporting utilities
source ${WORK_DIR}/../setup/utilities.tcl
