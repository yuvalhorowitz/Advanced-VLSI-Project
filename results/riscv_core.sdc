################################################################################
#
# Design name:  riscv_core
#
# Created by fc write_sdc on Sun Jul 12 20:00:32 2026
#
################################################################################

set sdc_version 2.1
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA

################################################################################
#
# Units
# time_unit               : 1e-09
# resistance_unit         : 1000
# capacitive_load_unit    : 1e-12
# voltage_unit            : 1
# current_unit            : 1e-06
# power_unit              : 1e-12
################################################################################


# Mode: FUNC
# Corner: Slow
# Scenario: FUNC_Slow

# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 16
set_case_analysis 0 [get_ports {rst_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 12
create_clock -name clk_i -period 10 -waveform {0 5} [get_ports {clk_i}]
set_propagated_clock [get_clocks {clk_i}]
# /project/advvlsi/users/yh3/ws/project_2026/Setup/mcmm_setup.tcl, line 54
set_operating_conditions -library \
    saed14lvt_base_ss0p72vm40c.db:saed14lvt_base_ss0p72vm40c -analysis_type \
    on_chip_variation ss0p72vm40c
# Warning: Libcell power domain derates are skipped!

# Set latency for io paths.
# -origin useful_skew
set_clock_latency 0.080385 [get_clocks {clk_i}]
# Set propagated on clock sources to avoid removing latency for IO paths.
set_propagated_clock  [get_ports {clk_i}]
set_clock_uncertainty -setup 0.15 [get_clocks {clk_i}]
set_clock_transition -max 0.2 [get_clocks {clk_i}]
# /project/advvlsi/users/yh3/ws/project_2026/scripts/07_cts.tcl, line 38
set_driving_cell -lib_cell SAEDRVT14_BUF_16 [get_ports {clk_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {clk_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {rst_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_rd_i[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_accept_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {mem_d_ack_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {mem_d_error_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_resp_tag_i[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_accept_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {mem_i_valid_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {mem_i_error_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_inst_i[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {intr_i}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {reset_vector_i[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 26
set_input_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {cpu_id_i[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_addr_o[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_data_wr_o[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {mem_d_rd_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_wr_o[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_wr_o[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_wr_o[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_wr_o[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_cacheable_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_req_tag_o[0]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_invalidate_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_writeback_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_d_flush_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports {mem_i_rd_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_flush_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_invalidate_o}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[31]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[30]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[29]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[28]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[27]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[26]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[25]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[24]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[23]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[22]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[21]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[20]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[19]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[18]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[17]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[16]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[15]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[14]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[13]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[12]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[11]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[10]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[9]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[8]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[7]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[6]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[5]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[4]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[3]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[2]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[1]}]
# /project/advvlsi/users/yh3/ws/project_2026/common/sdc/riscv.sdc, line 30
set_output_delay -clock [get_clocks {clk_i}] -max 0.2 [get_ports \
    {mem_i_pc_o[0]}]
