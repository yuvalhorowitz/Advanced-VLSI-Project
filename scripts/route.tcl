set_attribute [get_layers {M2 M4 M6 M8}] routing_direction horizontal
set_attribute [get_layers {M1 M3 M5 M7 M9}] routing_direction vertical

set_app_options -name route.common.wire_on_grid_by_layer_name -value {{M1 true } {M2 true} {M3 true}}
set_app_options -name route.common.via_on_grid_by_layer_name -value {{VIA1 false} {VIA2 true}}
set_ignored_layers -min_routing_layer M2
