#####################################################################
#####			Create PG Network Script		#####
#####################################################################
#
# ====================================================================
# ORIGINAL COURSE-PROVIDED FILE — kept verbatim for reference.
# This is scripts/create_pg_network.tcl exactly as it was handed out
# (git commit a97dab4, before any of our fixes). DO NOT run this in the
# flow; it is here only to document the defects. Two independent bugs
# live in the "Create M4 Vertical PG Straps" block below (~line 51):
#
#   Bug A (Issue 1 - strategy name mismatch):
#     set_pg_strategy  M5_PG_Strategy   ...   ;# defines M5_PG_Strategy
#     compile_pg -strategies {M4_PG_Strategy} ;# compiles M4_PG_Strategy
#     -> compile_pg references a strategy name that was never defined,
#        so the M4 straps are never built; and the name M5_PG_Strategy
#        then collides with the real M5 strap strategy further down.
#        Fixed by renaming the strategy to M4_PG_Strategy.
#
#   Bug B (Issue 4 - M4 direction conflict, the deeper problem):
#     M4 is used here as a *vertical* strap and stitched M4->M1, but
#     tech_setup (lab convention) declares M4 *horizontal*, same as the
#     M1 follow-pin rails. Two co-directional layers can't via-connect,
#     so VSS never reaches M1: post-place we saw 13,230 floating VSS
#     cells + 1,401 M1/VIA0 shorts. Fixing the name (Bug A) alone does
#     NOT fix this - the M4 mesh is wrong for this metal stack.
#
# What we shipped instead (see scripts/create_pg_network.tcl):
#   - dropped the M4 strap block entirely (Bug B), and
#   - distribute vertically on M5 like the lab: vias M5->M1, M6->M5,
#     M7->M6, giving an orthogonal M5(V)/M6(H)/M7(V) mesh over the
#     horizontal M1 rails so both VDD and VSS connect and PG DRC is clean.
#   This makes Bug A moot (the M4 block no longer exists), but Bug A is
#   still a genuine defect in this provided file and is preserved below.
#
# See ISSUES_AND_FIXES.md (Issues 1 and 4) for the full write-up.
# backups/create_pg_network.provided_M4stack.tcl is this same file with
# only Bug A fixed (the M5->M4 rename), captured before Bug B was addressed.
# ====================================================================
#
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

#### Create M4 Vertical PG Straps
create_pg_mesh_pattern M4_PG \
        -layers { {vertical_layer: M4}   {width: 0.1} {spacing: interleaving} {pitch: 4} {offset: 0.5} }

set_pg_strategy M5_PG_Strategy \
        -core \
        -pattern   { {name: M4_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M4_PG_Strategy} -via_rule VIA_NIL

#### Create M5 Vertical PG Straps
create_pg_mesh_pattern M5_PG \
        -layers { {vertical_layer: M5}   {width: 0.1} {spacing: interleaving} {pitch: 4} {offset: 0.5} }

set_pg_strategy M5_PG_Strategy \
        -core \
        -pattern   { {name: M5_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M5_PG_Strategy} -via_rule VIA_NIL

#### Create M6 Horizontal PG Straps
create_pg_mesh_pattern M6_PG \
        -layers { {horizontal_layer: M6}   {width: 0.2} {spacing: interleaving} {pitch: 4} {offset: 0.5} }

set_pg_strategy M6_PG_Strategy \
        -core \
        -pattern   { {name: M6_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M6_PG_Strategy} -via_rule VIA_NIL

#### Create M7 Vertical PG Straps
create_pg_mesh_pattern M7_PG \
        -layers { {vertical_layer: M7}   {width: 0.2} {spacing: interleaving} {pitch: 4} {offset: 0.5} }

set_pg_strategy M7_PG_Strategy \
        -core \
        -pattern   { {name: M7_PG} {nets:{VSS VDD}} } \
        -extension { {stop: design_boundary_and_generate_pin} }

compile_pg -strategies {M7_PG_Strategy} -via_rule VIA_NIL


#### Create PG VIAs
create_pg_vias -from_layers M4 -to_layers M1 -via_masters default -nets {VDD VSS}
create_pg_vias -from_layers M5 -to_layers M4 -via_masters default -nets {VDD VSS}
create_pg_vias -from_layers M6 -to_layers M5 -via_masters default -nets {VDD VSS}
create_pg_vias -from_layers M7 -to_layers M6 -via_masters default -nets {VDD VSS}

#### Connect PG nets
connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]

#### Check created PG structure
check_pg_connectivity
check_pg_drc
