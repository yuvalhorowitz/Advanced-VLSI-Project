#####################################################################
#####	   Utilities for Fusion Compiler (Project)		#####
#####################################################################
#
# Based on Labs reference/labs/setup/utilities.tcl. Reports are written
# to ${REPORTS_PATH} (../reports, one level up from work/) so the paths
# match this project's flatter layout. Two extra procs produce the
# project deliverables (clock-skew and PG-DRC) with stable file names.

proc collect_reports {stage_name} {
	global REPORTS_PATH
	echo "Collecting reports for ${stage_name} stage..."
	redirect -file ${REPORTS_PATH}/${stage_name}_report_power.rpt        {report_power   -scenarios [all_scenarios]}
	redirect -file ${REPORTS_PATH}/${stage_name}_report_timing_setup.rpt {report_timing  -scenarios [all_scenarios] -delay_type max}
	redirect -file ${REPORTS_PATH}/${stage_name}_report_timing_hold.rpt  {report_timing  -scenarios [all_scenarios] -delay_type min}
	redirect -file ${REPORTS_PATH}/${stage_name}_report_area.rpt         {report_area}
	redirect -file ${REPORTS_PATH}/${stage_name}_report_qor.rpt          {report_qor}
	redirect -file ${REPORTS_PATH}/${stage_name}_report_design.rpt       {report_design}
	echo "Reports are generated for ${stage_name} stage."
}

# Clock-skew report (project deliverable) — produced after CTS.
proc report_clock_skew {stage_name} {
	global REPORTS_PATH
	echo "Collecting clock-skew report for ${stage_name} stage..."
	redirect -file ${REPORTS_PATH}/${stage_name}_clock_skew.rpt \
		{report_clock_timing -type skew -scenarios [all_scenarios]}
}

# PG connectivity + DRC report (project deliverable) — produced at sign-off.
proc report_pg_drc {stage_name} {
	global REPORTS_PATH
	echo "Collecting PG connectivity/DRC report for ${stage_name} stage..."
	redirect -file ${REPORTS_PATH}/${stage_name}_pg_drc.rpt {
		check_pg_connectivity
		check_pg_drc
	}
}
