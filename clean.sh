#!/bin/sh
#####################################################################
#####   Reset the working area (equivalent to the labs' clean)  #####
#####################################################################
# Removes the Fusion Compiler design library, generated outputs and
# scratch so a stage can be rerun from a clean state. Source inputs
# (Setup/, scripts/, common/) are never touched.
#
# Usage (from anywhere):  sh clean.sh   [or]   ./clean.sh

cd "$(dirname "$0")" || exit 1

rm -rf results/*.dlib results/*.dlib_backup
rm -f  results/*.v results/*.def results/*.sdc results/*.spef results/*.gds
rm -f  reports/*.rpt
rm -rf work/* logs/*

# keep the empty tracked dirs alive in git
touch work/.gitkeep results/.gitkeep reports/.gitkeep

echo "clean: reset results/, reports/, work/, logs/ (sources kept)."
