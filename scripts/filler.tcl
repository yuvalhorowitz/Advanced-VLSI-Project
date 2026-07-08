set FILLER_CELLS [get_object_name [sort_collection -descending \
[get_lib_cells */*_FILL* -filter "name !~ *_LVLFILL* AND name !~ *FILLP* \
AND name !~ *ECO* AND name !~ *Y2* AND name !~ *SPACER*"] area]]
create_stdcell_fillers -lib_cells ${FILLER_CELLS}
