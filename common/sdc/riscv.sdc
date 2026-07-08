# remove any constraints that were applied from previous runs:
# NOTE: 'remove_sdc' is not valid inside read_sdc in Fusion Compiler and aborts
# the whole file (CMD-005). It is unnecessary here (each scenario reads a fresh
# SDC), so it is commented out to let the constraints below actually load.
# remove_sdc -design

# Set the physical library:

#set_current_design TOP

# Create clock object and set uncertainty
create_clock -period 10 [get_ports clk_i]
set_clock_uncertainty -setup 0.15 [get_clocks clk_i]
# NOTE: original used 'get_port' (singular), which is not a valid FC command
# and aborts read_sdc; corrected to 'get_ports'.
set_case_analysis 0 [get_ports rst_i]
# Set constraints on input ports
#suppress_message UID-401
#suppress_message DCT-306

#set_input_delay 0.2 -max -clock clk_i  [all_inputs]
set_input_delay -max 0.2 -clock clk_i [remove_from_collection [all_inputs] [get_ports clk_i]]


#Set constraints on output ports:
set_output_delay 0.2 -max -clock clk_i [all_outputs] 	 

#set_load -max [expr [load_of $lib_name/AND2X1_HVT/A1] * 15] [all_outputs]

set_clock_transition -max 0.2 [get_clocks clk_i]

