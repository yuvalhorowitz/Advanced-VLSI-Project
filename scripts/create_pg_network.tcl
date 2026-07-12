#####################################################################
#####			Create PG Network Script		#####
#####################################################################
create_net -power VDD
create_net -ground VSS


#### Remove PG related data
remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all
remove_routes -ring -stripe -lib_cell_pin_connect 

#### Set PG net attribute
set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

#### Create VIA strategy rule VIA_NIL
set_pg_strategy_via_rule VIA_NIL -via_rule { {intersection: undefined} {via_master: NIL} }

#### Create PG Rails for standard cells
create_pg_std_cell_conn_pattern M1_rail -layers {M1} -rail_width {@wtop @wbottom} -parameters {wtop wbottom}

set_pg_strategy M1_rail_strategy_pwr -core -pattern {{name: M1_rail} {nets: VDD} {parameters: {0.094 0.094}}}
set_pg_strategy M1_rail_strategy_gnd -core -pattern {{name: M1_rail} {nets: VSS} {parameters: {0.094 0.094}}}

compile_pg -strategies M1_rail_strategy_pwr -ignore_drc
compile_pg -strategies M1_rail_strategy_gnd -ignore_drc


#### Create PG Rings
create_pg_ring_pattern \
                 PG_Ring_VSS \
                 -horizontal_layer M6  -vertical_layer M7  \
                 -horizontal_width 1 -vertical_width 1 \
                 -horizontal_spacing 1 -vertical_spacing 1

set_pg_strategy PG_Ring_VSS -core -pattern {{ name: PG_Ring_VSS} { nets: "VSS" } {offset: 0.5}}

create_pg_ring_pattern \
                 PG_Ring_VDD \
                 -horizontal_layer M4  -vertical_layer M5 \
                 -horizontal_width 1 -vertical_width 1 \
                 -horizontal_spacing 1 -vertical_spacing 1

set_pg_strategy PG_Ring_VDD -core -pattern {{ name: PG_Ring_VDD} { nets: "VDD" } {offset: 0.5}}

compile_pg -strategies { PG_Ring_VDD PG_Ring_VSS } -via_rule VIA_NIL

# NOTE (Option B): the provided script created M4 *vertical* straps + M4->M1 vias,
# but tech_setup declares M4 horizontal (lab convention), so M4 straps could not
# via down to the horizontal M1 rails and VSS was left floating. We drop the M4
# straps and distribute vertically on M5 (M5->M1), exactly like the lab PG.
# (Original M4-strap version kept in backups/create_pg_network.provided_M4stack.tcl.)

#### Create M5 Vertical PG Straps
create_pg_mesh_pattern M5_PG \
        -layers { {vertical_layer: M5}   {width: 0.1} {spacing: interleaving} {pitch: 4} {offset: 0.5} }

set_pg_strategy M5_PG_Strategy \
        -core \
        -pattern   { {name: M5_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M5_PG_Strategy} -via_rule VIA_NIL

#### Create M6 Horizontal PG Straps
# Narrower + sparser than the provided 0.2/pitch-4 to clear M6.S.3.x spacing DRCs
# reported by ICV signoff_check_drc (interleaved 0.2-wide straps were too close).
create_pg_mesh_pattern M6_PG \
        -layers { {horizontal_layer: M6}   {width: 0.1} {spacing: interleaving} {pitch: 8} {offset: 0.5} }

set_pg_strategy M6_PG_Strategy \
        -core \
        -pattern   { {name: M6_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M6_PG_Strategy} -via_rule VIA_NIL

#### Create M7 Vertical PG Straps
# Match M6: narrower + sparser to avoid M7 spacing DRCs.
create_pg_mesh_pattern M7_PG \
        -layers { {vertical_layer: M7}   {width: 0.1} {spacing: interleaving} {pitch: 8} {offset: 0.5} }

set_pg_strategy M7_PG_Strategy \
        -core \
        -pattern   { {name: M7_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M7_PG_Strategy} -via_rule VIA_NIL


#### Create PG VIAs (distribute down from the M5 vertical mesh to the M1 rails)
create_pg_vias -from_layers M5 -to_layers M1 -via_masters default -nets {VDD VSS}
create_pg_vias -from_layers M6 -to_layers M5 -via_masters default -nets {VDD VSS}
create_pg_vias -from_layers M7 -to_layers M6 -via_masters default -nets {VDD VSS}

#### Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]

#### Check created PG structure
check_pg_connectivity
check_pg_drc
