#####################################################################
#####      Flow Setup Script for Fusion Compiler (Project)      #####
#####################################################################
#
# Adapted from Labs reference/labs/setup/fc_flow_setup.tcl.

set TECH_BASED	"tf"				; # "tf" for TECH_FILE-based flow, "ndm" for TECH_NDM-based flow
set PARASITIC	"tlup"				; # "tlup" for TLUP files, "nxtgrd" for NXTGRD files
set HDL		"verilog"			; # "verilog" or "vhdl"

# PVT operating conditions (SAED14 RVT liberty corners)
set PVT_FF	"ff0p88v125c"			; # Fast corner
set PVT_TT	"tt0p8v25c"			; # Typical corner
set PVT_SS	"ss0p72vm40c"			; # Slow corner

# Liberty .db per corner (only used for a frame_only fallback; frame_timing gets timing from NDM)
set DB_FF	"${LIBERTY_PATH}/${LIBNAME}_${PVT_FF}.db"
set DB_TT	"${LIBERTY_PATH}/${LIBNAME}_${PVT_TT}.db"
set DB_SS	"${LIBERTY_PATH}/${LIBNAME}_${PVT_SS}.db"

# Compute resources (RISC-V core is larger than the lab i2c design)
set_host_options -max_cores 8
