//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_core
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_MULDIV   = 1
    ,parameter SUPPORT_SUPER    = 0
    ,parameter SUPPORT_MMU      = 0
    ,parameter SUPPORT_LOAD_BYPASS = 1
    ,parameter SUPPORT_MUL_BYPASS = 1
    ,parameter SUPPORT_REGFILE_XILINX = 0
    ,parameter EXTRA_DECODE_STAGE = 0
    ,parameter MEM_CACHE_ADDR_MIN = 32'h80000000
    ,parameter MEM_CACHE_ADDR_MAX = 32'h8fffffff
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [ 31:0]  mem_d_data_rd_i
    ,input           mem_d_accept_i
    ,input           mem_d_ack_i
    ,input           mem_d_error_i
    ,input  [ 10:0]  mem_d_resp_tag_i
    ,input           mem_i_accept_i
    ,input           mem_i_valid_i
    ,input           mem_i_error_i
    ,input  [ 31:0]  mem_i_inst_i
    ,input           intr_i
    ,input  [ 31:0]  reset_vector_i
    ,input  [ 31:0]  cpu_id_i

    // Outputs
    ,output [ 31:0]  mem_d_addr_o
    ,output [ 31:0]  mem_d_data_wr_o
    ,output          mem_d_rd_o
    ,output [  3:0]  mem_d_wr_o
    ,output          mem_d_cacheable_o
    ,output [ 10:0]  mem_d_req_tag_o
    ,output          mem_d_invalidate_o
    ,output          mem_d_writeback_o
    ,output          mem_d_flush_o
    ,output          mem_i_rd_o
    ,output          mem_i_flush_o
    ,output          mem_i_invalidate_o
    ,output [ 31:0]  mem_i_pc_o
);

wire           mmu_lsu_writeback_w;
wire  [  1:0]  fetch_in_priv_w;
wire  [  4:0]  mul_opcode_rd_idx_w;
wire           mmu_flush_w;
wire  [ 31:0]  lsu_opcode_pc_w;
wire           fetch_accept_w;
wire  [  4:0]  csr_opcode_rd_idx_w;
wire  [ 31:0]  branch_exec_source_w;
wire  [ 31:0]  csr_opcode_rb_operand_w;
wire  [ 31:0]  writeback_div_value_w;
wire           csr_opcode_valid_w;
wire           branch_csr_request_w;
wire  [ 31:0]  mmu_ifetch_inst_w;
wire  [ 31:0]  opcode_pc_w;
wire  [  4:0]  opcode_rb_idx_w;
wire           mmu_lsu_error_w;
wire           mul_opcode_valid_w;
wire           mmu_mxr_w;
wire  [  1:0]  branch_d_exec_priv_w;
wire           mmu_ifetch_valid_w;
wire           csr_opcode_invalid_w;
wire  [  5:0]  csr_writeback_exception_w;
wire           fetch_instr_mul_w;
wire           branch_exec_is_ret_w;
wire  [ 31:0]  csr_writeback_exception_addr_w;
wire  [  3:0]  mmu_lsu_wr_w;
wire           fetch_in_fault_w;
wire           branch_request_w;
wire  [ 31:0]  csr_opcode_pc_w;
wire           writeback_mem_valid_w;
wire  [  5:0]  csr_result_e1_exception_w;
wire  [ 31:0]  branch_csr_pc_w;
wire  [ 31:0]  mmu_lsu_data_wr_w;
wire           fetch_fault_page_w;
wire  [ 10:0]  mmu_lsu_resp_tag_w;
wire  [ 10:0]  mmu_lsu_req_tag_w;
wire  [ 31:0]  opcode_ra_operand_w;
wire           squash_decode_w;
wire           fetch_dec_fault_page_w;
wire  [ 31:0]  mul_opcode_opcode_w;
wire           exec_hold_w;
wire           fetch_instr_invalid_w;
wire  [ 31:0]  branch_pc_w;
wire  [  4:0]  mul_opcode_ra_idx_w;
wire  [  4:0]  csr_opcode_rb_idx_w;
wire           lsu_stall_w;
wire           branch_exec_is_not_taken_w;
wire  [ 31:0]  branch_exec_pc_w;
wire  [ 31:0]  opcode_opcode_w;
wire  [ 31:0]  mul_opcode_pc_w;
wire           branch_d_exec_request_w;
wire  [ 31:0]  mul_opcode_ra_operand_w;
wire           branch_exec_is_taken_w;
wire           fetch_dec_fault_fetch_w;
wire           fetch_dec_valid_w;
wire           fetch_fault_fetch_w;
wire           lsu_opcode_invalid_w;
wire  [ 31:0]  mmu_lsu_addr_w;
wire           mul_hold_w;
wire           mmu_ifetch_accept_w;
wire           mmu_lsu_ack_w;
wire  [ 31:0]  fetch_pc_w;
wire           mmu_ifetch_invalidate_w;
wire  [ 31:0]  mul_opcode_rb_operand_w;
wire  [  1:0]  branch_csr_priv_w;
wire           branch_exec_request_w;
wire  [ 31:0]  lsu_opcode_ra_operand_w;
wire           div_opcode_valid_w;
wire  [  1:0]  branch_priv_w;
wire           mmu_lsu_rd_w;
wire  [ 31:0]  fetch_dec_pc_w;
wire           interrupt_inhibit_w;
wire           mmu_ifetch_error_w;
wire  [  5:0]  writeback_mem_exception_w;
wire           fetch_instr_lsu_w;
wire  [  1:0]  mmu_priv_d_w;
wire  [  4:0]  opcode_ra_idx_w;
wire  [ 31:0]  csr_opcode_ra_operand_w;
wire  [ 31:0]  writeback_mem_value_w;
wire           writeback_div_valid_w;
wire  [  4:0]  mul_opcode_rb_idx_w;
wire           opcode_invalid_w;
wire           fetch_instr_branch_w;
wire  [ 31:0]  mmu_ifetch_pc_w;
wire           mmu_ifetch_rd_w;
wire           mmu_ifetch_flush_w;
wire  [  4:0]  lsu_opcode_rd_idx_w;
wire  [ 31:0]  lsu_opcode_opcode_w;
wire           mmu_load_fault_w;
wire  [ 31:0]  mmu_satp_w;
wire  [ 31:0]  csr_result_e1_wdata_w;
wire  [ 31:0]  opcode_rb_operand_w;
wire           mmu_lsu_invalidate_w;
wire           fetch_dec_accept_w;
wire  [  4:0]  csr_opcode_ra_idx_w;
wire           ifence_w;
wire           fetch_instr_exec_w;
wire  [  4:0]  opcode_rd_idx_w;
wire  [ 31:0]  csr_writeback_wdata_w;
wire           csr_writeback_write_w;
wire           take_interrupt_w;
wire  [ 31:0]  csr_result_e1_value_w;
wire  [ 31:0]  branch_d_exec_pc_w;
wire           fetch_valid_w;
wire  [ 11:0]  csr_writeback_waddr_w;
wire           branch_exec_is_jmp_w;
wire           mmu_lsu_cacheable_w;
wire           fetch_instr_csr_w;
wire           lsu_opcode_valid_w;
wire  [ 31:0]  fetch_dec_instr_w;
wire           csr_result_e1_write_w;
wire  [ 31:0]  csr_opcode_opcode_w;
wire           fetch_instr_div_w;
wire  [ 31:0]  fetch_instr_w;
wire           mul_opcode_invalid_w;
wire           fetch_instr_rd_valid_w;
wire  [ 31:0]  mmu_lsu_data_rd_w;
wire           exec_opcode_valid_w;
wire  [ 31:0]  writeback_mul_value_w;
wire           mmu_lsu_flush_w;
wire  [  4:0]  lsu_opcode_rb_idx_w;
wire           mmu_lsu_accept_w;
wire  [ 31:0]  lsu_opcode_rb_operand_w;
wire           mmu_sum_w;
wire  [ 31:0]  writeback_exec_value_w;
wire  [  4:0]  lsu_opcode_ra_idx_w;
wire  [ 31:0]  csr_writeback_exception_pc_w;
wire           mmu_store_fault_w;
wire           branch_exec_is_call_w;


riscv_exec
u_exec
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.opcode_valid_i(exec_opcode_valid_w)
    ,.opcode_opcode_i(opcode_opcode_w)
    ,.opcode_pc_i(opcode_pc_w)
    ,.opcode_invalid_i(opcode_invalid_w)
    ,.opcode_rd_idx_i(opcode_rd_idx_w)
    ,.opcode_ra_idx_i(opcode_ra_idx_w)
    ,.opcode_rb_idx_i(opcode_rb_idx_w)
    ,.opcode_ra_operand_i(opcode_ra_operand_w)
    ,.opcode_rb_operand_i(opcode_rb_operand_w)
    ,.hold_i(exec_hold_w)

    // Outputs
    ,.branch_request_o(branch_exec_request_w)
    ,.branch_is_taken_o(branch_exec_is_taken_w)
    ,.branch_is_not_taken_o(branch_exec_is_not_taken_w)
    ,.branch_source_o(branch_exec_source_w)
    ,.branch_is_call_o(branch_exec_is_call_w)
    ,.branch_is_ret_o(branch_exec_is_ret_w)
    ,.branch_is_jmp_o(branch_exec_is_jmp_w)
    ,.branch_pc_o(branch_exec_pc_w)
    ,.branch_d_request_o(branch_d_exec_request_w)
    ,.branch_d_pc_o(branch_d_exec_pc_w)
    ,.branch_d_priv_o(branch_d_exec_priv_w)
    ,.writeback_value_o(writeback_exec_value_w)
);


riscv_decode
#(
     .EXTRA_DECODE_STAGE(EXTRA_DECODE_STAGE)
    ,.SUPPORT_MULDIV(SUPPORT_MULDIV)
)
u_decode
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.fetch_in_valid_i(fetch_dec_valid_w)
    ,.fetch_in_instr_i(fetch_dec_instr_w)
    ,.fetch_in_pc_i(fetch_dec_pc_w)
    ,.fetch_in_fault_fetch_i(fetch_dec_fault_fetch_w)
    ,.fetch_in_fault_page_i(fetch_dec_fault_page_w)
    ,.fetch_out_accept_i(fetch_accept_w)
    ,.squash_decode_i(squash_decode_w)

    // Outputs
    ,.fetch_in_accept_o(fetch_dec_accept_w)
    ,.fetch_out_valid_o(fetch_valid_w)
    ,.fetch_out_instr_o(fetch_instr_w)
    ,.fetch_out_pc_o(fetch_pc_w)
    ,.fetch_out_fault_fetch_o(fetch_fault_fetch_w)
    ,.fetch_out_fault_page_o(fetch_fault_page_w)
    ,.fetch_out_instr_exec_o(fetch_instr_exec_w)
    ,.fetch_out_instr_lsu_o(fetch_instr_lsu_w)
    ,.fetch_out_instr_branch_o(fetch_instr_branch_w)
    ,.fetch_out_instr_mul_o(fetch_instr_mul_w)
    ,.fetch_out_instr_div_o(fetch_instr_div_w)
    ,.fetch_out_instr_csr_o(fetch_instr_csr_w)
    ,.fetch_out_instr_rd_valid_o(fetch_instr_rd_valid_w)
    ,.fetch_out_instr_invalid_o(fetch_instr_invalid_w)
);


riscv_mmu
#(
     .MEM_CACHE_ADDR_MAX(MEM_CACHE_ADDR_MAX)
    ,.SUPPORT_MMU(SUPPORT_MMU)
    ,.MEM_CACHE_ADDR_MIN(MEM_CACHE_ADDR_MIN)
)
u_mmu
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.priv_d_i(mmu_priv_d_w)
    ,.sum_i(mmu_sum_w)
    ,.mxr_i(mmu_mxr_w)
    ,.flush_i(mmu_flush_w)
    ,.satp_i(mmu_satp_w)
    ,.fetch_in_rd_i(mmu_ifetch_rd_w)
    ,.fetch_in_flush_i(mmu_ifetch_flush_w)
    ,.fetch_in_invalidate_i(mmu_ifetch_invalidate_w)
    ,.fetch_in_pc_i(mmu_ifetch_pc_w)
    ,.fetch_in_priv_i(fetch_in_priv_w)
    ,.fetch_out_accept_i(mem_i_accept_i)
    ,.fetch_out_valid_i(mem_i_valid_i)
    ,.fetch_out_error_i(mem_i_error_i)
    ,.fetch_out_inst_i(mem_i_inst_i)
    ,.lsu_in_addr_i(mmu_lsu_addr_w)
    ,.lsu_in_data_wr_i(mmu_lsu_data_wr_w)
    ,.lsu_in_rd_i(mmu_lsu_rd_w)
    ,.lsu_in_wr_i(mmu_lsu_wr_w)
    ,.lsu_in_cacheable_i(mmu_lsu_cacheable_w)
    ,.lsu_in_req_tag_i(mmu_lsu_req_tag_w)
    ,.lsu_in_invalidate_i(mmu_lsu_invalidate_w)
    ,.lsu_in_writeback_i(mmu_lsu_writeback_w)
    ,.lsu_in_flush_i(mmu_lsu_flush_w)
    ,.lsu_out_data_rd_i(mem_d_data_rd_i)
    ,.lsu_out_accept_i(mem_d_accept_i)
    ,.lsu_out_ack_i(mem_d_ack_i)
    ,.lsu_out_error_i(mem_d_error_i)
    ,.lsu_out_resp_tag_i(mem_d_resp_tag_i)

    // Outputs
    ,.fetch_in_accept_o(mmu_ifetch_accept_w)
    ,.fetch_in_valid_o(mmu_ifetch_valid_w)
    ,.fetch_in_error_o(mmu_ifetch_error_w)
    ,.fetch_in_inst_o(mmu_ifetch_inst_w)
    ,.fetch_out_rd_o(mem_i_rd_o)
    ,.fetch_out_flush_o(mem_i_flush_o)
    ,.fetch_out_invalidate_o(mem_i_invalidate_o)
    ,.fetch_out_pc_o(mem_i_pc_o)
    ,.fetch_in_fault_o(fetch_in_fault_w)
    ,.lsu_in_data_rd_o(mmu_lsu_data_rd_w)
    ,.lsu_in_accept_o(mmu_lsu_accept_w)
    ,.lsu_in_ack_o(mmu_lsu_ack_w)
    ,.lsu_in_error_o(mmu_lsu_error_w)
    ,.lsu_in_resp_tag_o(mmu_lsu_resp_tag_w)
    ,.lsu_out_addr_o(mem_d_addr_o)
    ,.lsu_out_data_wr_o(mem_d_data_wr_o)
    ,.lsu_out_rd_o(mem_d_rd_o)
    ,.lsu_out_wr_o(mem_d_wr_o)
    ,.lsu_out_cacheable_o(mem_d_cacheable_o)
    ,.lsu_out_req_tag_o(mem_d_req_tag_o)
    ,.lsu_out_invalidate_o(mem_d_invalidate_o)
    ,.lsu_out_writeback_o(mem_d_writeback_o)
    ,.lsu_out_flush_o(mem_d_flush_o)
    ,.lsu_in_load_fault_o(mmu_load_fault_w)
    ,.lsu_in_store_fault_o(mmu_store_fault_w)
);


riscv_lsu
#(
     .MEM_CACHE_ADDR_MAX(MEM_CACHE_ADDR_MAX)
    ,.MEM_CACHE_ADDR_MIN(MEM_CACHE_ADDR_MIN)
)
u_lsu
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.opcode_valid_i(lsu_opcode_valid_w)
    ,.opcode_opcode_i(lsu_opcode_opcode_w)
    ,.opcode_pc_i(lsu_opcode_pc_w)
    ,.opcode_invalid_i(lsu_opcode_invalid_w)
    ,.opcode_rd_idx_i(lsu_opcode_rd_idx_w)
    ,.opcode_ra_idx_i(lsu_opcode_ra_idx_w)
    ,.opcode_rb_idx_i(lsu_opcode_rb_idx_w)
    ,.opcode_ra_operand_i(lsu_opcode_ra_operand_w)
    ,.opcode_rb_operand_i(lsu_opcode_rb_operand_w)
    ,.mem_data_rd_i(mmu_lsu_data_rd_w)
    ,.mem_accept_i(mmu_lsu_accept_w)
    ,.mem_ack_i(mmu_lsu_ack_w)
    ,.mem_error_i(mmu_lsu_error_w)
    ,.mem_resp_tag_i(mmu_lsu_resp_tag_w)
    ,.mem_load_fault_i(mmu_load_fault_w)
    ,.mem_store_fault_i(mmu_store_fault_w)

    // Outputs
    ,.mem_addr_o(mmu_lsu_addr_w)
    ,.mem_data_wr_o(mmu_lsu_data_wr_w)
    ,.mem_rd_o(mmu_lsu_rd_w)
    ,.mem_wr_o(mmu_lsu_wr_w)
    ,.mem_cacheable_o(mmu_lsu_cacheable_w)
    ,.mem_req_tag_o(mmu_lsu_req_tag_w)
    ,.mem_invalidate_o(mmu_lsu_invalidate_w)
    ,.mem_writeback_o(mmu_lsu_writeback_w)
    ,.mem_flush_o(mmu_lsu_flush_w)
    ,.writeback_valid_o(writeback_mem_valid_w)
    ,.writeback_value_o(writeback_mem_value_w)
    ,.writeback_exception_o(writeback_mem_exception_w)
    ,.stall_o(lsu_stall_w)
);


riscv_csr
#(
     .SUPPORT_SUPER(SUPPORT_SUPER)
    ,.SUPPORT_MULDIV(SUPPORT_MULDIV)
)
u_csr
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.intr_i(intr_i)
    ,.opcode_valid_i(csr_opcode_valid_w)
    ,.opcode_opcode_i(csr_opcode_opcode_w)
    ,.opcode_pc_i(csr_opcode_pc_w)
    ,.opcode_invalid_i(csr_opcode_invalid_w)
    ,.opcode_rd_idx_i(csr_opcode_rd_idx_w)
    ,.opcode_ra_idx_i(csr_opcode_ra_idx_w)
    ,.opcode_rb_idx_i(csr_opcode_rb_idx_w)
    ,.opcode_ra_operand_i(csr_opcode_ra_operand_w)
    ,.opcode_rb_operand_i(csr_opcode_rb_operand_w)
    ,.csr_writeback_write_i(csr_writeback_write_w)
    ,.csr_writeback_waddr_i(csr_writeback_waddr_w)
    ,.csr_writeback_wdata_i(csr_writeback_wdata_w)
    ,.csr_writeback_exception_i(csr_writeback_exception_w)
    ,.csr_writeback_exception_pc_i(csr_writeback_exception_pc_w)
    ,.csr_writeback_exception_addr_i(csr_writeback_exception_addr_w)
    ,.cpu_id_i(cpu_id_i)
    ,.reset_vector_i(reset_vector_i)
    ,.interrupt_inhibit_i(interrupt_inhibit_w)

    // Outputs
    ,.csr_result_e1_value_o(csr_result_e1_value_w)
    ,.csr_result_e1_write_o(csr_result_e1_write_w)
    ,.csr_result_e1_wdata_o(csr_result_e1_wdata_w)
    ,.csr_result_e1_exception_o(csr_result_e1_exception_w)
    ,.branch_csr_request_o(branch_csr_request_w)
    ,.branch_csr_pc_o(branch_csr_pc_w)
    ,.branch_csr_priv_o(branch_csr_priv_w)
    ,.take_interrupt_o(take_interrupt_w)
    ,.ifence_o(ifence_w)
    ,.mmu_priv_d_o(mmu_priv_d_w)
    ,.mmu_sum_o(mmu_sum_w)
    ,.mmu_mxr_o(mmu_mxr_w)
    ,.mmu_flush_o(mmu_flush_w)
    ,.mmu_satp_o(mmu_satp_w)
);


riscv_multiplier
u_mul
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.opcode_valid_i(mul_opcode_valid_w)
    ,.opcode_opcode_i(mul_opcode_opcode_w)
    ,.opcode_pc_i(mul_opcode_pc_w)
    ,.opcode_invalid_i(mul_opcode_invalid_w)
    ,.opcode_rd_idx_i(mul_opcode_rd_idx_w)
    ,.opcode_ra_idx_i(mul_opcode_ra_idx_w)
    ,.opcode_rb_idx_i(mul_opcode_rb_idx_w)
    ,.opcode_ra_operand_i(mul_opcode_ra_operand_w)
    ,.opcode_rb_operand_i(mul_opcode_rb_operand_w)
    ,.hold_i(mul_hold_w)

    // Outputs
    ,.writeback_value_o(writeback_mul_value_w)
);


riscv_divider
u_div
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.opcode_valid_i(div_opcode_valid_w)
    ,.opcode_opcode_i(opcode_opcode_w)
    ,.opcode_pc_i(opcode_pc_w)
    ,.opcode_invalid_i(opcode_invalid_w)
    ,.opcode_rd_idx_i(opcode_rd_idx_w)
    ,.opcode_ra_idx_i(opcode_ra_idx_w)
    ,.opcode_rb_idx_i(opcode_rb_idx_w)
    ,.opcode_ra_operand_i(opcode_ra_operand_w)
    ,.opcode_rb_operand_i(opcode_rb_operand_w)

    // Outputs
    ,.writeback_valid_o(writeback_div_valid_w)
    ,.writeback_value_o(writeback_div_value_w)
);


riscv_issue
#(
     .SUPPORT_REGFILE_XILINX(SUPPORT_REGFILE_XILINX)
    ,.SUPPORT_LOAD_BYPASS(SUPPORT_LOAD_BYPASS)
    ,.SUPPORT_MULDIV(SUPPORT_MULDIV)
    ,.SUPPORT_MUL_BYPASS(SUPPORT_MUL_BYPASS)
    ,.SUPPORT_DUAL_ISSUE(1)
)
u_issue
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.fetch_valid_i(fetch_valid_w)
    ,.fetch_instr_i(fetch_instr_w)
    ,.fetch_pc_i(fetch_pc_w)
    ,.fetch_fault_fetch_i(fetch_fault_fetch_w)
    ,.fetch_fault_page_i(fetch_fault_page_w)
    ,.fetch_instr_exec_i(fetch_instr_exec_w)
    ,.fetch_instr_lsu_i(fetch_instr_lsu_w)
    ,.fetch_instr_branch_i(fetch_instr_branch_w)
    ,.fetch_instr_mul_i(fetch_instr_mul_w)
    ,.fetch_instr_div_i(fetch_instr_div_w)
    ,.fetch_instr_csr_i(fetch_instr_csr_w)
    ,.fetch_instr_rd_valid_i(fetch_instr_rd_valid_w)
    ,.fetch_instr_invalid_i(fetch_instr_invalid_w)
    ,.branch_exec_request_i(branch_exec_request_w)
    ,.branch_exec_is_taken_i(branch_exec_is_taken_w)
    ,.branch_exec_is_not_taken_i(branch_exec_is_not_taken_w)
    ,.branch_exec_source_i(branch_exec_source_w)
    ,.branch_exec_is_call_i(branch_exec_is_call_w)
    ,.branch_exec_is_ret_i(branch_exec_is_ret_w)
    ,.branch_exec_is_jmp_i(branch_exec_is_jmp_w)
    ,.branch_exec_pc_i(branch_exec_pc_w)
    ,.branch_d_exec_request_i(branch_d_exec_request_w)
    ,.branch_d_exec_pc_i(branch_d_exec_pc_w)
    ,.branch_d_exec_priv_i(branch_d_exec_priv_w)
    ,.branch_csr_request_i(branch_csr_request_w)
    ,.branch_csr_pc_i(branch_csr_pc_w)
    ,.branch_csr_priv_i(branch_csr_priv_w)
    ,.writeback_exec_value_i(writeback_exec_value_w)
    ,.writeback_mem_valid_i(writeback_mem_valid_w)
    ,.writeback_mem_value_i(writeback_mem_value_w)
    ,.writeback_mem_exception_i(writeback_mem_exception_w)
    ,.writeback_mul_value_i(writeback_mul_value_w)
    ,.writeback_div_valid_i(writeback_div_valid_w)
    ,.writeback_div_value_i(writeback_div_value_w)
    ,.csr_result_e1_value_i(csr_result_e1_value_w)
    ,.csr_result_e1_write_i(csr_result_e1_write_w)
    ,.csr_result_e1_wdata_i(csr_result_e1_wdata_w)
    ,.csr_result_e1_exception_i(csr_result_e1_exception_w)
    ,.lsu_stall_i(lsu_stall_w)
    ,.take_interrupt_i(take_interrupt_w)

    // Outputs
    ,.fetch_accept_o(fetch_accept_w)
    ,.branch_request_o(branch_request_w)
    ,.branch_pc_o(branch_pc_w)
    ,.branch_priv_o(branch_priv_w)
    ,.exec_opcode_valid_o(exec_opcode_valid_w)
    ,.lsu_opcode_valid_o(lsu_opcode_valid_w)
    ,.csr_opcode_valid_o(csr_opcode_valid_w)
    ,.mul_opcode_valid_o(mul_opcode_valid_w)
    ,.div_opcode_valid_o(div_opcode_valid_w)
    ,.opcode_opcode_o(opcode_opcode_w)
    ,.opcode_pc_o(opcode_pc_w)
    ,.opcode_invalid_o(opcode_invalid_w)
    ,.opcode_rd_idx_o(opcode_rd_idx_w)
    ,.opcode_ra_idx_o(opcode_ra_idx_w)
    ,.opcode_rb_idx_o(opcode_rb_idx_w)
    ,.opcode_ra_operand_o(opcode_ra_operand_w)
    ,.opcode_rb_operand_o(opcode_rb_operand_w)
    ,.lsu_opcode_opcode_o(lsu_opcode_opcode_w)
    ,.lsu_opcode_pc_o(lsu_opcode_pc_w)
    ,.lsu_opcode_invalid_o(lsu_opcode_invalid_w)
    ,.lsu_opcode_rd_idx_o(lsu_opcode_rd_idx_w)
    ,.lsu_opcode_ra_idx_o(lsu_opcode_ra_idx_w)
    ,.lsu_opcode_rb_idx_o(lsu_opcode_rb_idx_w)
    ,.lsu_opcode_ra_operand_o(lsu_opcode_ra_operand_w)
    ,.lsu_opcode_rb_operand_o(lsu_opcode_rb_operand_w)
    ,.mul_opcode_opcode_o(mul_opcode_opcode_w)
    ,.mul_opcode_pc_o(mul_opcode_pc_w)
    ,.mul_opcode_invalid_o(mul_opcode_invalid_w)
    ,.mul_opcode_rd_idx_o(mul_opcode_rd_idx_w)
    ,.mul_opcode_ra_idx_o(mul_opcode_ra_idx_w)
    ,.mul_opcode_rb_idx_o(mul_opcode_rb_idx_w)
    ,.mul_opcode_ra_operand_o(mul_opcode_ra_operand_w)
    ,.mul_opcode_rb_operand_o(mul_opcode_rb_operand_w)
    ,.csr_opcode_opcode_o(csr_opcode_opcode_w)
    ,.csr_opcode_pc_o(csr_opcode_pc_w)
    ,.csr_opcode_invalid_o(csr_opcode_invalid_w)
    ,.csr_opcode_rd_idx_o(csr_opcode_rd_idx_w)
    ,.csr_opcode_ra_idx_o(csr_opcode_ra_idx_w)
    ,.csr_opcode_rb_idx_o(csr_opcode_rb_idx_w)
    ,.csr_opcode_ra_operand_o(csr_opcode_ra_operand_w)
    ,.csr_opcode_rb_operand_o(csr_opcode_rb_operand_w)
    ,.csr_writeback_write_o(csr_writeback_write_w)
    ,.csr_writeback_waddr_o(csr_writeback_waddr_w)
    ,.csr_writeback_wdata_o(csr_writeback_wdata_w)
    ,.csr_writeback_exception_o(csr_writeback_exception_w)
    ,.csr_writeback_exception_pc_o(csr_writeback_exception_pc_w)
    ,.csr_writeback_exception_addr_o(csr_writeback_exception_addr_w)
    ,.exec_hold_o(exec_hold_w)
    ,.mul_hold_o(mul_hold_w)
    ,.interrupt_inhibit_o(interrupt_inhibit_w)
);


riscv_fetch
#(
     .SUPPORT_MMU(SUPPORT_MMU)
)
u_fetch
(
    // Inputs
     .clk_i(clk_i)
    ,.rst_i(rst_i)
    ,.fetch_accept_i(fetch_dec_accept_w)
    ,.icache_accept_i(mmu_ifetch_accept_w)
    ,.icache_valid_i(mmu_ifetch_valid_w)
    ,.icache_error_i(mmu_ifetch_error_w)
    ,.icache_inst_i(mmu_ifetch_inst_w)
    ,.icache_page_fault_i(fetch_in_fault_w)
    ,.fetch_invalidate_i(ifence_w)
    ,.branch_request_i(branch_request_w)
    ,.branch_pc_i(branch_pc_w)
    ,.branch_priv_i(branch_priv_w)

    // Outputs
    ,.fetch_valid_o(fetch_dec_valid_w)
    ,.fetch_instr_o(fetch_dec_instr_w)
    ,.fetch_pc_o(fetch_dec_pc_w)
    ,.fetch_fault_fetch_o(fetch_dec_fault_fetch_w)
    ,.fetch_fault_page_o(fetch_dec_fault_page_w)
    ,.icache_rd_o(mmu_ifetch_rd_w)
    ,.icache_flush_o(mmu_ifetch_flush_w)
    ,.icache_invalidate_o(mmu_ifetch_invalidate_w)
    ,.icache_pc_o(mmu_ifetch_pc_w)
    ,.icache_priv_o(fetch_in_priv_w)
    ,.squash_decode_o(squash_decode_w)
);



endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
module riscv_alu
(
    // Inputs
     input  [  3:0]  alu_op_i
    ,input  [ 31:0]  alu_a_i
    ,input  [ 31:0]  alu_b_i

    // Outputs
    ,output [ 31:0]  alu_p_o
);

//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg [31:0]      result_r;

reg [31:16]     shift_right_fill_r;
reg [31:0]      shift_right_1_r;
reg [31:0]      shift_right_2_r;
reg [31:0]      shift_right_4_r;
reg [31:0]      shift_right_8_r;

reg [31:0]      shift_left_1_r;
reg [31:0]      shift_left_2_r;
reg [31:0]      shift_left_4_r;
reg [31:0]      shift_left_8_r;

wire [31:0]     sub_res_w = alu_a_i - alu_b_i;

//-----------------------------------------------------------------
// ALU
//-----------------------------------------------------------------
always @ (alu_op_i or alu_a_i or alu_b_i or sub_res_w)
begin
    shift_right_fill_r = 16'b0;
    shift_right_1_r = 32'b0;
    shift_right_2_r = 32'b0;
    shift_right_4_r = 32'b0;
    shift_right_8_r = 32'b0;

    shift_left_1_r = 32'b0;
    shift_left_2_r = 32'b0;
    shift_left_4_r = 32'b0;
    shift_left_8_r = 32'b0;

    case (alu_op_i)
       //----------------------------------------------
       // Shift Left
       //----------------------------------------------   
       `ALU_SHIFTL :
       begin
            if (alu_b_i[0] == 1'b1)
                shift_left_1_r = {alu_a_i[30:0],1'b0};
            else
                shift_left_1_r = alu_a_i;

            if (alu_b_i[1] == 1'b1)
                shift_left_2_r = {shift_left_1_r[29:0],2'b00};
            else
                shift_left_2_r = shift_left_1_r;

            if (alu_b_i[2] == 1'b1)
                shift_left_4_r = {shift_left_2_r[27:0],4'b0000};
            else
                shift_left_4_r = shift_left_2_r;

            if (alu_b_i[3] == 1'b1)
                shift_left_8_r = {shift_left_4_r[23:0],8'b00000000};
            else
                shift_left_8_r = shift_left_4_r;

            if (alu_b_i[4] == 1'b1)
                result_r = {shift_left_8_r[15:0],16'b0000000000000000};
            else
                result_r = shift_left_8_r;
       end
       //----------------------------------------------
       // Shift Right
       //----------------------------------------------
       `ALU_SHIFTR, `ALU_SHIFTR_ARITH:
       begin
            // Arithmetic shift? Fill with 1's if MSB set
            if (alu_a_i[31] == 1'b1 && alu_op_i == `ALU_SHIFTR_ARITH)
                shift_right_fill_r = 16'b1111111111111111;
            else
                shift_right_fill_r = 16'b0000000000000000;

            if (alu_b_i[0] == 1'b1)
                shift_right_1_r = {shift_right_fill_r[31], alu_a_i[31:1]};
            else
                shift_right_1_r = alu_a_i;

            if (alu_b_i[1] == 1'b1)
                shift_right_2_r = {shift_right_fill_r[31:30], shift_right_1_r[31:2]};
            else
                shift_right_2_r = shift_right_1_r;

            if (alu_b_i[2] == 1'b1)
                shift_right_4_r = {shift_right_fill_r[31:28], shift_right_2_r[31:4]};
            else
                shift_right_4_r = shift_right_2_r;

            if (alu_b_i[3] == 1'b1)
                shift_right_8_r = {shift_right_fill_r[31:24], shift_right_4_r[31:8]};
            else
                shift_right_8_r = shift_right_4_r;

            if (alu_b_i[4] == 1'b1)
                result_r = {shift_right_fill_r[31:16], shift_right_8_r[31:16]};
            else
                result_r = shift_right_8_r;
       end       
       //----------------------------------------------
       // Arithmetic
       //----------------------------------------------
       `ALU_ADD : 
       begin
            result_r      = (alu_a_i + alu_b_i);
       end
       `ALU_SUB : 
       begin
            result_r      = sub_res_w;
       end
       //----------------------------------------------
       // Logical
       //----------------------------------------------       
       `ALU_AND : 
       begin
            result_r      = (alu_a_i & alu_b_i);
       end
       `ALU_OR  : 
       begin
            result_r      = (alu_a_i | alu_b_i);
       end
       `ALU_XOR : 
       begin
            result_r      = (alu_a_i ^ alu_b_i);
       end
       //----------------------------------------------
       // Comparision
       //----------------------------------------------
       `ALU_LESS_THAN : 
       begin
            result_r      = (alu_a_i < alu_b_i) ? 32'h1 : 32'h0;
       end
       `ALU_LESS_THAN_SIGNED : 
       begin
            if (alu_a_i[31] != alu_b_i[31])
                result_r  = alu_a_i[31] ? 32'h1 : 32'h0;
            else
                result_r  = sub_res_w[31] ? 32'h1 : 32'h0;            
       end       
       default  : 
       begin
            result_r      = alu_a_i;
       end
    endcase
end

assign alu_p_o    = result_r;

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
module riscv_csr_regfile
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_MTIMECMP    = 1,
     parameter SUPPORT_SUPER       = 0
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
     input           clk_i
    ,input           rst_i

    ,input           ext_intr_i
    ,input           timer_intr_i

    ,input [31:0]    cpu_id_i
    ,input [31:0]    misa_i

    ,input [5:0]     exception_i
    ,input [31:0]    exception_pc_i
    ,input [31:0]    exception_addr_i

    // CSR read port
    ,input           csr_ren_i
    ,input  [11:0]   csr_raddr_i
    ,output [31:0]   csr_rdata_o

    // CSR write port
    ,input  [11:0]   csr_waddr_i
    ,input  [31:0]   csr_wdata_i

    ,output          csr_branch_o
    ,output [31:0]   csr_target_o

    // CSR registers
    ,output [1:0]    priv_o
    ,output [31:0]   status_o
    ,output [31:0]   satp_o

    // Masked interrupt output
    ,output [31:0]   interrupt_o
);

//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
// CSR - Machine
reg [31:0]  csr_mepc_q;
reg [31:0]  csr_mcause_q;
reg [31:0]  csr_sr_q;
reg [31:0]  csr_mtvec_q;
reg [31:0]  csr_mip_q;
reg [31:0]  csr_mie_q;
reg [1:0]   csr_mpriv_q;
reg [31:0]  csr_mcycle_q;
reg [31:0]  csr_mcycle_h_q;
reg [31:0]  csr_mscratch_q;
reg [31:0]  csr_mtval_q;
reg [31:0]  csr_mtimecmp_q;
reg         csr_mtime_ie_q;
reg [31:0]  csr_medeleg_q;
reg [31:0]  csr_mideleg_q;

// CSR - Supervisor
reg [31:0]  csr_sepc_q;
reg [31:0]  csr_stvec_q;
reg [31:0]  csr_scause_q;
reg [31:0]  csr_stval_q;
reg [31:0]  csr_satp_q;
reg [31:0]  csr_sscratch_q;

//-----------------------------------------------------------------
// Masked Interrupts
//-----------------------------------------------------------------
reg [31:0] irq_pending_r;
reg [31:0] irq_masked_r;
reg [1:0]  irq_priv_r;

reg        m_enabled_r;
reg [31:0] m_interrupts_r;
reg        s_enabled_r;
reg [31:0] s_interrupts_r;

always @ *
begin
    if (SUPPORT_SUPER)
    begin
        irq_pending_r   = (csr_mip_q & csr_mie_q);
        m_enabled_r     = (csr_mpriv_q < `PRIV_MACHINE) || (csr_mpriv_q == `PRIV_MACHINE && csr_sr_q[`SR_MIE_R]);
        s_enabled_r     = (csr_mpriv_q < `PRIV_SUPER)   || (csr_mpriv_q == `PRIV_SUPER   && csr_sr_q[`SR_SIE_R]);
        m_interrupts_r  = m_enabled_r    ? (irq_pending_r & ~csr_mideleg_q) : 32'b0;
        s_interrupts_r  = s_enabled_r    ? (irq_pending_r &  csr_mideleg_q) : 32'b0;
        irq_masked_r    = (|m_interrupts_r) ? m_interrupts_r : s_interrupts_r;
        irq_priv_r      = (|m_interrupts_r) ? `PRIV_MACHINE : `PRIV_SUPER;
    end
    else
    begin
        irq_pending_r   = (csr_mip_q & csr_mie_q);
        irq_masked_r    = csr_sr_q[`SR_MIE_R] ? irq_pending_r : 32'b0;
        irq_priv_r      = `PRIV_MACHINE;
    end
end

reg [1:0] irq_priv_q;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    irq_priv_q <= `PRIV_MACHINE;
else if (|irq_masked_r)
    irq_priv_q <= irq_priv_r;

assign interrupt_o = irq_masked_r;


reg csr_mip_upd_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    csr_mip_upd_q <= 1'b0;
else if ((csr_ren_i && csr_raddr_i == `CSR_MIP) || (csr_ren_i && csr_raddr_i == `CSR_SIP))
    csr_mip_upd_q <= 1'b1;
else if (csr_waddr_i == `CSR_MIP || csr_waddr_i == `CSR_SIP || (|exception_i))
    csr_mip_upd_q <= 1'b0;

wire buffer_mip_w = (csr_ren_i && csr_raddr_i == `CSR_MIP) | (csr_ren_i && csr_raddr_i == `CSR_SIP) | csr_mip_upd_q;

//-----------------------------------------------------------------
// CSR Read Port
//-----------------------------------------------------------------
reg [31:0] rdata_r;
always @ *
begin
    rdata_r = 32'b0;

    case (csr_raddr_i)
    // CSR - Machine
    `CSR_MSCRATCH: rdata_r = csr_mscratch_q & `CSR_MSCRATCH_MASK;
    `CSR_MEPC:     rdata_r = csr_mepc_q & `CSR_MEPC_MASK;
    `CSR_MTVEC:    rdata_r = csr_mtvec_q & `CSR_MTVEC_MASK;
    `CSR_MCAUSE:   rdata_r = csr_mcause_q & `CSR_MCAUSE_MASK;
    `CSR_MTVAL:    rdata_r = csr_mtval_q & `CSR_MTVAL_MASK;
    `CSR_MSTATUS:  rdata_r = csr_sr_q & `CSR_MSTATUS_MASK;
    `CSR_MIP:      rdata_r = csr_mip_q & `CSR_MIP_MASK;
    `CSR_MIE:      rdata_r = csr_mie_q & `CSR_MIE_MASK;
    `CSR_MCYCLE,
    `CSR_MTIME:    rdata_r = csr_mcycle_q;
    `CSR_MTIMEH:   rdata_r = csr_mcycle_h_q;
    `CSR_MHARTID:  rdata_r = cpu_id_i;
    `CSR_MISA:     rdata_r = misa_i;
    `CSR_MEDELEG:  rdata_r = SUPPORT_SUPER ? (csr_medeleg_q & `CSR_MEDELEG_MASK) : 32'b0;
    `CSR_MIDELEG:  rdata_r = SUPPORT_SUPER ? (csr_mideleg_q & `CSR_MIDELEG_MASK) : 32'b0;
    // Non-std behaviour
    `CSR_MTIMECMP: rdata_r = SUPPORT_MTIMECMP ? csr_mtimecmp_q : 32'b0;
    // CSR - Super
    `CSR_SSTATUS:  rdata_r = SUPPORT_SUPER ? (csr_sr_q       & `CSR_SSTATUS_MASK)  : 32'b0;
    `CSR_SIP:      rdata_r = SUPPORT_SUPER ? (csr_mip_q      & `CSR_SIP_MASK)      : 32'b0;
    `CSR_SIE:      rdata_r = SUPPORT_SUPER ? (csr_mie_q      & `CSR_SIE_MASK)      : 32'b0;
    `CSR_SEPC:     rdata_r = SUPPORT_SUPER ? (csr_sepc_q     & `CSR_SEPC_MASK)     : 32'b0;
    `CSR_STVEC:    rdata_r = SUPPORT_SUPER ? (csr_stvec_q    & `CSR_STVEC_MASK)    : 32'b0;
    `CSR_SCAUSE:   rdata_r = SUPPORT_SUPER ? (csr_scause_q   & `CSR_SCAUSE_MASK)   : 32'b0;
    `CSR_STVAL:    rdata_r = SUPPORT_SUPER ? (csr_stval_q    & `CSR_STVAL_MASK)    : 32'b0;
    `CSR_SATP:     rdata_r = SUPPORT_SUPER ? (csr_satp_q     & `CSR_SATP_MASK)     : 32'b0;
    `CSR_SSCRATCH: rdata_r = SUPPORT_SUPER ? (csr_sscratch_q & `CSR_SSCRATCH_MASK) : 32'b0;
    default:       rdata_r = 32'b0;
    endcase
end

assign csr_rdata_o = rdata_r;
assign priv_o      = csr_mpriv_q;
assign status_o    = csr_sr_q;
assign satp_o      = csr_satp_q;

//-----------------------------------------------------------------
// CSR register next state
//-----------------------------------------------------------------
// CSR - Machine
reg [31:0]  csr_mepc_r;
reg [31:0]  csr_mcause_r;
reg [31:0]  csr_mtval_r;
reg [31:0]  csr_sr_r;
reg [31:0]  csr_mtvec_r;
reg [31:0]  csr_mip_r;
reg [31:0]  csr_mie_r;
reg [1:0]   csr_mpriv_r;
reg [31:0]  csr_mcycle_r;
reg [31:0]  csr_mscratch_r;
reg [31:0]  csr_mtimecmp_r;
reg         csr_mtime_ie_r;
reg [31:0]  csr_medeleg_r;
reg [31:0]  csr_mideleg_r;

reg [31:0]  csr_mip_next_q;
reg [31:0]  csr_mip_next_r;

// CSR - Supervisor
reg [31:0]  csr_sepc_r;
reg [31:0]  csr_stvec_r;
reg [31:0]  csr_scause_r;
reg [31:0]  csr_stval_r;
reg [31:0]  csr_satp_r;
reg [31:0]  csr_sscratch_r;

wire is_exception_w = ((exception_i & `EXCEPTION_TYPE_MASK) == `EXCEPTION_EXCEPTION);
wire exception_s_w  = SUPPORT_SUPER ? ((csr_mpriv_q <= `PRIV_SUPER) & is_exception_w & csr_medeleg_q[{1'b0, exception_i[`EXCEPTION_SUBTYPE_R]}]) : 1'b0;

always @ *
begin
    // CSR - Machine
    csr_mip_next_r  = csr_mip_next_q;
    csr_mepc_r      = csr_mepc_q;
    csr_sr_r        = csr_sr_q;
    csr_mcause_r    = csr_mcause_q;
    csr_mtval_r     = csr_mtval_q;
    csr_mtvec_r     = csr_mtvec_q;
    csr_mip_r       = csr_mip_q;
    csr_mie_r       = csr_mie_q;
    csr_mpriv_r     = csr_mpriv_q;
    csr_mscratch_r  = csr_mscratch_q;
    csr_mcycle_r    = csr_mcycle_q + 32'd1;
    csr_mtimecmp_r  = csr_mtimecmp_q;
    csr_mtime_ie_r  = csr_mtime_ie_q;
    csr_medeleg_r   = csr_medeleg_q;
    csr_mideleg_r   = csr_mideleg_q;

    // CSR - Super
    csr_sepc_r      = csr_sepc_q;
    csr_stvec_r     = csr_stvec_q;
    csr_scause_r    = csr_scause_q;
    csr_stval_r     = csr_stval_q;
    csr_satp_r      = csr_satp_q;
    csr_sscratch_r  = csr_sscratch_q;

    // Interrupts
    if ((exception_i & `EXCEPTION_TYPE_MASK) == `EXCEPTION_INTERRUPT)
    begin
        // Machine mode interrupts
        if (irq_priv_q == `PRIV_MACHINE)
        begin
            // Save interrupt / supervisor state
            csr_sr_r[`SR_MPIE_R] = csr_sr_r[`SR_MIE_R];
            csr_sr_r[`SR_MPP_R]  = csr_mpriv_q;

            // Disable interrupts and enter supervisor mode
            csr_sr_r[`SR_MIE_R]  = 1'b0;

            // Raise priviledge to machine level
            csr_mpriv_r          = `PRIV_MACHINE;

            // Record interrupt source PC
            csr_mepc_r           = exception_pc_i;
            csr_mtval_r          = 32'b0;

            // Piority encoded interrupt cause
            if (interrupt_o[`IRQ_M_SOFT])
                csr_mcause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_M_SOFT;
            else if (interrupt_o[`IRQ_M_TIMER])
                csr_mcause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_M_TIMER;
            else if (interrupt_o[`IRQ_M_EXT])
                csr_mcause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_M_EXT;
        end
        // Supervisor mode interrupts
        else
        begin
            // Save interrupt / supervisor state
            csr_sr_r[`SR_SPIE_R] = csr_sr_r[`SR_SIE_R];
            csr_sr_r[`SR_SPP_R]  = (csr_mpriv_q == `PRIV_SUPER);

            // Disable interrupts and enter supervisor mode
            csr_sr_r[`SR_SIE_R]  = 1'b0;

            // Raise priviledge to machine level
            csr_mpriv_r  = `PRIV_SUPER;

            // Record fault source PC
            csr_sepc_r   = exception_pc_i;
            csr_stval_r  = 32'b0;

            // Piority encoded interrupt cause
            if (interrupt_o[`IRQ_S_SOFT])
                csr_scause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_S_SOFT;
            else if (interrupt_o[`IRQ_S_TIMER])
                csr_scause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_S_TIMER;
            else if (interrupt_o[`IRQ_S_EXT])
                csr_scause_r = `MCAUSE_INTERRUPT + 32'd`IRQ_S_EXT;
        end
    end
    // Exception return
    else if (exception_i >= `EXCEPTION_ERET_U && exception_i <= `EXCEPTION_ERET_M)
    begin
        // MRET (return from machine)
        if (exception_i[1:0] == `PRIV_MACHINE)
        begin
            // Set privilege level to previous MPP
            csr_mpriv_r          = csr_sr_r[`SR_MPP_R];

            // Interrupt enable pop
            csr_sr_r[`SR_MIE_R]  = csr_sr_r[`SR_MPIE_R];
            csr_sr_r[`SR_MPIE_R] = 1'b1;

            // TODO: Set next MPP to user mode??
            csr_sr_r[`SR_MPP_R] = `SR_MPP_U;
        end
        // SRET (return from supervisor)
        else
        begin
            // Set privilege level to previous privilege level
            csr_mpriv_r          = csr_sr_r[`SR_SPP_R] ? `PRIV_SUPER : `PRIV_USER;

            // Interrupt enable pop
            csr_sr_r[`SR_SIE_R]  = csr_sr_r[`SR_SPIE_R];
            csr_sr_r[`SR_SPIE_R] = 1'b1;

            // Set next SPP to user mode
            csr_sr_r[`SR_SPP_R] = 1'b0;
        end
    end
    // Exception - handled in super mode
    else if (is_exception_w && exception_s_w)
    begin
        // Save interrupt / supervisor state
        csr_sr_r[`SR_SPIE_R] = csr_sr_r[`SR_SIE_R];
        csr_sr_r[`SR_SPP_R]  = (csr_mpriv_q == `PRIV_SUPER);

        // Disable interrupts and enter supervisor mode
        csr_sr_r[`SR_SIE_R]  = 1'b0;

        // Raise priviledge to machine level
        csr_mpriv_r  = `PRIV_SUPER;

        // Record fault source PC
        csr_sepc_r   = exception_pc_i;

        // Bad address / PC
        case (exception_i)
        `EXCEPTION_MISALIGNED_FETCH,
        `EXCEPTION_FAULT_FETCH,
        `EXCEPTION_PAGE_FAULT_INST:     csr_stval_r = exception_pc_i;
        `EXCEPTION_ILLEGAL_INSTRUCTION,
        `EXCEPTION_MISALIGNED_LOAD,
        `EXCEPTION_FAULT_LOAD,
        `EXCEPTION_MISALIGNED_STORE,
        `EXCEPTION_FAULT_STORE,
        `EXCEPTION_PAGE_FAULT_LOAD,
        `EXCEPTION_PAGE_FAULT_STORE:    csr_stval_r = exception_addr_i;
        default:                        csr_stval_r = 32'b0;
        endcase

        // Fault cause
        csr_scause_r = {28'b0, exception_i[3:0]};
    end
    // Exception - handled in machine mode
    else if (is_exception_w)
    begin
        // Save interrupt / supervisor state
        csr_sr_r[`SR_MPIE_R] = csr_sr_r[`SR_MIE_R];
        csr_sr_r[`SR_MPP_R]  = csr_mpriv_q;

        // Disable interrupts and enter supervisor mode
        csr_sr_r[`SR_MIE_R]  = 1'b0;

        // Raise priviledge to machine level
        csr_mpriv_r  = `PRIV_MACHINE;

        // Record fault source PC
        csr_mepc_r   = exception_pc_i;

        // Bad address / PC
        case (exception_i)
        `EXCEPTION_MISALIGNED_FETCH,
        `EXCEPTION_FAULT_FETCH,
        `EXCEPTION_PAGE_FAULT_INST:     csr_mtval_r = exception_pc_i;
        `EXCEPTION_ILLEGAL_INSTRUCTION,
        `EXCEPTION_MISALIGNED_LOAD,
        `EXCEPTION_FAULT_LOAD,
        `EXCEPTION_MISALIGNED_STORE,
        `EXCEPTION_FAULT_STORE,
        `EXCEPTION_PAGE_FAULT_LOAD,
        `EXCEPTION_PAGE_FAULT_STORE:    csr_mtval_r = exception_addr_i;
        default:                        csr_mtval_r = 32'b0;
        endcase        

        // Fault cause
        csr_mcause_r = {28'b0, exception_i[3:0]};
    end
    else
    begin
        case (csr_waddr_i)
        // CSR - Machine
        `CSR_MSCRATCH: csr_mscratch_r = csr_wdata_i & `CSR_MSCRATCH_MASK;
        `CSR_MEPC:     csr_mepc_r     = csr_wdata_i & `CSR_MEPC_MASK;
        `CSR_MTVEC:    csr_mtvec_r    = csr_wdata_i & `CSR_MTVEC_MASK;
        `CSR_MCAUSE:   csr_mcause_r   = csr_wdata_i & `CSR_MCAUSE_MASK;
        `CSR_MTVAL:    csr_mtval_r    = csr_wdata_i & `CSR_MTVAL_MASK;
        `CSR_MSTATUS:  csr_sr_r       = csr_wdata_i & `CSR_MSTATUS_MASK;
        `CSR_MIP:      csr_mip_r      = csr_wdata_i & `CSR_MIP_MASK;
        `CSR_MIE:      csr_mie_r      = csr_wdata_i & `CSR_MIE_MASK;
        `CSR_MEDELEG:  csr_medeleg_r  = csr_wdata_i & `CSR_MEDELEG_MASK;
        `CSR_MIDELEG:  csr_mideleg_r  = csr_wdata_i & `CSR_MIDELEG_MASK;
        // Non-std behaviour
        `CSR_MTIMECMP:
        begin
            csr_mtimecmp_r = csr_wdata_i & `CSR_MTIMECMP_MASK;
            csr_mtime_ie_r = 1'b1;
        end
        // CSR - Super
        `CSR_SEPC:     csr_sepc_r     = csr_wdata_i & `CSR_SEPC_MASK;
        `CSR_STVEC:    csr_stvec_r    = csr_wdata_i & `CSR_STVEC_MASK;
        `CSR_SCAUSE:   csr_scause_r   = csr_wdata_i & `CSR_SCAUSE_MASK;
        `CSR_STVAL:    csr_stval_r    = csr_wdata_i & `CSR_STVAL_MASK;
        `CSR_SATP:     csr_satp_r     = csr_wdata_i & `CSR_SATP_MASK;
        `CSR_SSCRATCH: csr_sscratch_r = csr_wdata_i & `CSR_SSCRATCH_MASK;
        `CSR_SSTATUS:  csr_sr_r       = (csr_sr_r & ~`CSR_SSTATUS_MASK) | (csr_wdata_i & `CSR_SSTATUS_MASK);
        `CSR_SIP:      csr_mip_r      = (csr_mip_r & ~`CSR_SIP_MASK) | (csr_wdata_i & `CSR_SIP_MASK);
        `CSR_SIE:      csr_mie_r      = (csr_mie_r & ~`CSR_SIE_MASK) | (csr_wdata_i & `CSR_SIE_MASK);
        default:
            ;
        endcase
    end
 
    // External interrupts
    // NOTE: If the machine level interrupts are delegated to supervisor, route the interrupts there instead..
    if (ext_intr_i   &&  csr_mideleg_q[`SR_IP_MEIP_R]) csr_mip_next_r[`SR_IP_SEIP_R] = 1'b1;
    if (ext_intr_i   && ~csr_mideleg_q[`SR_IP_MEIP_R]) csr_mip_next_r[`SR_IP_MEIP_R] = 1'b1;
    if (timer_intr_i &&  csr_mideleg_q[`SR_IP_MTIP_R]) csr_mip_next_r[`SR_IP_STIP_R] = 1'b1;
    if (timer_intr_i && ~csr_mideleg_q[`SR_IP_MTIP_R]) csr_mip_next_r[`SR_IP_MTIP_R] = 1'b1;

    // Optional: Internal timer compare interrupt
    if (SUPPORT_MTIMECMP && csr_mcycle_q == csr_mtimecmp_q)
    begin
        if (csr_mideleg_q[`SR_IP_MTIP_R])
            csr_mip_next_r[`SR_IP_STIP_R] = csr_mtime_ie_q;
        else
            csr_mip_next_r[`SR_IP_MTIP_R] = csr_mtime_ie_q;
        csr_mtime_ie_r  = 1'b0;
    end

    csr_mip_r = csr_mip_r | csr_mip_next_r;
end

//-----------------------------------------------------------------
// Sequential
//-----------------------------------------------------------------
`ifdef verilator
`define HAS_SIM_CTRL
`endif
`ifdef verilog_sim
`define HAS_SIM_CTRL
`endif

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    // CSR - Machine
    csr_mepc_q         <= 32'b0;
    csr_sr_q           <= 32'b0;
    csr_mcause_q       <= 32'b0;
    csr_mtval_q        <= 32'b0;
    csr_mtvec_q        <= 32'b0;
    csr_mip_q          <= 32'b0;
    csr_mie_q          <= 32'b0;
    csr_mpriv_q        <= `PRIV_MACHINE;
    csr_mcycle_q       <= 32'b0;
    csr_mcycle_h_q     <= 32'b0;
    csr_mscratch_q     <= 32'b0;
    csr_mtimecmp_q     <= 32'b0;
    csr_mtime_ie_q     <= 1'b0;
    csr_medeleg_q      <= 32'b0;
    csr_mideleg_q      <= 32'b0;

    // CSR - Super
    csr_sepc_q         <= 32'b0;
    csr_stvec_q        <= 32'b0;
    csr_scause_q       <= 32'b0;
    csr_stval_q        <= 32'b0;
    csr_satp_q         <= 32'b0;
    csr_sscratch_q     <= 32'b0;

    csr_mip_next_q     <= 32'b0;
end
else
begin
    // CSR - Machine
    csr_mepc_q         <= csr_mepc_r;
    csr_sr_q           <= csr_sr_r;
    csr_mcause_q       <= csr_mcause_r;
    csr_mtval_q        <= csr_mtval_r;
    csr_mtvec_q        <= csr_mtvec_r;
    csr_mip_q          <= csr_mip_r;
    csr_mie_q          <= csr_mie_r;
    csr_mpriv_q        <= SUPPORT_SUPER ? csr_mpriv_r : `PRIV_MACHINE;
    csr_mcycle_q       <= csr_mcycle_r;
    csr_mscratch_q     <= csr_mscratch_r;
    csr_mtimecmp_q     <= SUPPORT_MTIMECMP ? csr_mtimecmp_r : 32'b0;
    csr_mtime_ie_q     <= SUPPORT_MTIMECMP ? csr_mtime_ie_r : 1'b0;
    csr_medeleg_q      <= SUPPORT_SUPER ? (csr_medeleg_r   & `CSR_MEDELEG_MASK) : 32'b0;
    csr_mideleg_q      <= SUPPORT_SUPER ? (csr_mideleg_r   & `CSR_MIDELEG_MASK) : 32'b0;

    // CSR - Super
    csr_sepc_q         <= SUPPORT_SUPER ? (csr_sepc_r     & `CSR_SEPC_MASK)     : 32'b0;
    csr_stvec_q        <= SUPPORT_SUPER ? (csr_stvec_r    & `CSR_STVEC_MASK)    : 32'b0;
    csr_scause_q       <= SUPPORT_SUPER ? (csr_scause_r   & `CSR_SCAUSE_MASK)   : 32'b0;
    csr_stval_q        <= SUPPORT_SUPER ? (csr_stval_r    & `CSR_STVAL_MASK)    : 32'b0;
    csr_satp_q         <= SUPPORT_SUPER ? (csr_satp_r     & `CSR_SATP_MASK)     : 32'b0;
    csr_sscratch_q     <= SUPPORT_SUPER ? (csr_sscratch_r & `CSR_SSCRATCH_MASK) : 32'b0;

    csr_mip_next_q     <= buffer_mip_w ? csr_mip_next_r : 32'b0;

    // Increment upper cycle counter on lower 32-bit overflow
    if (csr_mcycle_q == 32'hFFFFFFFF)
        csr_mcycle_h_q <= csr_mcycle_h_q + 32'd1;

`ifdef HAS_SIM_CTRL
    // CSR SIM_CTRL (or DSCRATCH)
    if ((csr_waddr_i == `CSR_DSCRATCH || csr_waddr_i == `CSR_SIM_CTRL) && ~(|exception_i))
    begin
        case (csr_wdata_i & 32'hFF000000)
        `CSR_SIM_CTRL_EXIT:
        begin
            //exit(csr_wdata_i[7:0]);
            $finish;
            $finish;
        end
        `CSR_SIM_CTRL_PUTC:
        begin
            $write("%c", csr_wdata_i[7:0]);
        end
        endcase
    end
`endif
end

//-----------------------------------------------------------------
// CSR branch
//-----------------------------------------------------------------
reg        branch_r;
reg [31:0] branch_target_r;

always @ *
begin
    branch_r        = 1'b0;
    branch_target_r = 32'b0;

    // Interrupts
    if (exception_i == `EXCEPTION_INTERRUPT)
    begin
        branch_r        = 1'b1;
        branch_target_r = (irq_priv_q == `PRIV_MACHINE) ? csr_mtvec_q : csr_stvec_q;
    end
    // Exception return
    else if (exception_i >= `EXCEPTION_ERET_U && exception_i <= `EXCEPTION_ERET_M)
    begin
        // MRET (return from machine)
        if (exception_i[1:0] == `PRIV_MACHINE)
        begin    
            branch_r        = 1'b1;
            branch_target_r = csr_mepc_q;
        end
        // SRET (return from supervisor)
        else
        begin
            branch_r        = 1'b1;
            branch_target_r = csr_sepc_q;
        end
    end
    // Exception - handled in super mode
    else if (is_exception_w && exception_s_w)
    begin
        branch_r        = 1'b1;
        branch_target_r = csr_stvec_q;
    end
    // Exception - handled in machine mode
    else if (is_exception_w)
    begin
        branch_r        = 1'b1;
        branch_target_r = csr_mtvec_q;
    end
    // Fence / SATP register writes cause pipeline flushes
    else if (exception_i == `EXCEPTION_FENCE)
    begin
        branch_r        = 1'b1;
        branch_target_r = exception_pc_i + 32'd4;
    end
end

assign csr_branch_o = branch_r;
assign csr_target_o = branch_target_r;

`ifdef verilator
function [31:0] get_mcycle; /*verilator public*/
begin
    get_mcycle = csr_mcycle_q;
end
endfunction
`endif

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_csr
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_MULDIV   = 1
    ,parameter SUPPORT_SUPER    = 1
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           intr_i
    ,input           opcode_valid_i
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_pc_i
    ,input           opcode_invalid_i
    ,input  [  4:0]  opcode_rd_idx_i
    ,input  [  4:0]  opcode_ra_idx_i
    ,input  [  4:0]  opcode_rb_idx_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i
    ,input           csr_writeback_write_i
    ,input  [ 11:0]  csr_writeback_waddr_i
    ,input  [ 31:0]  csr_writeback_wdata_i
    ,input  [  5:0]  csr_writeback_exception_i
    ,input  [ 31:0]  csr_writeback_exception_pc_i
    ,input  [ 31:0]  csr_writeback_exception_addr_i
    ,input  [ 31:0]  cpu_id_i
    ,input  [ 31:0]  reset_vector_i
    ,input           interrupt_inhibit_i

    // Outputs
    ,output [ 31:0]  csr_result_e1_value_o
    ,output          csr_result_e1_write_o
    ,output [ 31:0]  csr_result_e1_wdata_o
    ,output [  5:0]  csr_result_e1_exception_o
    ,output          branch_csr_request_o
    ,output [ 31:0]  branch_csr_pc_o
    ,output [  1:0]  branch_csr_priv_o
    ,output          take_interrupt_o
    ,output          ifence_o
    ,output [  1:0]  mmu_priv_d_o
    ,output          mmu_sum_o
    ,output          mmu_mxr_o
    ,output          mmu_flush_o
    ,output [ 31:0]  mmu_satp_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
wire ecall_w             = opcode_valid_i && ((opcode_opcode_i & `INST_ECALL_MASK)      == `INST_ECALL);
wire ebreak_w            = opcode_valid_i && ((opcode_opcode_i & `INST_EBREAK_MASK)     == `INST_EBREAK);
wire eret_w              = opcode_valid_i && ((opcode_opcode_i & `INST_ERET_MASK)       == `INST_ERET);
wire [1:0] eret_priv_w   = opcode_opcode_i[29:28];
wire csrrw_w             = opcode_valid_i && ((opcode_opcode_i & `INST_CSRRW_MASK)      == `INST_CSRRW);
wire csrrs_w             = opcode_valid_i && ((opcode_opcode_i & `INST_CSRRS_MASK)      == `INST_CSRRS);
wire csrrc_w             = opcode_valid_i && ((opcode_opcode_i & `INST_CSRRC_MASK)      == `INST_CSRRC);
wire csrrwi_w            = opcode_valid_i && ((opcode_opcode_i & `INST_CSRRWI_MASK)     == `INST_CSRRWI);
wire csrrsi_w            = opcode_valid_i && ((opcode_opcode_i & `INST_CSRRSI_MASK)     == `INST_CSRRSI);
wire csrrci_w            = opcode_valid_i && ((opcode_opcode_i & `INST_CSRRCI_MASK)     == `INST_CSRRCI);
wire wfi_w               = opcode_valid_i && ((opcode_opcode_i & `INST_WFI_MASK)        == `INST_WFI);
wire fence_w             = opcode_valid_i && ((opcode_opcode_i & `INST_FENCE_MASK)      == `INST_FENCE);
wire sfence_w            = opcode_valid_i && ((opcode_opcode_i & `INST_SFENCE_MASK)     == `INST_SFENCE);
wire ifence_w            = opcode_valid_i && ((opcode_opcode_i & `INST_IFENCE_MASK)     == `INST_IFENCE);

//-----------------------------------------------------------------
// CSR handling
//-----------------------------------------------------------------
wire [1:0]  current_priv_w;
reg [1:0]   csr_priv_r;
reg         csr_readonly_r;
reg         csr_write_r;
reg         set_r;
reg         clr_r;
reg         csr_fault_r;

reg [31:0]  data_r;

always @ *
begin
    set_r           = csrrw_w | csrrs_w | csrrwi_w | csrrsi_w;
    clr_r           = csrrw_w | csrrc_w | csrrwi_w | csrrci_w;

    csr_priv_r      = opcode_opcode_i[29:28];
    csr_readonly_r  = (opcode_opcode_i[31:30] == 2'd3);
    csr_write_r     = (opcode_ra_idx_i != 5'b0) | csrrw_w | csrrwi_w;

    data_r          = (csrrwi_w | 
                       csrrsi_w | 
                       csrrci_w) ?
                            {27'b0, opcode_ra_idx_i} : opcode_ra_operand_i;

    // Detect access fault on CSR access
    csr_fault_r     = SUPPORT_SUPER ? (opcode_valid_i && (set_r | clr_r) && ((csr_write_r && csr_readonly_r) || (current_priv_w < csr_priv_r))) : 1'b0;
end

wire satp_update_w = (opcode_valid_i && (set_r || clr_r) && csr_write_r && (opcode_opcode_i[31:20] == `CSR_SATP));

//-----------------------------------------------------------------
// CSR register file
//-----------------------------------------------------------------
wire timer_irq_w = 1'b0;

wire [31:0] misa_w = SUPPORT_MULDIV ? (`MISA_RV32 | `MISA_RVI | `MISA_RVM): (`MISA_RV32 | `MISA_RVI);

wire [31:0] csr_rdata_w;

wire        csr_branch_w;
wire [31:0] csr_target_w;

wire [31:0] interrupt_w;
wire [31:0] status_reg_w;
wire [31:0] satp_reg_w;

riscv_csr_regfile
#( .SUPPORT_MTIMECMP(1)
  ,.SUPPORT_SUPER(SUPPORT_SUPER) )
u_csrfile
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.ext_intr_i(intr_i)
    ,.timer_intr_i(timer_irq_w)
    ,.cpu_id_i(cpu_id_i)
    ,.misa_i(misa_w)

    // Issue
    ,.csr_ren_i(opcode_valid_i)
    ,.csr_raddr_i(opcode_opcode_i[31:20])
    ,.csr_rdata_o(csr_rdata_w)

    // Exception (WB)
    ,.exception_i(csr_writeback_exception_i)
    ,.exception_pc_i(csr_writeback_exception_pc_i)
    ,.exception_addr_i(csr_writeback_exception_addr_i)

    // CSR register writes (WB)
    ,.csr_waddr_i(csr_writeback_write_i ? csr_writeback_waddr_i : 12'b0)
    ,.csr_wdata_i(csr_writeback_wdata_i)

    // CSR branches
    ,.csr_branch_o(csr_branch_w)
    ,.csr_target_o(csr_target_w)

    // Various CSR registers
    ,.priv_o(current_priv_w)
    ,.status_o(status_reg_w)
    ,.satp_o(satp_reg_w)

    // Masked interrupt output
    ,.interrupt_o(interrupt_w)
);

//-----------------------------------------------------------------
// CSR Read Result (E1) / Early exceptions
//-----------------------------------------------------------------
reg                     rd_valid_e1_q;
reg [ 31:0]             rd_result_e1_q;
reg [ 31:0]             csr_wdata_e1_q;
reg [`EXCEPTION_W-1:0]  exception_e1_q;

// Inappropriate xRET for the current exec priv level
wire                    eret_fault_w = eret_w && (current_priv_w < eret_priv_w);

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    rd_valid_e1_q   <= 1'b0;
    rd_result_e1_q  <= 32'b0;
    csr_wdata_e1_q  <= 32'b0;
    exception_e1_q  <= `EXCEPTION_W'b0;
end
else if (opcode_valid_i)
begin
    rd_valid_e1_q   <= (set_r || clr_r) && ~csr_fault_r;

    // Invalid instruction / CSR access fault?
    // Record opcode for writing to csr_xtval later.
    if (opcode_invalid_i || csr_fault_r || eret_fault_w)
        rd_result_e1_q  <= opcode_opcode_i;
    else    
        rd_result_e1_q  <= csr_rdata_w;

    // E1 CSR exceptions
    if ((opcode_opcode_i & `INST_ECALL_MASK) == `INST_ECALL)
        exception_e1_q  <= `EXCEPTION_ECALL + {4'b0, current_priv_w};
    // xRET for priv level above this one - fault
    else if (eret_fault_w)
        exception_e1_q  <= `EXCEPTION_ILLEGAL_INSTRUCTION;
    else if ((opcode_opcode_i & `INST_ERET_MASK) == `INST_ERET)
        exception_e1_q  <= `EXCEPTION_ERET_U + {4'b0, eret_priv_w};
    else if ((opcode_opcode_i & `INST_EBREAK_MASK) == `INST_EBREAK)
        exception_e1_q  <= `EXCEPTION_BREAKPOINT;
    else if (opcode_invalid_i || csr_fault_r)
        exception_e1_q  <= `EXCEPTION_ILLEGAL_INSTRUCTION;
    // Fence / MMU settings cause a pipeline flush
    else if (satp_update_w || ifence_w || sfence_w)
        exception_e1_q  <= `EXCEPTION_FENCE;
    else
        exception_e1_q  <= `EXCEPTION_W'b0;

    // Value to be written to CSR registers
    if (set_r && clr_r)
        csr_wdata_e1_q <= data_r;
    else if (set_r)
        csr_wdata_e1_q <= csr_rdata_w | data_r;
    else if (clr_r)
        csr_wdata_e1_q <= csr_rdata_w & ~data_r;
end
else
begin
    rd_valid_e1_q   <= 1'b0;
    rd_result_e1_q  <= 32'b0;
    csr_wdata_e1_q  <= 32'b0;
    exception_e1_q  <= `EXCEPTION_W'b0;
end

assign csr_result_e1_value_o     = rd_result_e1_q;
assign csr_result_e1_write_o     = rd_valid_e1_q;
assign csr_result_e1_wdata_o     = csr_wdata_e1_q;
assign csr_result_e1_exception_o = exception_e1_q;

//-----------------------------------------------------------------
// Interrupt launch enable
//-----------------------------------------------------------------
reg take_interrupt_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    take_interrupt_q    <= 1'b0;
else
    take_interrupt_q    <= (|interrupt_w) & ~interrupt_inhibit_i;

assign take_interrupt_o = take_interrupt_q;

//-----------------------------------------------------------------
// TLB flush
//-----------------------------------------------------------------
reg tlb_flush_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    tlb_flush_q <= 1'b0;
else
    tlb_flush_q <= satp_update_w || sfence_w;

//-----------------------------------------------------------------
// ifence
//-----------------------------------------------------------------
reg ifence_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    ifence_q    <= 1'b0;
else
    ifence_q    <= ifence_w;

assign ifence_o = ifence_q;

//-----------------------------------------------------------------
// Execute - Branch operations
//-----------------------------------------------------------------
reg        branch_q;
reg [31:0] branch_target_q;
reg        reset_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    branch_target_q <= 32'b0;
    branch_q        <= 1'b0;
    reset_q         <= 1'b1;
end
else if (reset_q)
begin
    branch_target_q <= reset_vector_i;
    branch_q        <= 1'b1;
    reset_q         <= 1'b0;
end
else
begin
    branch_q        <= csr_branch_w;
    branch_target_q <= csr_target_w;
end

assign branch_csr_request_o = branch_q;
assign branch_csr_pc_o      = branch_target_q;
assign branch_csr_priv_o    = satp_reg_w[`SATP_MODE_R] ? current_priv_w : `PRIV_MACHINE;

//-----------------------------------------------------------------
// MMU
//-----------------------------------------------------------------
assign mmu_priv_d_o     = status_reg_w[`SR_MPRV_R] ? status_reg_w[`SR_MPP_R] : current_priv_w;
assign mmu_satp_o       = satp_reg_w;
assign mmu_flush_o      = tlb_flush_q;
assign mmu_sum_o        = status_reg_w[`SR_SUM_R];
assign mmu_mxr_o        = status_reg_w[`SR_MXR_R];

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
`include "riscv_defs.v"

module riscv_decoder
(
     input                        valid_i
    ,input                        fetch_fault_i
    ,input                        enable_muldiv_i
    ,input  [31:0]                opcode_i

    ,output                       invalid_o
    ,output                       exec_o
    ,output                       lsu_o
    ,output                       branch_o
    ,output                       mul_o
    ,output                       div_o
    ,output                       csr_o
    ,output                       rd_valid_o
);

// Invalid instruction
wire invalid_w =    valid_i && 
                   ~(((opcode_i & `INST_ANDI_MASK) == `INST_ANDI)             ||
                    ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI)              ||
                    ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI)              ||
                    ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU)            ||
                    ((opcode_i & `INST_ORI_MASK) == `INST_ORI)                ||
                    ((opcode_i & `INST_XORI_MASK) == `INST_XORI)              ||
                    ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI)              ||
                    ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI)              ||
                    ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI)              ||
                    ((opcode_i & `INST_LUI_MASK) == `INST_LUI)                ||
                    ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC)            ||
                    ((opcode_i & `INST_ADD_MASK) == `INST_ADD)                ||
                    ((opcode_i & `INST_SUB_MASK) == `INST_SUB)                ||
                    ((opcode_i & `INST_SLT_MASK) == `INST_SLT)                ||
                    ((opcode_i & `INST_SLTU_MASK) == `INST_SLTU)              ||
                    ((opcode_i & `INST_XOR_MASK) == `INST_XOR)                ||
                    ((opcode_i & `INST_OR_MASK) == `INST_OR)                  ||
                    ((opcode_i & `INST_AND_MASK) == `INST_AND)                ||
                    ((opcode_i & `INST_SLL_MASK) == `INST_SLL)                ||
                    ((opcode_i & `INST_SRL_MASK) == `INST_SRL)                ||
                    ((opcode_i & `INST_SRA_MASK) == `INST_SRA)                ||
                    ((opcode_i & `INST_JAL_MASK) == `INST_JAL)                ||
                    ((opcode_i & `INST_JALR_MASK) == `INST_JALR)              ||
                    ((opcode_i & `INST_BEQ_MASK) == `INST_BEQ)                ||
                    ((opcode_i & `INST_BNE_MASK) == `INST_BNE)                ||
                    ((opcode_i & `INST_BLT_MASK) == `INST_BLT)                ||
                    ((opcode_i & `INST_BGE_MASK) == `INST_BGE)                ||
                    ((opcode_i & `INST_BLTU_MASK) == `INST_BLTU)              ||
                    ((opcode_i & `INST_BGEU_MASK) == `INST_BGEU)              ||
                    ((opcode_i & `INST_LB_MASK) == `INST_LB)                  ||
                    ((opcode_i & `INST_LH_MASK) == `INST_LH)                  ||
                    ((opcode_i & `INST_LW_MASK) == `INST_LW)                  ||
                    ((opcode_i & `INST_LBU_MASK) == `INST_LBU)                ||
                    ((opcode_i & `INST_LHU_MASK) == `INST_LHU)                ||
                    ((opcode_i & `INST_LWU_MASK) == `INST_LWU)                ||
                    ((opcode_i & `INST_SB_MASK) == `INST_SB)                  ||
                    ((opcode_i & `INST_SH_MASK) == `INST_SH)                  ||
                    ((opcode_i & `INST_SW_MASK) == `INST_SW)                  ||
                    ((opcode_i & `INST_ECALL_MASK) == `INST_ECALL)            ||
                    ((opcode_i & `INST_EBREAK_MASK) == `INST_EBREAK)          ||
                    ((opcode_i & `INST_ERET_MASK) == `INST_ERET)              ||
                    ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW)            ||
                    ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS)            ||
                    ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC)            ||
                    ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI)          ||
                    ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI)          ||
                    ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI)          ||
                    ((opcode_i & `INST_WFI_MASK) == `INST_WFI)                ||
                    ((opcode_i & `INST_FENCE_MASK) == `INST_FENCE)            ||
                    ((opcode_i & `INST_IFENCE_MASK) == `INST_IFENCE)          ||
                    ((opcode_i & `INST_SFENCE_MASK) == `INST_SFENCE)          ||
                    (enable_muldiv_i && (opcode_i & `INST_MUL_MASK) == `INST_MUL)       ||
                    (enable_muldiv_i && (opcode_i & `INST_MULH_MASK) == `INST_MULH)     ||
                    (enable_muldiv_i && (opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU) ||
                    (enable_muldiv_i && (opcode_i & `INST_MULHU_MASK) == `INST_MULHU)   ||
                    (enable_muldiv_i && (opcode_i & `INST_DIV_MASK) == `INST_DIV)       ||
                    (enable_muldiv_i && (opcode_i & `INST_DIVU_MASK) == `INST_DIVU)     ||
                    (enable_muldiv_i && (opcode_i & `INST_REM_MASK) == `INST_REM)       ||
                    (enable_muldiv_i && (opcode_i & `INST_REMU_MASK) == `INST_REMU));

assign invalid_o = invalid_w;

assign rd_valid_o = ((opcode_i & `INST_JALR_MASK) == `INST_JALR)     ||
                    ((opcode_i & `INST_JAL_MASK) == `INST_JAL)       ||
                    ((opcode_i & `INST_LUI_MASK) == `INST_LUI)       ||
                    ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC)   ||
                    ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI)     ||
                    ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI)     ||
                    ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI)     ||
                    ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU)   ||
                    ((opcode_i & `INST_XORI_MASK) == `INST_XORI)     ||
                    ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI)     ||
                    ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI)     ||
                    ((opcode_i & `INST_ORI_MASK) == `INST_ORI)       ||
                    ((opcode_i & `INST_ANDI_MASK) == `INST_ANDI)     ||
                    ((opcode_i & `INST_ADD_MASK) == `INST_ADD)       ||
                    ((opcode_i & `INST_SUB_MASK) == `INST_SUB)       ||
                    ((opcode_i & `INST_SLL_MASK) == `INST_SLL)       ||
                    ((opcode_i & `INST_SLT_MASK) == `INST_SLT)       ||
                    ((opcode_i & `INST_SLTU_MASK) == `INST_SLTU)     ||
                    ((opcode_i & `INST_XOR_MASK) == `INST_XOR)       ||
                    ((opcode_i & `INST_SRL_MASK) == `INST_SRL)       ||
                    ((opcode_i & `INST_SRA_MASK) == `INST_SRA)       ||
                    ((opcode_i & `INST_OR_MASK) == `INST_OR)         ||
                    ((opcode_i & `INST_AND_MASK) == `INST_AND)       ||
                    ((opcode_i & `INST_LB_MASK) == `INST_LB)         ||
                    ((opcode_i & `INST_LH_MASK) == `INST_LH)         ||
                    ((opcode_i & `INST_LW_MASK) == `INST_LW)         ||
                    ((opcode_i & `INST_LBU_MASK) == `INST_LBU)       ||
                    ((opcode_i & `INST_LHU_MASK) == `INST_LHU)       ||
                    ((opcode_i & `INST_LWU_MASK) == `INST_LWU)       ||
                    ((opcode_i & `INST_MUL_MASK) == `INST_MUL)       ||
                    ((opcode_i & `INST_MULH_MASK) == `INST_MULH)     ||
                    ((opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU) ||
                    ((opcode_i & `INST_MULHU_MASK) == `INST_MULHU)   ||
                    ((opcode_i & `INST_DIV_MASK) == `INST_DIV)       ||
                    ((opcode_i & `INST_DIVU_MASK) == `INST_DIVU)     ||
                    ((opcode_i & `INST_REM_MASK) == `INST_REM)       ||
                    ((opcode_i & `INST_REMU_MASK) == `INST_REMU)     ||
                    ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW)   ||
                    ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS)   ||
                    ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC)   ||
                    ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI) ||
                    ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI) ||
                    ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI);

assign exec_o =     ((opcode_i & `INST_ANDI_MASK) == `INST_ANDI)  ||
                    ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI)  ||
                    ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI)  ||
                    ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU)||
                    ((opcode_i & `INST_ORI_MASK) == `INST_ORI)    ||
                    ((opcode_i & `INST_XORI_MASK) == `INST_XORI)  ||
                    ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI)  ||
                    ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI)  ||
                    ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI)  ||
                    ((opcode_i & `INST_LUI_MASK) == `INST_LUI)    ||
                    ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC)||
                    ((opcode_i & `INST_ADD_MASK) == `INST_ADD)    ||
                    ((opcode_i & `INST_SUB_MASK) == `INST_SUB)    ||
                    ((opcode_i & `INST_SLT_MASK) == `INST_SLT)    ||
                    ((opcode_i & `INST_SLTU_MASK) == `INST_SLTU)  ||
                    ((opcode_i & `INST_XOR_MASK) == `INST_XOR)    ||
                    ((opcode_i & `INST_OR_MASK) == `INST_OR)      ||
                    ((opcode_i & `INST_AND_MASK) == `INST_AND)    ||
                    ((opcode_i & `INST_SLL_MASK) == `INST_SLL)    ||
                    ((opcode_i & `INST_SRL_MASK) == `INST_SRL)    ||
                    ((opcode_i & `INST_SRA_MASK) == `INST_SRA);

assign lsu_o =      ((opcode_i & `INST_LB_MASK) == `INST_LB)   ||
                    ((opcode_i & `INST_LH_MASK) == `INST_LH)   ||
                    ((opcode_i & `INST_LW_MASK) == `INST_LW)   ||
                    ((opcode_i & `INST_LBU_MASK) == `INST_LBU) ||
                    ((opcode_i & `INST_LHU_MASK) == `INST_LHU) ||
                    ((opcode_i & `INST_LWU_MASK) == `INST_LWU) ||
                    ((opcode_i & `INST_SB_MASK) == `INST_SB)   ||
                    ((opcode_i & `INST_SH_MASK) == `INST_SH)   ||
                    ((opcode_i & `INST_SW_MASK) == `INST_SW);

assign branch_o =   ((opcode_i & `INST_JAL_MASK) == `INST_JAL)   ||
                    ((opcode_i & `INST_JALR_MASK) == `INST_JALR) ||
                    ((opcode_i & `INST_BEQ_MASK) == `INST_BEQ)   ||
                    ((opcode_i & `INST_BNE_MASK) == `INST_BNE)   ||
                    ((opcode_i & `INST_BLT_MASK) == `INST_BLT)   ||
                    ((opcode_i & `INST_BGE_MASK) == `INST_BGE)   ||
                    ((opcode_i & `INST_BLTU_MASK) == `INST_BLTU) ||
                    ((opcode_i & `INST_BGEU_MASK) == `INST_BGEU);

assign mul_o =      enable_muldiv_i &&
                    (((opcode_i & `INST_MUL_MASK) == `INST_MUL)    ||
                    ((opcode_i & `INST_MULH_MASK) == `INST_MULH)   ||
                    ((opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU) ||
                    ((opcode_i & `INST_MULHU_MASK) == `INST_MULHU));

assign div_o =      enable_muldiv_i &&
                    (((opcode_i & `INST_DIV_MASK) == `INST_DIV) ||
                    ((opcode_i & `INST_DIVU_MASK) == `INST_DIVU) ||
                    ((opcode_i & `INST_REM_MASK) == `INST_REM) ||
                    ((opcode_i & `INST_REMU_MASK) == `INST_REMU));

assign csr_o =      ((opcode_i & `INST_ECALL_MASK) == `INST_ECALL)            ||
                    ((opcode_i & `INST_EBREAK_MASK) == `INST_EBREAK)          ||
                    ((opcode_i & `INST_ERET_MASK) == `INST_ERET)              ||
                    ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW)            ||
                    ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS)            ||
                    ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC)            ||
                    ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI)          ||
                    ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI)          ||
                    ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI)          ||
                    ((opcode_i & `INST_WFI_MASK) == `INST_WFI)                ||
                    ((opcode_i & `INST_FENCE_MASK) == `INST_FENCE)            ||
                    ((opcode_i & `INST_IFENCE_MASK) == `INST_IFENCE)          ||
                    ((opcode_i & `INST_SFENCE_MASK) == `INST_SFENCE)          ||
                    invalid_w || fetch_fault_i;

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_decode
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_MULDIV   = 1
    ,parameter EXTRA_DECODE_STAGE = 0
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           fetch_in_valid_i
    ,input  [ 31:0]  fetch_in_instr_i
    ,input  [ 31:0]  fetch_in_pc_i
    ,input           fetch_in_fault_fetch_i
    ,input           fetch_in_fault_page_i
    ,input           fetch_out_accept_i
    ,input           squash_decode_i

    // Outputs
    ,output          fetch_in_accept_o
    ,output          fetch_out_valid_o
    ,output [ 31:0]  fetch_out_instr_o
    ,output [ 31:0]  fetch_out_pc_o
    ,output          fetch_out_fault_fetch_o
    ,output          fetch_out_fault_page_o
    ,output          fetch_out_instr_exec_o
    ,output          fetch_out_instr_lsu_o
    ,output          fetch_out_instr_branch_o
    ,output          fetch_out_instr_mul_o
    ,output          fetch_out_instr_div_o
    ,output          fetch_out_instr_csr_o
    ,output          fetch_out_instr_rd_valid_o
    ,output          fetch_out_instr_invalid_o
);



wire        enable_muldiv_w     = SUPPORT_MULDIV;

//-----------------------------------------------------------------
// Extra decode stage (to improve cycle time)
//-----------------------------------------------------------------
generate
if (EXTRA_DECODE_STAGE)
begin
    wire [31:0] fetch_in_instr_w = (fetch_in_fault_page_i | fetch_in_fault_fetch_i) ? 32'b0 : fetch_in_instr_i;
    reg [66:0]  buffer_q;

    always @(posedge clk_i or posedge rst_i)
    if (rst_i)
        buffer_q <= 67'b0;
    else if (squash_decode_i)
        buffer_q <= 67'b0;
    else if (fetch_out_accept_i || !fetch_out_valid_o)
        buffer_q <= {fetch_in_valid_i, fetch_in_fault_page_i, fetch_in_fault_fetch_i, fetch_in_instr_w, fetch_in_pc_i};

    assign {fetch_out_valid_o,
            fetch_out_fault_page_o,
            fetch_out_fault_fetch_o,
            fetch_out_instr_o,
            fetch_out_pc_o} = buffer_q;

    riscv_decoder
    u_dec
    (
         .valid_i(fetch_out_valid_o)
        ,.fetch_fault_i(fetch_out_fault_page_o | fetch_out_fault_fetch_o)
        ,.enable_muldiv_i(enable_muldiv_w)
        ,.opcode_i(fetch_out_instr_o)

        ,.invalid_o(fetch_out_instr_invalid_o)
        ,.exec_o(fetch_out_instr_exec_o)
        ,.lsu_o(fetch_out_instr_lsu_o)
        ,.branch_o(fetch_out_instr_branch_o)
        ,.mul_o(fetch_out_instr_mul_o)
        ,.div_o(fetch_out_instr_div_o)
        ,.csr_o(fetch_out_instr_csr_o)
        ,.rd_valid_o(fetch_out_instr_rd_valid_o)
    );

    assign fetch_in_accept_o        = fetch_out_accept_i;
end
//-----------------------------------------------------------------
// Straight through decode
//-----------------------------------------------------------------
else
begin
    wire [31:0] fetch_in_instr_w = (fetch_in_fault_page_i | fetch_in_fault_fetch_i) ? 32'b0 : fetch_in_instr_i;

    riscv_decoder
    u_dec
    (
         .valid_i(fetch_in_valid_i)
        ,.fetch_fault_i(fetch_in_fault_fetch_i | fetch_in_fault_page_i)
        ,.enable_muldiv_i(enable_muldiv_w)
        ,.opcode_i(fetch_out_instr_o)

        ,.invalid_o(fetch_out_instr_invalid_o)
        ,.exec_o(fetch_out_instr_exec_o)
        ,.lsu_o(fetch_out_instr_lsu_o)
        ,.branch_o(fetch_out_instr_branch_o)
        ,.mul_o(fetch_out_instr_mul_o)
        ,.div_o(fetch_out_instr_div_o)
        ,.csr_o(fetch_out_instr_csr_o)
        ,.rd_valid_o(fetch_out_instr_rd_valid_o)
    );

    // Outputs
    assign fetch_out_valid_o        = fetch_in_valid_i;
    assign fetch_out_pc_o           = fetch_in_pc_i;
    assign fetch_out_instr_o        = fetch_in_instr_w;
    assign fetch_out_fault_page_o   = fetch_in_fault_page_i;
    assign fetch_out_fault_fetch_o  = fetch_in_fault_fetch_i;

    assign fetch_in_accept_o        = fetch_out_accept_i;
end
endgenerate


endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
//--------------------------------------------------------------------
// ALU Operations
//--------------------------------------------------------------------
`define ALU_NONE                                4'b0000
`define ALU_SHIFTL                              4'b0001
`define ALU_SHIFTR                              4'b0010
`define ALU_SHIFTR_ARITH                        4'b0011
`define ALU_ADD                                 4'b0100
`define ALU_SUB                                 4'b0110
`define ALU_AND                                 4'b0111
`define ALU_OR                                  4'b1000
`define ALU_XOR                                 4'b1001
`define ALU_LESS_THAN                           4'b1010
`define ALU_LESS_THAN_SIGNED                    4'b1011

//--------------------------------------------------------------------
// Instructions Masks
//--------------------------------------------------------------------
// andi
`define INST_ANDI 32'h7013
`define INST_ANDI_MASK 32'h707f

// addi
`define INST_ADDI 32'h13
`define INST_ADDI_MASK 32'h707f

// slti
`define INST_SLTI 32'h2013
`define INST_SLTI_MASK 32'h707f

// sltiu
`define INST_SLTIU 32'h3013
`define INST_SLTIU_MASK 32'h707f

// ori
`define INST_ORI 32'h6013
`define INST_ORI_MASK 32'h707f

// xori
`define INST_XORI 32'h4013
`define INST_XORI_MASK 32'h707f

// slli
`define INST_SLLI 32'h1013
`define INST_SLLI_MASK 32'hfc00707f

// srli
`define INST_SRLI 32'h5013
`define INST_SRLI_MASK 32'hfc00707f

// srai
`define INST_SRAI 32'h40005013
`define INST_SRAI_MASK 32'hfc00707f

// lui
`define INST_LUI 32'h37
`define INST_LUI_MASK 32'h7f

// auipc
`define INST_AUIPC 32'h17
`define INST_AUIPC_MASK 32'h7f

// add
`define INST_ADD 32'h33
`define INST_ADD_MASK 32'hfe00707f

// sub
`define INST_SUB 32'h40000033
`define INST_SUB_MASK 32'hfe00707f

// slt
`define INST_SLT 32'h2033
`define INST_SLT_MASK 32'hfe00707f

// sltu
`define INST_SLTU 32'h3033
`define INST_SLTU_MASK 32'hfe00707f

// xor
`define INST_XOR 32'h4033
`define INST_XOR_MASK 32'hfe00707f

// or
`define INST_OR 32'h6033
`define INST_OR_MASK 32'hfe00707f

// and
`define INST_AND 32'h7033
`define INST_AND_MASK 32'hfe00707f

// sll
`define INST_SLL 32'h1033
`define INST_SLL_MASK 32'hfe00707f

// srl
`define INST_SRL 32'h5033
`define INST_SRL_MASK 32'hfe00707f

// sra
`define INST_SRA 32'h40005033
`define INST_SRA_MASK 32'hfe00707f

// jal
`define INST_JAL 32'h6f
`define INST_JAL_MASK 32'h7f

// jalr
`define INST_JALR 32'h67
`define INST_JALR_MASK 32'h707f

// beq
`define INST_BEQ 32'h63
`define INST_BEQ_MASK 32'h707f

// bne
`define INST_BNE 32'h1063
`define INST_BNE_MASK 32'h707f

// blt
`define INST_BLT 32'h4063
`define INST_BLT_MASK 32'h707f

// bge
`define INST_BGE 32'h5063
`define INST_BGE_MASK 32'h707f

// bltu
`define INST_BLTU 32'h6063
`define INST_BLTU_MASK 32'h707f

// bgeu
`define INST_BGEU 32'h7063
`define INST_BGEU_MASK 32'h707f

// lb
`define INST_LB 32'h3
`define INST_LB_MASK 32'h707f

// lh
`define INST_LH 32'h1003
`define INST_LH_MASK 32'h707f

// lw
`define INST_LW 32'h2003
`define INST_LW_MASK 32'h707f

// lbu
`define INST_LBU 32'h4003
`define INST_LBU_MASK 32'h707f

// lhu
`define INST_LHU 32'h5003
`define INST_LHU_MASK 32'h707f

// lwu
`define INST_LWU 32'h6003
`define INST_LWU_MASK 32'h707f

// sb
`define INST_SB 32'h23
`define INST_SB_MASK 32'h707f

// sh
`define INST_SH 32'h1023
`define INST_SH_MASK 32'h707f

// sw
`define INST_SW 32'h2023
`define INST_SW_MASK 32'h707f

// ecall
`define INST_ECALL 32'h73
`define INST_ECALL_MASK 32'hffffffff

// ebreak
`define INST_EBREAK 32'h100073
`define INST_EBREAK_MASK 32'hffffffff

// eret
`define INST_ERET 32'h200073
`define INST_ERET_MASK 32'hcfffffff

// csrrw
`define INST_CSRRW 32'h1073
`define INST_CSRRW_MASK 32'h707f

// csrrs
`define INST_CSRRS 32'h2073
`define INST_CSRRS_MASK 32'h707f

// csrrc
`define INST_CSRRC 32'h3073
`define INST_CSRRC_MASK 32'h707f

// csrrwi
`define INST_CSRRWI 32'h5073
`define INST_CSRRWI_MASK 32'h707f

// csrrsi
`define INST_CSRRSI 32'h6073
`define INST_CSRRSI_MASK 32'h707f

// csrrci
`define INST_CSRRCI 32'h7073
`define INST_CSRRCI_MASK 32'h707f

// mul
`define INST_MUL 32'h2000033
`define INST_MUL_MASK 32'hfe00707f

// mulh
`define INST_MULH 32'h2001033
`define INST_MULH_MASK 32'hfe00707f

// mulhsu
`define INST_MULHSU 32'h2002033
`define INST_MULHSU_MASK 32'hfe00707f

// mulhu
`define INST_MULHU 32'h2003033
`define INST_MULHU_MASK 32'hfe00707f

// div
`define INST_DIV 32'h2004033
`define INST_DIV_MASK 32'hfe00707f

// divu
`define INST_DIVU 32'h2005033
`define INST_DIVU_MASK 32'hfe00707f

// rem
`define INST_REM 32'h2006033
`define INST_REM_MASK 32'hfe00707f

// remu
`define INST_REMU 32'h2007033
`define INST_REMU_MASK 32'hfe00707f

// wfi
`define INST_WFI 32'h10500073
`define INST_WFI_MASK 32'hffff8fff

// fence
`define INST_FENCE 32'hf
`define INST_FENCE_MASK 32'h707f

// sfence
`define INST_SFENCE 32'h12000073
`define INST_SFENCE_MASK 32'hfe007fff

// fence.i
`define INST_IFENCE 32'h100f
`define INST_IFENCE_MASK 32'h707f

//--------------------------------------------------------------------
// Privilege levels
//--------------------------------------------------------------------
`define PRIV_USER         2'd0
`define PRIV_SUPER        2'd1
`define PRIV_MACHINE      2'd3

//--------------------------------------------------------------------
// IRQ Numbers
//--------------------------------------------------------------------
`define IRQ_S_SOFT   1
`define IRQ_M_SOFT   3
`define IRQ_S_TIMER  5
`define IRQ_M_TIMER  7
`define IRQ_S_EXT    9
`define IRQ_M_EXT    11
`define IRQ_MIN      (`IRQ_S_SOFT)
`define IRQ_MAX      (`IRQ_M_EXT + 1)
`define IRQ_MASK     ((1 << `IRQ_M_EXT)   | (1 << `IRQ_S_EXT)   |                       (1 << `IRQ_M_TIMER) | (1 << `IRQ_S_TIMER) |                       (1 << `IRQ_M_SOFT)  | (1 << `IRQ_S_SOFT))

`define SR_IP_MSIP_R      `IRQ_M_SOFT
`define SR_IP_MTIP_R      `IRQ_M_TIMER
`define SR_IP_MEIP_R      `IRQ_M_EXT
`define SR_IP_SSIP_R      `IRQ_S_SOFT
`define SR_IP_STIP_R      `IRQ_S_TIMER
`define SR_IP_SEIP_R      `IRQ_S_EXT

//--------------------------------------------------------------------
// CSR Registers - Simulation control
//--------------------------------------------------------------------
`define CSR_DSCRATCH       12'h7b2
`define CSR_SIM_CTRL       12'h8b2
`define CSR_SIM_CTRL_MASK  32'hFFFFFFFF
    `define CSR_SIM_CTRL_EXIT (0 << 24)
    `define CSR_SIM_CTRL_PUTC (1 << 24)

//--------------------------------------------------------------------
// CSR Registers
//--------------------------------------------------------------------
`define CSR_MSTATUS       12'h300
`define CSR_MSTATUS_MASK  32'hFFFFFFFF
`define CSR_MISA          12'h301
`define CSR_MISA_MASK     32'hFFFFFFFF
    `define MISA_RV32     32'h40000000
    `define MISA_RVI      32'h00000100
    `define MISA_RVE      32'h00000010
    `define MISA_RVM      32'h00001000
    `define MISA_RVA      32'h00000001
    `define MISA_RVF      32'h00000020
    `define MISA_RVD      32'h00000008
    `define MISA_RVC      32'h00000004
    `define MISA_RVS      32'h00040000
    `define MISA_RVU      32'h00100000
`define CSR_MEDELEG       12'h302
`define CSR_MEDELEG_MASK  32'h0000FFFF
`define CSR_MIDELEG       12'h303
`define CSR_MIDELEG_MASK  32'h0000FFFF
`define CSR_MIE           12'h304
`define CSR_MIE_MASK      `IRQ_MASK
`define CSR_MTVEC         12'h305
`define CSR_MTVEC_MASK    32'hFFFFFFFF
`define CSR_MSCRATCH      12'h340
`define CSR_MSCRATCH_MASK 32'hFFFFFFFF
`define CSR_MEPC          12'h341
`define CSR_MEPC_MASK     32'hFFFFFFFF
`define CSR_MCAUSE        12'h342
`define CSR_MCAUSE_MASK   32'h8000000F
`define CSR_MTVAL         12'h343
`define CSR_MTVAL_MASK    32'hFFFFFFFF
`define CSR_MIP           12'h344
`define CSR_MIP_MASK      `IRQ_MASK
`define CSR_MCYCLE        12'hc00
`define CSR_MCYCLE_MASK   32'hFFFFFFFF
`define CSR_MTIME         12'hc01
`define CSR_MTIME_MASK    32'hFFFFFFFF
`define CSR_MTIMEH        12'hc81
`define CSR_MTIMEH_MASK   32'hFFFFFFFF
`define CSR_MHARTID       12'hF14
`define CSR_MHARTID_MASK  32'hFFFFFFFF

// Non-std
`define CSR_MTIMECMP        12'h7c0
`define CSR_MTIMECMP_MASK   32'hFFFFFFFF

//-----------------------------------------------------------------
// CSR Registers - Supervisor
//-----------------------------------------------------------------
`define CSR_SSTATUS       12'h100
`define CSR_SSTATUS_MASK  `SR_SMODE_MASK
`define CSR_SIE           12'h104
`define CSR_SIE_MASK      ((1 << `IRQ_S_EXT) | (1 << `IRQ_S_TIMER) | (1 << `IRQ_S_SOFT))
`define CSR_STVEC         12'h105
`define CSR_STVEC_MASK    32'hFFFFFFFF
`define CSR_SSCRATCH      12'h140
`define CSR_SSCRATCH_MASK 32'hFFFFFFFF
`define CSR_SEPC          12'h141
`define CSR_SEPC_MASK     32'hFFFFFFFF
`define CSR_SCAUSE        12'h142
`define CSR_SCAUSE_MASK   32'h8000000F
`define CSR_STVAL         12'h143
`define CSR_STVAL_MASK    32'hFFFFFFFF
`define CSR_SIP           12'h144
`define CSR_SIP_MASK      ((1 << `IRQ_S_EXT) | (1 << `IRQ_S_TIMER) | (1 << `IRQ_S_SOFT))
`define CSR_SATP          12'h180
`define CSR_SATP_MASK     32'hFFFFFFFF

//--------------------------------------------------------------------
// CSR Registers - DCACHE control
//--------------------------------------------------------------------
`define CSR_DFLUSH            12'h3a0 // pmpcfg0
`define CSR_DFLUSH_MASK       32'hFFFFFFFF
`define CSR_DWRITEBACK        12'h3a1 // pmpcfg1
`define CSR_DWRITEBACK_MASK   32'hFFFFFFFF
`define CSR_DINVALIDATE       12'h3a2 // pmpcfg2
`define CSR_DINVALIDATE_MASK  32'hFFFFFFFF

//--------------------------------------------------------------------
// Status Register
//--------------------------------------------------------------------
`define SR_UIE         (1 << 0)
`define SR_UIE_R       0
`define SR_SIE         (1 << 1)
`define SR_SIE_R       1
`define SR_MIE         (1 << 3)
`define SR_MIE_R       3
`define SR_UPIE        (1 << 4)
`define SR_UPIE_R      4
`define SR_SPIE        (1 << 5)
`define SR_SPIE_R      5
`define SR_MPIE        (1 << 7)
`define SR_MPIE_R      7
`define SR_SPP         (1 << 8)
`define SR_SPP_R       8

`define SR_MPP_SHIFT   11
`define SR_MPP_MASK    2'h3
`define SR_MPP_R       12:11
`define SR_MPP_U       `PRIV_USER
`define SR_MPP_S       `PRIV_SUPER
`define SR_MPP_M       `PRIV_MACHINE

`define SR_SUM_R        18
`define SR_SUM          (1 << `SR_SUM_R)

`define SR_MPRV_R       17
`define SR_MPRV         (1 << `SR_MPRV_R)

`define SR_MXR_R        19
`define SR_MXR          (1 << `SR_MXR_R)

`define SR_SMODE_MASK   (`SR_UIE | `SR_SIE | `SR_UPIE | `SR_SPIE | `SR_SPP | `SR_SUM)

//--------------------------------------------------------------------
// SATP definitions
//--------------------------------------------------------------------
`define SATP_PPN_R        19:0 // TODO: Should be 21??
`define SATP_ASID_R       30:22
`define SATP_MODE_R       31

//--------------------------------------------------------------------
// MMU Defs (SV32)
//--------------------------------------------------------------------
`define MMU_LEVELS        2
`define MMU_PTIDXBITS     10
`define MMU_PTESIZE       4
`define MMU_PGSHIFT       (`MMU_PTIDXBITS + 2)
`define MMU_PGSIZE        (1 << `MMU_PGSHIFT)
`define MMU_VPN_BITS      (`MMU_PTIDXBITS * `MMU_LEVELS)
`define MMU_PPN_BITS      (32 - `MMU_PGSHIFT)
`define MMU_VA_BITS       (`MMU_VPN_BITS + `MMU_PGSHIFT)

`define PAGE_PRESENT      0
`define PAGE_READ         1
`define PAGE_WRITE        2
`define PAGE_EXEC         3
`define PAGE_USER         4
`define PAGE_GLOBAL       5
`define PAGE_ACCESSED     6
`define PAGE_DIRTY        7
`define PAGE_SOFT         9:8

`define PAGE_FLAGS       10'h3FF

`define PAGE_PFN_SHIFT   10
`define PAGE_SIZE        4096

//--------------------------------------------------------------------
// Exception Causes
//--------------------------------------------------------------------
`define EXCEPTION_W                        6
`define EXCEPTION_MISALIGNED_FETCH         6'h10
`define EXCEPTION_FAULT_FETCH              6'h11
`define EXCEPTION_ILLEGAL_INSTRUCTION      6'h12
`define EXCEPTION_BREAKPOINT               6'h13
`define EXCEPTION_MISALIGNED_LOAD          6'h14
`define EXCEPTION_FAULT_LOAD               6'h15
`define EXCEPTION_MISALIGNED_STORE         6'h16
`define EXCEPTION_FAULT_STORE              6'h17
`define EXCEPTION_ECALL                    6'h18
`define EXCEPTION_ECALL_U                  6'h18
`define EXCEPTION_ECALL_S                  6'h19
`define EXCEPTION_ECALL_H                  6'h1a
`define EXCEPTION_ECALL_M                  6'h1b
`define EXCEPTION_PAGE_FAULT_INST          6'h1c
`define EXCEPTION_PAGE_FAULT_LOAD          6'h1d
`define EXCEPTION_PAGE_FAULT_STORE         6'h1f
`define EXCEPTION_EXCEPTION                6'h10
`define EXCEPTION_INTERRUPT                6'h20
`define EXCEPTION_ERET_U                   6'h30
`define EXCEPTION_ERET_S                   6'h31
`define EXCEPTION_ERET_H                   6'h32
`define EXCEPTION_ERET_M                   6'h33
`define EXCEPTION_FENCE                    6'h34
`define EXCEPTION_TYPE_MASK                6'h30
`define EXCEPTION_SUBTYPE_R                3:0

`define MCAUSE_INT                      31
`define MCAUSE_MISALIGNED_FETCH         ((0 << `MCAUSE_INT) | 0)
`define MCAUSE_FAULT_FETCH              ((0 << `MCAUSE_INT) | 1)
`define MCAUSE_ILLEGAL_INSTRUCTION      ((0 << `MCAUSE_INT) | 2)
`define MCAUSE_BREAKPOINT               ((0 << `MCAUSE_INT) | 3)
`define MCAUSE_MISALIGNED_LOAD          ((0 << `MCAUSE_INT) | 4)
`define MCAUSE_FAULT_LOAD               ((0 << `MCAUSE_INT) | 5)
`define MCAUSE_MISALIGNED_STORE         ((0 << `MCAUSE_INT) | 6)
`define MCAUSE_FAULT_STORE              ((0 << `MCAUSE_INT) | 7)
`define MCAUSE_ECALL_U                  ((0 << `MCAUSE_INT) | 8)
`define MCAUSE_ECALL_S                  ((0 << `MCAUSE_INT) | 9)
`define MCAUSE_ECALL_H                  ((0 << `MCAUSE_INT) | 10)
`define MCAUSE_ECALL_M                  ((0 << `MCAUSE_INT) | 11)
`define MCAUSE_PAGE_FAULT_INST          ((0 << `MCAUSE_INT) | 12)
`define MCAUSE_PAGE_FAULT_LOAD          ((0 << `MCAUSE_INT) | 13)
`define MCAUSE_PAGE_FAULT_STORE         ((0 << `MCAUSE_INT) | 15)
`define MCAUSE_INTERRUPT                (1 << `MCAUSE_INT)

//--------------------------------------------------------------------
// Debug
//--------------------------------------------------------------------
`define RISCV_REGNO_FIRST   13'd0
`define RISCV_REGNO_GPR0    13'd0
`define RISCV_REGNO_GPR31   13'd31
`define RISCV_REGNO_PC      13'd32
`define RISCV_REGNO_CSR0    13'd65
`define RISCV_REGNO_CSR4095 (`RISCV_REGNO_CSR0 +  13'd4095)
`define RISCV_REGNO_PRIV    13'd4161
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_divider
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           opcode_valid_i
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_pc_i
    ,input           opcode_invalid_i
    ,input  [  4:0]  opcode_rd_idx_i
    ,input  [  4:0]  opcode_ra_idx_i
    ,input  [  4:0]  opcode_rb_idx_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i

    // Outputs
    ,output          writeback_valid_o
    ,output [ 31:0]  writeback_value_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-------------------------------------------------------------
// Registers / Wires
//-------------------------------------------------------------
reg          valid_q;
reg  [31:0]  wb_result_q;

//-------------------------------------------------------------
// Divider
//-------------------------------------------------------------
wire inst_div_w         = (opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV;
wire inst_divu_w        = (opcode_opcode_i & `INST_DIVU_MASK) == `INST_DIVU;
wire inst_rem_w         = (opcode_opcode_i & `INST_REM_MASK) == `INST_REM;
wire inst_remu_w        = (opcode_opcode_i & `INST_REMU_MASK) == `INST_REMU;

wire div_rem_inst_w     = ((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV)  || 
                          ((opcode_opcode_i & `INST_DIVU_MASK) == `INST_DIVU) ||
                          ((opcode_opcode_i & `INST_REM_MASK) == `INST_REM)  ||
                          ((opcode_opcode_i & `INST_REMU_MASK) == `INST_REMU);

wire signed_operation_w = ((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV) || ((opcode_opcode_i & `INST_REM_MASK) == `INST_REM);
wire div_operation_w    = ((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV) || ((opcode_opcode_i & `INST_DIVU_MASK) == `INST_DIVU);

reg [31:0] dividend_q;
reg [62:0] divisor_q;
reg [31:0] quotient_q;
reg [31:0] q_mask_q;
reg        div_inst_q;
reg        div_busy_q;
reg        invert_res_q;

wire div_start_w    = opcode_valid_i & div_rem_inst_w;
wire div_complete_w = !(|q_mask_q) & div_busy_q;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
begin
    div_busy_q     <= 1'b0;
    dividend_q     <= 32'b0;
    divisor_q      <= 63'b0;
    invert_res_q   <= 1'b0;
    quotient_q     <= 32'b0;
    q_mask_q       <= 32'b0;
    div_inst_q     <= 1'b0;
end
else if (div_start_w)
begin

    div_busy_q     <= 1'b1;
    div_inst_q     <= div_operation_w;

    if (signed_operation_w && opcode_ra_operand_i[31])
        dividend_q <= -opcode_ra_operand_i;
    else
        dividend_q <= opcode_ra_operand_i;

    if (signed_operation_w && opcode_rb_operand_i[31])
        divisor_q <= {-opcode_rb_operand_i, 31'b0};
    else
        divisor_q <= {opcode_rb_operand_i, 31'b0};

    invert_res_q  <= (((opcode_opcode_i & `INST_DIV_MASK) == `INST_DIV) && (opcode_ra_operand_i[31] != opcode_rb_operand_i[31]) && |opcode_rb_operand_i) || 
                     (((opcode_opcode_i & `INST_REM_MASK) == `INST_REM) && opcode_ra_operand_i[31]);

    quotient_q     <= 32'b0;
    q_mask_q       <= 32'h80000000;
end
else if (div_complete_w)
begin
    div_busy_q <= 1'b0;
end
else if (div_busy_q)
begin
    if (divisor_q <= {31'b0, dividend_q})
    begin
        dividend_q <= dividend_q - divisor_q[31:0];
        quotient_q <= quotient_q | q_mask_q;
    end

    divisor_q <= {1'b0, divisor_q[62:1]};
    q_mask_q  <= {1'b0, q_mask_q[31:1]};
end

reg [31:0] div_result_r;
always @ *
begin
    div_result_r = 32'b0;

    if (div_inst_q)
        div_result_r = invert_res_q ? -quotient_q : quotient_q;
    else
        div_result_r = invert_res_q ? -dividend_q : dividend_q;
end

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    valid_q <= 1'b0;
else
    valid_q <= div_complete_w;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    wb_result_q <= 32'b0;
else if (div_complete_w)
    wb_result_q <= div_result_r;

assign writeback_valid_o = valid_q;
assign writeback_value_o  = wb_result_q;



endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_exec
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           opcode_valid_i
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_pc_i
    ,input           opcode_invalid_i
    ,input  [  4:0]  opcode_rd_idx_i
    ,input  [  4:0]  opcode_ra_idx_i
    ,input  [  4:0]  opcode_rb_idx_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i
    ,input           hold_i

    // Outputs
    ,output          branch_request_o
    ,output          branch_is_taken_o
    ,output          branch_is_not_taken_o
    ,output [ 31:0]  branch_source_o
    ,output          branch_is_call_o
    ,output          branch_is_ret_o
    ,output          branch_is_jmp_o
    ,output [ 31:0]  branch_pc_o
    ,output          branch_d_request_o
    ,output [ 31:0]  branch_d_pc_o
    ,output [  1:0]  branch_d_priv_o
    ,output [ 31:0]  writeback_value_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-------------------------------------------------------------
// Opcode decode
//-------------------------------------------------------------
reg [31:0]  imm20_r;
reg [31:0]  imm12_r;
reg [31:0]  bimm_r;
reg [31:0]  jimm20_r;
reg [4:0]   shamt_r;

always @ *
begin
    imm20_r     = {opcode_opcode_i[31:12], 12'b0};
    imm12_r     = {{20{opcode_opcode_i[31]}}, opcode_opcode_i[31:20]};
    bimm_r      = {{19{opcode_opcode_i[31]}}, opcode_opcode_i[31], opcode_opcode_i[7], opcode_opcode_i[30:25], opcode_opcode_i[11:8], 1'b0};
    jimm20_r    = {{12{opcode_opcode_i[31]}}, opcode_opcode_i[19:12], opcode_opcode_i[20], opcode_opcode_i[30:25], opcode_opcode_i[24:21], 1'b0};
    shamt_r     = opcode_opcode_i[24:20];
end

//-------------------------------------------------------------
// Execute - ALU operations
//-------------------------------------------------------------
reg [3:0]  alu_func_r;
reg [31:0] alu_input_a_r;
reg [31:0] alu_input_b_r;

always @ *
begin
    alu_func_r     = `ALU_NONE;
    alu_input_a_r  = 32'b0;
    alu_input_b_r  = 32'b0;

    if ((opcode_opcode_i & `INST_ADD_MASK) == `INST_ADD) // add
    begin
        alu_func_r     = `ALU_ADD;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_AND_MASK) == `INST_AND) // and
    begin
        alu_func_r     = `ALU_AND;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_OR_MASK) == `INST_OR) // or
    begin
        alu_func_r     = `ALU_OR;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_SLL_MASK) == `INST_SLL) // sll
    begin
        alu_func_r     = `ALU_SHIFTL;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_SRA_MASK) == `INST_SRA) // sra
    begin
        alu_func_r     = `ALU_SHIFTR_ARITH;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_SRL_MASK) == `INST_SRL) // srl
    begin
        alu_func_r     = `ALU_SHIFTR;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_SUB_MASK) == `INST_SUB) // sub
    begin
        alu_func_r     = `ALU_SUB;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_XOR_MASK) == `INST_XOR) // xor
    begin
        alu_func_r     = `ALU_XOR;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_SLT_MASK) == `INST_SLT) // slt
    begin
        alu_func_r     = `ALU_LESS_THAN_SIGNED;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_SLTU_MASK) == `INST_SLTU) // sltu
    begin
        alu_func_r     = `ALU_LESS_THAN;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = opcode_rb_operand_i;
    end
    else if ((opcode_opcode_i & `INST_ADDI_MASK) == `INST_ADDI) // addi
    begin
        alu_func_r     = `ALU_ADD;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = imm12_r;
    end
    else if ((opcode_opcode_i & `INST_ANDI_MASK) == `INST_ANDI) // andi
    begin
        alu_func_r     = `ALU_AND;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = imm12_r;
    end
    else if ((opcode_opcode_i & `INST_SLTI_MASK) == `INST_SLTI) // slti
    begin
        alu_func_r     = `ALU_LESS_THAN_SIGNED;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = imm12_r;
    end
    else if ((opcode_opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU) // sltiu
    begin
        alu_func_r     = `ALU_LESS_THAN;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = imm12_r;
    end
    else if ((opcode_opcode_i & `INST_ORI_MASK) == `INST_ORI) // ori
    begin
        alu_func_r     = `ALU_OR;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = imm12_r;
    end
    else if ((opcode_opcode_i & `INST_XORI_MASK) == `INST_XORI) // xori
    begin
        alu_func_r     = `ALU_XOR;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = imm12_r;
    end
    else if ((opcode_opcode_i & `INST_SLLI_MASK) == `INST_SLLI) // slli
    begin
        alu_func_r     = `ALU_SHIFTL;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = {27'b0, shamt_r};
    end
    else if ((opcode_opcode_i & `INST_SRLI_MASK) == `INST_SRLI) // srli
    begin
        alu_func_r     = `ALU_SHIFTR;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = {27'b0, shamt_r};
    end
    else if ((opcode_opcode_i & `INST_SRAI_MASK) == `INST_SRAI) // srai
    begin
        alu_func_r     = `ALU_SHIFTR_ARITH;
        alu_input_a_r  = opcode_ra_operand_i;
        alu_input_b_r  = {27'b0, shamt_r};
    end
    else if ((opcode_opcode_i & `INST_LUI_MASK) == `INST_LUI) // lui
    begin
        alu_input_a_r  = imm20_r;
    end
    else if ((opcode_opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC) // auipc
    begin
        alu_func_r     = `ALU_ADD;
        alu_input_a_r  = opcode_pc_i;
        alu_input_b_r  = imm20_r;
    end     
    else if (((opcode_opcode_i & `INST_JAL_MASK) == `INST_JAL) || ((opcode_opcode_i & `INST_JALR_MASK) == `INST_JALR)) // jal, jalr
    begin
        alu_func_r     = `ALU_ADD;
        alu_input_a_r  = opcode_pc_i;
        alu_input_b_r  = 32'd4;
    end
end


//-------------------------------------------------------------
// ALU
//-------------------------------------------------------------
wire [31:0]  alu_p_w;
riscv_alu
u_alu
(
    .alu_op_i(alu_func_r),
    .alu_a_i(alu_input_a_r),
    .alu_b_i(alu_input_b_r),
    .alu_p_o(alu_p_w)
);

//-------------------------------------------------------------
// Flop ALU output
//-------------------------------------------------------------
reg [31:0] result_q;
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    result_q  <= 32'b0;
else if (~hold_i)
    result_q <= alu_p_w;

assign writeback_value_o  = result_q;

//-----------------------------------------------------------------
// less_than_signed: Less than operator (signed)
// Inputs: x = left operand, y = right operand
// Return: (int)x < (int)y
//-----------------------------------------------------------------
function [0:0] less_than_signed;
    input  [31:0] x;
    input  [31:0] y;
    reg [31:0] v;
begin
    v = (x - y);
    if (x[31] != y[31])
        less_than_signed = x[31];
    else
        less_than_signed = v[31];
end
endfunction

//-----------------------------------------------------------------
// greater_than_signed: Greater than operator (signed)
// Inputs: x = left operand, y = right operand
// Return: (int)x > (int)y
//-----------------------------------------------------------------
function [0:0] greater_than_signed;
    input  [31:0] x;
    input  [31:0] y;
    reg [31:0] v;
begin
    v = (y - x);
    if (x[31] != y[31])
        greater_than_signed = y[31];
    else
        greater_than_signed = v[31];
end
endfunction

//-------------------------------------------------------------
// Execute - Branch operations
//-------------------------------------------------------------
reg        branch_r;
reg        branch_taken_r;
reg [31:0] branch_target_r;
reg        branch_call_r;
reg        branch_ret_r;
reg        branch_jmp_r;

always @ *
begin
    branch_r        = 1'b0;
    branch_taken_r  = 1'b0;
    branch_call_r   = 1'b0;
    branch_ret_r    = 1'b0;
    branch_jmp_r    = 1'b0;

    // Default branch_r target is relative to current PC
    branch_target_r = opcode_pc_i + bimm_r;

    if ((opcode_opcode_i & `INST_JAL_MASK) == `INST_JAL) // jal
    begin
        branch_r        = 1'b1;
        branch_taken_r  = 1'b1;
        branch_target_r = opcode_pc_i + jimm20_r;
        branch_call_r   = (opcode_rd_idx_i == 5'd1); // RA
        branch_jmp_r    = 1'b1;
    end
    else if ((opcode_opcode_i & `INST_JALR_MASK) == `INST_JALR) // jalr
    begin
        branch_r            = 1'b1;
        branch_taken_r      = 1'b1;
        branch_target_r     = opcode_ra_operand_i + imm12_r;
        branch_target_r[0]  = 1'b0;
        branch_ret_r        = (opcode_ra_idx_i == 5'd1 && imm12_r[11:0] == 12'b0); // RA
        branch_call_r       = ~branch_ret_r && (opcode_rd_idx_i == 5'd1); // RA
        branch_jmp_r        = ~(branch_call_r | branch_ret_r);
    end
    else if ((opcode_opcode_i & `INST_BEQ_MASK) == `INST_BEQ) // beq
    begin
        branch_r      = 1'b1;
        branch_taken_r= (opcode_ra_operand_i == opcode_rb_operand_i);
    end
    else if ((opcode_opcode_i & `INST_BNE_MASK) == `INST_BNE) // bne
    begin
        branch_r      = 1'b1;    
        branch_taken_r= (opcode_ra_operand_i != opcode_rb_operand_i);
    end
    else if ((opcode_opcode_i & `INST_BLT_MASK) == `INST_BLT) // blt
    begin
        branch_r      = 1'b1;
        branch_taken_r= less_than_signed(opcode_ra_operand_i, opcode_rb_operand_i);
    end
    else if ((opcode_opcode_i & `INST_BGE_MASK) == `INST_BGE) // bge
    begin
        branch_r      = 1'b1;    
        branch_taken_r= greater_than_signed(opcode_ra_operand_i,opcode_rb_operand_i) | (opcode_ra_operand_i == opcode_rb_operand_i);
    end
    else if ((opcode_opcode_i & `INST_BLTU_MASK) == `INST_BLTU) // bltu
    begin
        branch_r      = 1'b1;    
        branch_taken_r= (opcode_ra_operand_i < opcode_rb_operand_i);
    end
    else if ((opcode_opcode_i & `INST_BGEU_MASK) == `INST_BGEU) // bgeu
    begin
        branch_r      = 1'b1;
        branch_taken_r= (opcode_ra_operand_i >= opcode_rb_operand_i);
    end
end

reg        branch_taken_q;
reg        branch_ntaken_q;
reg [31:0] pc_x_q;
reg [31:0] pc_m_q;
reg        branch_call_q;
reg        branch_ret_q;
reg        branch_jmp_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    branch_taken_q   <= 1'b0;
    branch_ntaken_q  <= 1'b0;
    pc_x_q           <= 32'b0;
    pc_m_q           <= 32'b0;
    branch_call_q    <= 1'b0;
    branch_ret_q     <= 1'b0;
    branch_jmp_q     <= 1'b0;
end
else if (opcode_valid_i)
begin
    branch_taken_q   <= branch_r && opcode_valid_i & branch_taken_r;
    branch_ntaken_q  <= branch_r && opcode_valid_i & ~branch_taken_r;
    pc_x_q           <= branch_taken_r ? branch_target_r : opcode_pc_i + 32'd4;
    branch_call_q    <= branch_r && opcode_valid_i && branch_call_r;
    branch_ret_q     <= branch_r && opcode_valid_i && branch_ret_r;
    branch_jmp_q     <= branch_r && opcode_valid_i && branch_jmp_r;
    pc_m_q           <= opcode_pc_i;
end

assign branch_request_o   = branch_taken_q | branch_ntaken_q;
assign branch_is_taken_o  = branch_taken_q;
assign branch_is_not_taken_o = branch_ntaken_q;
assign branch_source_o    = pc_m_q;
assign branch_pc_o        = pc_x_q;
assign branch_is_call_o   = branch_call_q;
assign branch_is_ret_o    = branch_ret_q;
assign branch_is_jmp_o    = branch_jmp_q;

assign branch_d_request_o = (branch_r && opcode_valid_i && branch_taken_r);
assign branch_d_pc_o      = branch_target_r;
assign branch_d_priv_o    = 2'b0; // don't care



endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_fetch
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_MMU      = 1
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           fetch_accept_i
    ,input           icache_accept_i
    ,input           icache_valid_i
    ,input           icache_error_i
    ,input  [ 31:0]  icache_inst_i
    ,input           icache_page_fault_i
    ,input           fetch_invalidate_i
    ,input           branch_request_i
    ,input  [ 31:0]  branch_pc_i
    ,input  [  1:0]  branch_priv_i

    // Outputs
    ,output          fetch_valid_o
    ,output [ 31:0]  fetch_instr_o
    ,output [ 31:0]  fetch_pc_o
    ,output          fetch_fault_fetch_o
    ,output          fetch_fault_page_o
    ,output          icache_rd_o
    ,output          icache_flush_o
    ,output          icache_invalidate_o
    ,output [ 31:0]  icache_pc_o
    ,output [  1:0]  icache_priv_o
    ,output          squash_decode_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-------------------------------------------------------------
// Registers / Wires
//-------------------------------------------------------------
reg         active_q;

wire        icache_busy_w;
wire        stall_w       = !fetch_accept_i || icache_busy_w || !icache_accept_i;

//-------------------------------------------------------------
// Buffered branch
//-------------------------------------------------------------
reg         branch_q;
reg [31:0]  branch_pc_q;
reg [1:0]   branch_priv_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    branch_q       <= 1'b0;
    branch_pc_q    <= 32'b0;
    branch_priv_q  <= `PRIV_MACHINE;
end
else if (branch_request_i)
begin
    branch_q       <= 1'b1;
    branch_pc_q    <= branch_pc_i;
    branch_priv_q  <= branch_priv_i;
end
else if (icache_rd_o && icache_accept_i)
begin
    branch_q       <= 1'b0;
    branch_pc_q    <= 32'b0;
end

wire        branch_w      = branch_q;
wire [31:0] branch_pc_w   = branch_pc_q;
wire [1:0]  branch_priv_w = branch_priv_q;

assign squash_decode_o    = branch_request_i;

//-------------------------------------------------------------
// Active flag
//-------------------------------------------------------------
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    active_q    <= 1'b0;
else if (branch_w && ~stall_w)
    active_q    <= 1'b1;

//-------------------------------------------------------------
// Stall flag
//-------------------------------------------------------------
reg stall_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    stall_q    <= 1'b0;
else
    stall_q    <= stall_w;

//-------------------------------------------------------------
// Request tracking
//-------------------------------------------------------------
reg icache_fetch_q;
reg icache_invalidate_q;

// ICACHE fetch tracking
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    icache_fetch_q <= 1'b0;
else if (icache_rd_o && icache_accept_i)
    icache_fetch_q <= 1'b1;
else if (icache_valid_i)
    icache_fetch_q <= 1'b0;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    icache_invalidate_q <= 1'b0;
else if (icache_invalidate_o && !icache_accept_i)
    icache_invalidate_q <= 1'b1;
else
    icache_invalidate_q <= 1'b0;

//-------------------------------------------------------------
// PC
//-------------------------------------------------------------
reg [31:0]  pc_f_q;
reg [31:0]  pc_d_q;

wire [31:0] icache_pc_w;
wire [1:0]  icache_priv_w;
wire        fetch_resp_drop_w;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    pc_f_q  <= 32'b0;
// Branch request
else if (branch_w && ~stall_w)
    pc_f_q  <= branch_pc_w;
// NPC
else if (!stall_w)
    pc_f_q  <= {icache_pc_w[31:2],2'b0} + 32'd4;

reg [1:0] priv_f_q;
reg       branch_d_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    priv_f_q  <= `PRIV_MACHINE;
// Branch request
else if (branch_w && ~stall_w)
    priv_f_q  <= branch_priv_w;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    branch_d_q  <= 1'b0;
// Branch request
else if (branch_w && ~stall_w)
    branch_d_q  <= 1'b1;
// NPC
else if (!stall_w)
    branch_d_q  <= 1'b0;

assign icache_pc_w       = pc_f_q;
assign icache_priv_w     = priv_f_q;
assign fetch_resp_drop_w = branch_w | branch_d_q;

// Last fetch address
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    pc_d_q <= 32'b0;
else if (icache_rd_o && icache_accept_i)
    pc_d_q <= icache_pc_w;

//-------------------------------------------------------------
// Outputs
//-------------------------------------------------------------
assign icache_rd_o         = active_q & fetch_accept_i & !icache_busy_w;
assign icache_pc_o         = {icache_pc_w[31:2],2'b0};
assign icache_priv_o       = icache_priv_w;
assign icache_flush_o      = fetch_invalidate_i | icache_invalidate_q;
assign icache_invalidate_o = 1'b0;

assign icache_busy_w       =  icache_fetch_q && !icache_valid_i;

//-------------------------------------------------------------
// Response Buffer
//-------------------------------------------------------------
reg [65:0]  skid_buffer_q;
reg         skid_valid_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    skid_buffer_q  <= 66'b0;
    skid_valid_q   <= 1'b0;
end 
// Instruction output back-pressured - hold in skid buffer
else if (fetch_valid_o && !fetch_accept_i)
begin
    skid_valid_q  <= 1'b1;
    skid_buffer_q <= {fetch_fault_page_o, fetch_fault_fetch_o, fetch_pc_o, fetch_instr_o};
end
else
begin
    skid_valid_q  <= 1'b0;
    skid_buffer_q <= 66'b0;
end

assign fetch_valid_o       = (icache_valid_i || skid_valid_q) & !fetch_resp_drop_w;
assign fetch_pc_o          = skid_valid_q ? skid_buffer_q[63:32] : {pc_d_q[31:2],2'b0};
assign fetch_instr_o       = skid_valid_q ? skid_buffer_q[31:0]  : icache_inst_i;

// Faults
assign fetch_fault_fetch_o = skid_valid_q ? skid_buffer_q[64] : icache_error_i;
assign fetch_fault_page_o  = skid_valid_q ? skid_buffer_q[65] : icache_page_fault_i;



endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_issue
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_MULDIV   = 1
    ,parameter SUPPORT_DUAL_ISSUE = 1
    ,parameter SUPPORT_LOAD_BYPASS = 1
    ,parameter SUPPORT_MUL_BYPASS = 1
    ,parameter SUPPORT_REGFILE_XILINX = 0
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           fetch_valid_i
    ,input  [ 31:0]  fetch_instr_i
    ,input  [ 31:0]  fetch_pc_i
    ,input           fetch_fault_fetch_i
    ,input           fetch_fault_page_i
    ,input           fetch_instr_exec_i
    ,input           fetch_instr_lsu_i
    ,input           fetch_instr_branch_i
    ,input           fetch_instr_mul_i
    ,input           fetch_instr_div_i
    ,input           fetch_instr_csr_i
    ,input           fetch_instr_rd_valid_i
    ,input           fetch_instr_invalid_i
    ,input           branch_exec_request_i
    ,input           branch_exec_is_taken_i
    ,input           branch_exec_is_not_taken_i
    ,input  [ 31:0]  branch_exec_source_i
    ,input           branch_exec_is_call_i
    ,input           branch_exec_is_ret_i
    ,input           branch_exec_is_jmp_i
    ,input  [ 31:0]  branch_exec_pc_i
    ,input           branch_d_exec_request_i
    ,input  [ 31:0]  branch_d_exec_pc_i
    ,input  [  1:0]  branch_d_exec_priv_i
    ,input           branch_csr_request_i
    ,input  [ 31:0]  branch_csr_pc_i
    ,input  [  1:0]  branch_csr_priv_i
    ,input  [ 31:0]  writeback_exec_value_i
    ,input           writeback_mem_valid_i
    ,input  [ 31:0]  writeback_mem_value_i
    ,input  [  5:0]  writeback_mem_exception_i
    ,input  [ 31:0]  writeback_mul_value_i
    ,input           writeback_div_valid_i
    ,input  [ 31:0]  writeback_div_value_i
    ,input  [ 31:0]  csr_result_e1_value_i
    ,input           csr_result_e1_write_i
    ,input  [ 31:0]  csr_result_e1_wdata_i
    ,input  [  5:0]  csr_result_e1_exception_i
    ,input           lsu_stall_i
    ,input           take_interrupt_i

    // Outputs
    ,output          fetch_accept_o
    ,output          branch_request_o
    ,output [ 31:0]  branch_pc_o
    ,output [  1:0]  branch_priv_o
    ,output          exec_opcode_valid_o
    ,output          lsu_opcode_valid_o
    ,output          csr_opcode_valid_o
    ,output          mul_opcode_valid_o
    ,output          div_opcode_valid_o
    ,output [ 31:0]  opcode_opcode_o
    ,output [ 31:0]  opcode_pc_o
    ,output          opcode_invalid_o
    ,output [  4:0]  opcode_rd_idx_o
    ,output [  4:0]  opcode_ra_idx_o
    ,output [  4:0]  opcode_rb_idx_o
    ,output [ 31:0]  opcode_ra_operand_o
    ,output [ 31:0]  opcode_rb_operand_o
    ,output [ 31:0]  lsu_opcode_opcode_o
    ,output [ 31:0]  lsu_opcode_pc_o
    ,output          lsu_opcode_invalid_o
    ,output [  4:0]  lsu_opcode_rd_idx_o
    ,output [  4:0]  lsu_opcode_ra_idx_o
    ,output [  4:0]  lsu_opcode_rb_idx_o
    ,output [ 31:0]  lsu_opcode_ra_operand_o
    ,output [ 31:0]  lsu_opcode_rb_operand_o
    ,output [ 31:0]  mul_opcode_opcode_o
    ,output [ 31:0]  mul_opcode_pc_o
    ,output          mul_opcode_invalid_o
    ,output [  4:0]  mul_opcode_rd_idx_o
    ,output [  4:0]  mul_opcode_ra_idx_o
    ,output [  4:0]  mul_opcode_rb_idx_o
    ,output [ 31:0]  mul_opcode_ra_operand_o
    ,output [ 31:0]  mul_opcode_rb_operand_o
    ,output [ 31:0]  csr_opcode_opcode_o
    ,output [ 31:0]  csr_opcode_pc_o
    ,output          csr_opcode_invalid_o
    ,output [  4:0]  csr_opcode_rd_idx_o
    ,output [  4:0]  csr_opcode_ra_idx_o
    ,output [  4:0]  csr_opcode_rb_idx_o
    ,output [ 31:0]  csr_opcode_ra_operand_o
    ,output [ 31:0]  csr_opcode_rb_operand_o
    ,output          csr_writeback_write_o
    ,output [ 11:0]  csr_writeback_waddr_o
    ,output [ 31:0]  csr_writeback_wdata_o
    ,output [  5:0]  csr_writeback_exception_o
    ,output [ 31:0]  csr_writeback_exception_pc_o
    ,output [ 31:0]  csr_writeback_exception_addr_o
    ,output          exec_hold_o
    ,output          mul_hold_o
    ,output          interrupt_inhibit_o
);



`include "riscv_defs.v"

wire enable_muldiv_w     = SUPPORT_MULDIV;
wire enable_mul_bypass_w = SUPPORT_MUL_BYPASS;

wire stall_w;
wire squash_w;

//-------------------------------------------------------------
// Priv level
//-------------------------------------------------------------
reg [1:0] priv_x_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    priv_x_q <= `PRIV_MACHINE;
else if (branch_csr_request_i)
    priv_x_q <= branch_csr_priv_i;

//-------------------------------------------------------------
// Issue Select
//-------------------------------------------------------------
wire opcode_valid_w = fetch_valid_i & ~squash_w & ~branch_csr_request_i;

// Branch request (CSR branch - ecall, xret, or branch instruction)
assign branch_request_o     = branch_csr_request_i | branch_d_exec_request_i;
assign branch_pc_o          = branch_csr_request_i ? branch_csr_pc_i   : branch_d_exec_pc_i;
assign branch_priv_o        = branch_csr_request_i ? branch_csr_priv_i : priv_x_q;

//-------------------------------------------------------------
// Instruction Decoder
//-------------------------------------------------------------
wire [4:0] issue_ra_idx_w   = fetch_instr_i[19:15];
wire [4:0] issue_rb_idx_w   = fetch_instr_i[24:20];
wire [4:0] issue_rd_idx_w   = fetch_instr_i[11:7];
wire       issue_sb_alloc_w = fetch_instr_rd_valid_i;
wire       issue_exec_w     = fetch_instr_exec_i;
wire       issue_lsu_w      = fetch_instr_lsu_i;
wire       issue_branch_w   = fetch_instr_branch_i;
wire       issue_mul_w      = fetch_instr_mul_i;
wire       issue_div_w      = fetch_instr_div_i;
wire       issue_csr_w      = fetch_instr_csr_i;
wire       issue_invalid_w  = fetch_instr_invalid_i;

//-------------------------------------------------------------
// Pipeline status tracking
//------------------------------------------------------------- 
wire        pipe_squash_e1_e2_w;

reg         opcode_issue_r;
reg         opcode_accept_r;
wire        pipe_stall_raw_w;

wire        pipe_load_e1_w;
wire        pipe_store_e1_w;
wire        pipe_mul_e1_w;
wire        pipe_branch_e1_w;
wire [4:0]  pipe_rd_e1_w;

wire [31:0] pipe_pc_e1_w;
wire [31:0] pipe_opcode_e1_w;
wire [31:0] pipe_operand_ra_e1_w;
wire [31:0] pipe_operand_rb_e1_w;

wire        pipe_load_e2_w;
wire        pipe_mul_e2_w;
wire [4:0]  pipe_rd_e2_w;
wire [31:0] pipe_result_e2_w;

wire        pipe_valid_wb_w;
wire        pipe_csr_wb_w;
wire [4:0]  pipe_rd_wb_w;
wire [31:0] pipe_result_wb_w;
wire [31:0] pipe_pc_wb_w;
wire [31:0] pipe_opc_wb_w;
wire [31:0] pipe_ra_val_wb_w;
wire [31:0] pipe_rb_val_wb_w;
wire [`EXCEPTION_W-1:0] pipe_exception_wb_w;

wire [`EXCEPTION_W-1:0] issue_fault_w = fetch_fault_fetch_i ? `EXCEPTION_FAULT_FETCH:
                                        fetch_fault_page_i  ? `EXCEPTION_PAGE_FAULT_INST: `EXCEPTION_W'b0;

riscv_pipe_ctrl
#( 
     .SUPPORT_LOAD_BYPASS(SUPPORT_LOAD_BYPASS)
    ,.SUPPORT_MUL_BYPASS(SUPPORT_MUL_BYPASS)
)
u_pipe_ctrl
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)    

    // Issue
    ,.issue_valid_i(opcode_issue_r)
    ,.issue_accept_i(opcode_accept_r)
    ,.issue_stall_i(stall_w)
    ,.issue_lsu_i(issue_lsu_w)
    ,.issue_csr_i(issue_csr_w)
    ,.issue_div_i(issue_div_w)
    ,.issue_mul_i(issue_mul_w)
    ,.issue_branch_i(issue_branch_w)
    ,.issue_rd_valid_i(issue_sb_alloc_w)
    ,.issue_rd_i(issue_rd_idx_w)
    ,.issue_exception_i(issue_fault_w)
    ,.issue_pc_i(opcode_pc_o)
    ,.issue_opcode_i(opcode_opcode_o)
    ,.issue_operand_ra_i(opcode_ra_operand_o)
    ,.issue_operand_rb_i(opcode_rb_operand_o)
    ,.issue_branch_taken_i(branch_d_exec_request_i)
    ,.issue_branch_target_i(branch_d_exec_pc_i)
    ,.take_interrupt_i(take_interrupt_i)

    // Execution stage 1: ALU result
    ,.alu_result_e1_i(writeback_exec_value_i)
    ,.csr_result_value_e1_i(csr_result_e1_value_i)
    ,.csr_result_write_e1_i(csr_result_e1_write_i)
    ,.csr_result_wdata_e1_i(csr_result_e1_wdata_i)
    ,.csr_result_exception_e1_i(csr_result_e1_exception_i)

    // Execution stage 1
    ,.load_e1_o(pipe_load_e1_w)
    ,.store_e1_o(pipe_store_e1_w)
    ,.mul_e1_o(pipe_mul_e1_w)
    ,.branch_e1_o(pipe_branch_e1_w)
    ,.rd_e1_o(pipe_rd_e1_w)
    ,.pc_e1_o(pipe_pc_e1_w)
    ,.opcode_e1_o(pipe_opcode_e1_w)
    ,.operand_ra_e1_o(pipe_operand_ra_e1_w)
    ,.operand_rb_e1_o(pipe_operand_rb_e1_w)

    // Execution stage 2: Other results
    ,.mem_complete_i(writeback_mem_valid_i)
    ,.mem_result_e2_i(writeback_mem_value_i)
    ,.mem_exception_e2_i(writeback_mem_exception_i)
    ,.mul_result_e2_i(writeback_mul_value_i)

    // Execution stage 2
    ,.load_e2_o(pipe_load_e2_w)
    ,.mul_e2_o(pipe_mul_e2_w)
    ,.rd_e2_o(pipe_rd_e2_w)
    ,.result_e2_o(pipe_result_e2_w)

    ,.stall_o(pipe_stall_raw_w)
    ,.squash_e1_e2_o(pipe_squash_e1_e2_w)
    ,.squash_e1_e2_i(1'b0)
    ,.squash_wb_i(1'b0)

    // Out of pipe: Divide Result
    ,.div_complete_i(writeback_div_valid_i)
    ,.div_result_i(writeback_div_value_i)

    // Commit
    ,.valid_wb_o(pipe_valid_wb_w)
    ,.csr_wb_o(pipe_csr_wb_w)
    ,.rd_wb_o(pipe_rd_wb_w)
    ,.result_wb_o(pipe_result_wb_w)
    ,.pc_wb_o(pipe_pc_wb_w)
    ,.opcode_wb_o(pipe_opc_wb_w)
    ,.operand_ra_wb_o(pipe_ra_val_wb_w)
    ,.operand_rb_wb_o(pipe_rb_val_wb_w)
    ,.exception_wb_o(pipe_exception_wb_w)
    ,.csr_write_wb_o(csr_writeback_write_o)
    ,.csr_waddr_wb_o(csr_writeback_waddr_o)
    ,.csr_wdata_wb_o(csr_writeback_wdata_o)   
);

assign exec_hold_o = stall_w;
assign mul_hold_o  = stall_w;

//-------------------------------------------------------------
// Pipe1 - Status tracking
//-------------------------------------------------------------
assign csr_writeback_exception_o      = pipe_exception_wb_w;
assign csr_writeback_exception_pc_o   = pipe_pc_wb_w;
assign csr_writeback_exception_addr_o = pipe_result_wb_w;

//-------------------------------------------------------------
// Blocking events (division, CSR unit access)
//-------------------------------------------------------------
reg div_pending_q;
reg csr_pending_q;

// Division operations take 2 - 34 cycles and stall
// the pipeline (complete out-of-pipe) until completed.
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    div_pending_q <= 1'b0;
else if (pipe_squash_e1_e2_w)
    div_pending_q <= 1'b0;
else if (div_opcode_valid_o && issue_div_w)
    div_pending_q <= 1'b1;
else if (writeback_div_valid_i)
    div_pending_q <= 1'b0;

// CSR operations are infrequent - avoid any complications of pipelining them.
// These only take a 2-3 cycles anyway and may result in a pipe flush (e.g. ecall, ebreak..).
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    csr_pending_q <= 1'b0;
else if (pipe_squash_e1_e2_w)
    csr_pending_q <= 1'b0;
else if (csr_opcode_valid_o && issue_csr_w)
    csr_pending_q <= 1'b1;
else if (pipe_csr_wb_w)
    csr_pending_q <= 1'b0;

assign squash_w = pipe_squash_e1_e2_w;

//-------------------------------------------------------------
// Issue / scheduling logic
//-------------------------------------------------------------
reg [31:0] scoreboard_r;

always @ *
begin
    opcode_issue_r     = 1'b0;
    opcode_accept_r    = 1'b0;
    scoreboard_r       = 32'b0;

    // Execution units with >= 2 cycle latency
    if (SUPPORT_LOAD_BYPASS == 0)
    begin
        if (pipe_load_e2_w)
            scoreboard_r[pipe_rd_e2_w] = 1'b1;
    end
    if (SUPPORT_MUL_BYPASS == 0)
    begin
        if (pipe_mul_e2_w)
            scoreboard_r[pipe_rd_e2_w] = 1'b1;
    end

    // Execution units with >= 1 cycle latency (loads / multiply)
    if (pipe_load_e1_w || pipe_mul_e1_w)
        scoreboard_r[pipe_rd_e1_w] = 1'b1;

    // Do not start multiply, division or CSR operation in the cycle after a load (leaving only ALU operations and branches)
    if ((pipe_load_e1_w || pipe_store_e1_w) && (issue_mul_w || issue_div_w || issue_csr_w))
        scoreboard_r = 32'hFFFFFFFF;

    // Stall - no issues...
    if (lsu_stall_i || stall_w || div_pending_q || csr_pending_q)
        ;
    // Primary slot (lsu, branch, alu, mul, div, csr)
    else if (opcode_valid_w &&
        !(scoreboard_r[issue_ra_idx_w] || 
          scoreboard_r[issue_rb_idx_w] ||
          scoreboard_r[issue_rd_idx_w]))
    begin
        opcode_issue_r  = 1'b1;
        opcode_accept_r = 1'b1;

        if (opcode_accept_r && issue_sb_alloc_w && (|issue_rd_idx_w))
            scoreboard_r[issue_rd_idx_w] = 1'b1;
    end 
end

assign lsu_opcode_valid_o   = opcode_issue_r & ~take_interrupt_i;
assign exec_opcode_valid_o  = opcode_issue_r;
assign mul_opcode_valid_o   = enable_muldiv_w & opcode_issue_r;
assign div_opcode_valid_o   = enable_muldiv_w & opcode_issue_r;
assign interrupt_inhibit_o  = csr_pending_q || issue_csr_w;

assign fetch_accept_o       = opcode_valid_w ? (opcode_accept_r & ~take_interrupt_i) : 1'b1;

assign stall_w              = pipe_stall_raw_w;

//-------------------------------------------------------------
// Register File
//------------------------------------------------------------- 
wire [31:0] issue_ra_value_w;
wire [31:0] issue_rb_value_w;
wire [31:0] issue_b_ra_value_w;
wire [31:0] issue_b_rb_value_w;

// Register file: 1W2R
riscv_regfile
#(
     .SUPPORT_REGFILE_XILINX(SUPPORT_REGFILE_XILINX)
)
u_regfile
(
    .clk_i(clk_i),
    .rst_i(rst_i),

    // Write ports
    .rd0_i(pipe_rd_wb_w),
    .rd0_value_i(pipe_result_wb_w),

    // Read ports
    .ra0_i(issue_ra_idx_w),
    .rb0_i(issue_rb_idx_w),
    .ra0_value_o(issue_ra_value_w),
    .rb0_value_o(issue_rb_value_w)
);

//-------------------------------------------------------------
// Issue Slot 0
//------------------------------------------------------------- 
assign opcode_opcode_o = fetch_instr_i;
assign opcode_pc_o     = fetch_pc_i;
assign opcode_rd_idx_o = issue_rd_idx_w;
assign opcode_ra_idx_o = issue_ra_idx_w;
assign opcode_rb_idx_o = issue_rb_idx_w;
assign opcode_invalid_o= 1'b0; 

reg [31:0] issue_ra_value_r;
reg [31:0] issue_rb_value_r;

always @ *
begin
    // NOTE: Newest version of operand takes priority
    issue_ra_value_r = issue_ra_value_w;
    issue_rb_value_r = issue_rb_value_w;

    // Bypass - WB
    if (pipe_rd_wb_w == issue_ra_idx_w)
        issue_ra_value_r = pipe_result_wb_w;
    if (pipe_rd_wb_w == issue_rb_idx_w)
        issue_rb_value_r = pipe_result_wb_w;

    // Bypass - E2
    if (pipe_rd_e2_w == issue_ra_idx_w)
        issue_ra_value_r = pipe_result_e2_w;
    if (pipe_rd_e2_w == issue_rb_idx_w)
        issue_rb_value_r = pipe_result_e2_w;

    // Bypass - E1
    if (pipe_rd_e1_w == issue_ra_idx_w)
        issue_ra_value_r = writeback_exec_value_i;
    if (pipe_rd_e1_w == issue_rb_idx_w)
        issue_rb_value_r = writeback_exec_value_i;

    // Reg 0 source
    if (issue_ra_idx_w == 5'b0)
        issue_ra_value_r = 32'b0;
    if (issue_rb_idx_w == 5'b0)
        issue_rb_value_r = 32'b0;
end

assign opcode_ra_operand_o = issue_ra_value_r;
assign opcode_rb_operand_o = issue_rb_value_r;

//-------------------------------------------------------------
// Load store unit
//-------------------------------------------------------------
assign lsu_opcode_opcode_o      = opcode_opcode_o;
assign lsu_opcode_pc_o          = opcode_pc_o;
assign lsu_opcode_rd_idx_o      = opcode_rd_idx_o;
assign lsu_opcode_ra_idx_o      = opcode_ra_idx_o;
assign lsu_opcode_rb_idx_o      = opcode_rb_idx_o;
assign lsu_opcode_ra_operand_o  = opcode_ra_operand_o;
assign lsu_opcode_rb_operand_o  = opcode_rb_operand_o;
assign lsu_opcode_invalid_o     = 1'b0;

//-------------------------------------------------------------
// Multiply
//-------------------------------------------------------------
assign mul_opcode_opcode_o      = opcode_opcode_o;
assign mul_opcode_pc_o          = opcode_pc_o;
assign mul_opcode_rd_idx_o      = opcode_rd_idx_o;
assign mul_opcode_ra_idx_o      = opcode_ra_idx_o;
assign mul_opcode_rb_idx_o      = opcode_rb_idx_o;
assign mul_opcode_ra_operand_o  = opcode_ra_operand_o;
assign mul_opcode_rb_operand_o  = opcode_rb_operand_o;
assign mul_opcode_invalid_o     = 1'b0;

//-------------------------------------------------------------
// CSR unit
//-------------------------------------------------------------
assign csr_opcode_valid_o       = opcode_issue_r & ~take_interrupt_i;
assign csr_opcode_opcode_o      = opcode_opcode_o;
assign csr_opcode_pc_o          = opcode_pc_o;
assign csr_opcode_rd_idx_o      = opcode_rd_idx_o;
assign csr_opcode_ra_idx_o      = opcode_ra_idx_o;
assign csr_opcode_rb_idx_o      = opcode_rb_idx_o;
assign csr_opcode_ra_operand_o  = opcode_ra_operand_o;
assign csr_opcode_rb_operand_o  = opcode_rb_operand_o;
assign csr_opcode_invalid_o     = opcode_issue_r && issue_invalid_w;


//-------------------------------------------------------------
// Checker Interface
//-------------------------------------------------------------
`ifdef verilator
riscv_trace_sim
u_pipe_dec0_verif
(
     .valid_i(pipe_valid_wb_w)
    ,.pc_i(pipe_pc_wb_w)
    ,.opcode_i(pipe_opc_wb_w)
);

wire [4:0] v_pipe_rs1_w = pipe_opc_wb_w[19:15];
wire [4:0] v_pipe_rs2_w = pipe_opc_wb_w[24:20];

function [0:0] complete_valid0; /*verilator public*/
begin
    complete_valid0 = pipe_valid_wb_w;
end
endfunction
function [31:0] complete_pc0; /*verilator public*/
begin
    complete_pc0 = pipe_pc_wb_w;
end
endfunction
function [31:0] complete_opcode0; /*verilator public*/
begin
    complete_opcode0 = pipe_opc_wb_w;
end
endfunction
function [4:0] complete_ra0; /*verilator public*/
begin
    complete_ra0 = v_pipe_rs1_w;
end
endfunction
function [4:0] complete_rb0; /*verilator public*/
begin
    complete_rb0 = v_pipe_rs2_w;
end
endfunction
function [4:0] complete_rd0; /*verilator public*/
begin
    complete_rd0 = pipe_rd_wb_w;
end
endfunction
function [31:0] complete_ra_val0; /*verilator public*/
begin
    complete_ra_val0 = pipe_ra_val_wb_w;
end
endfunction
function [31:0] complete_rb_val0; /*verilator public*/
begin
    complete_rb_val0 = pipe_rb_val_wb_w;
end
endfunction
function [31:0] complete_rd_val0; /*verilator public*/
begin
    if (|pipe_rd_wb_w)
        complete_rd_val0 = pipe_result_wb_w;
    else
        complete_rd_val0 = 32'b0;
end
endfunction
function [5:0] complete_exception; /*verilator public*/
begin
    complete_exception = pipe_exception_wb_w;
end
endfunction
`endif


endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_lsu
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter MEM_CACHE_ADDR_MIN = 32'h80000000
    ,parameter MEM_CACHE_ADDR_MAX = 32'h8fffffff
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           opcode_valid_i
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_pc_i
    ,input           opcode_invalid_i
    ,input  [  4:0]  opcode_rd_idx_i
    ,input  [  4:0]  opcode_ra_idx_i
    ,input  [  4:0]  opcode_rb_idx_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i
    ,input  [ 31:0]  mem_data_rd_i
    ,input           mem_accept_i
    ,input           mem_ack_i
    ,input           mem_error_i
    ,input  [ 10:0]  mem_resp_tag_i
    ,input           mem_load_fault_i
    ,input           mem_store_fault_i

    // Outputs
    ,output [ 31:0]  mem_addr_o
    ,output [ 31:0]  mem_data_wr_o
    ,output          mem_rd_o
    ,output [  3:0]  mem_wr_o
    ,output          mem_cacheable_o
    ,output [ 10:0]  mem_req_tag_o
    ,output          mem_invalidate_o
    ,output          mem_writeback_o
    ,output          mem_flush_o
    ,output          writeback_valid_o
    ,output [ 31:0]  writeback_value_o
    ,output [  5:0]  writeback_exception_o
    ,output          stall_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
reg [ 31:0]  mem_addr_q;
reg [ 31:0]  mem_data_wr_q;
reg          mem_rd_q;
reg [  3:0]  mem_wr_q;
reg          mem_cacheable_q;
reg          mem_invalidate_q;
reg          mem_writeback_q;
reg          mem_flush_q;
reg          mem_unaligned_e1_q;
reg          mem_unaligned_e2_q;

reg          mem_load_q;
reg          mem_xb_q;
reg          mem_xh_q;
reg          mem_ls_q;

//-----------------------------------------------------------------
// Outstanding Access Tracking
//-----------------------------------------------------------------
reg pending_lsu_e2_q;

wire issue_lsu_e1_w    = (mem_rd_o || (|mem_wr_o) || mem_writeback_o || mem_invalidate_o || mem_flush_o) && mem_accept_i;
wire complete_ok_e2_w  = mem_ack_i & ~mem_error_i;
wire complete_err_e2_w = mem_ack_i & mem_error_i;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    pending_lsu_e2_q <= 1'b0;
else if (issue_lsu_e1_w)
    pending_lsu_e2_q <= 1'b1;
else if (complete_ok_e2_w || complete_err_e2_w)
    pending_lsu_e2_q <= 1'b0;

// Delay next instruction if outstanding response is late
wire delay_lsu_e2_w = pending_lsu_e2_q && !complete_ok_e2_w;

//-----------------------------------------------------------------
// Dummy Ack (unaligned access /E2)
//-----------------------------------------------------------------
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    mem_unaligned_e2_q <= 1'b0;
else
    mem_unaligned_e2_q <= mem_unaligned_e1_q & ~delay_lsu_e2_w;

//-----------------------------------------------------------------
// Opcode decode
//-----------------------------------------------------------------

wire load_inst_w = (((opcode_opcode_i & `INST_LB_MASK) == `INST_LB)  || 
                    ((opcode_opcode_i & `INST_LH_MASK) == `INST_LH)  || 
                    ((opcode_opcode_i & `INST_LW_MASK) == `INST_LW)  || 
                    ((opcode_opcode_i & `INST_LBU_MASK) == `INST_LBU) || 
                    ((opcode_opcode_i & `INST_LHU_MASK) == `INST_LHU) || 
                    ((opcode_opcode_i & `INST_LWU_MASK) == `INST_LWU));

wire load_signed_inst_w = (((opcode_opcode_i & `INST_LB_MASK) == `INST_LB)  || 
                           ((opcode_opcode_i & `INST_LH_MASK) == `INST_LH)  || 
                           ((opcode_opcode_i & `INST_LW_MASK) == `INST_LW));

wire store_inst_w = (((opcode_opcode_i & `INST_SB_MASK) == `INST_SB)  || 
                     ((opcode_opcode_i & `INST_SH_MASK) == `INST_SH)  || 
                     ((opcode_opcode_i & `INST_SW_MASK) == `INST_SW));

wire req_lb_w = ((opcode_opcode_i & `INST_LB_MASK) == `INST_LB) || ((opcode_opcode_i & `INST_LBU_MASK) == `INST_LBU);
wire req_lh_w = ((opcode_opcode_i & `INST_LH_MASK) == `INST_LH) || ((opcode_opcode_i & `INST_LHU_MASK) == `INST_LHU);
wire req_lw_w = ((opcode_opcode_i & `INST_LW_MASK) == `INST_LW) || ((opcode_opcode_i & `INST_LWU_MASK) == `INST_LWU);
wire req_sb_w = ((opcode_opcode_i & `INST_LB_MASK) == `INST_SB);
wire req_sh_w = ((opcode_opcode_i & `INST_LH_MASK) == `INST_SH);
wire req_sw_w = ((opcode_opcode_i & `INST_LW_MASK) == `INST_SW);

wire req_sw_lw_w = ((opcode_opcode_i & `INST_SW_MASK) == `INST_SW) || ((opcode_opcode_i & `INST_LW_MASK) == `INST_LW) || ((opcode_opcode_i & `INST_LWU_MASK) == `INST_LWU);
wire req_sh_lh_w = ((opcode_opcode_i & `INST_SH_MASK) == `INST_SH) || ((opcode_opcode_i & `INST_LH_MASK) == `INST_LH) || ((opcode_opcode_i & `INST_LHU_MASK) == `INST_LHU);

reg [31:0]  mem_addr_r;
reg         mem_unaligned_r;
reg [31:0]  mem_data_r;
reg         mem_rd_r;
reg [3:0]   mem_wr_r;

always @ *
begin
    mem_addr_r      = 32'b0;
    mem_data_r      = 32'b0;
    mem_unaligned_r = 1'b0;
    mem_wr_r        = 4'b0;
    mem_rd_r        = 1'b0;

    if (opcode_valid_i && ((opcode_opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW))
        mem_addr_r = opcode_ra_operand_i;
    else if (opcode_valid_i && load_inst_w)
        mem_addr_r = opcode_ra_operand_i + {{20{opcode_opcode_i[31]}}, opcode_opcode_i[31:20]};
    else
        mem_addr_r = opcode_ra_operand_i + {{20{opcode_opcode_i[31]}}, opcode_opcode_i[31:25], opcode_opcode_i[11:7]};

    if (opcode_valid_i && req_sw_lw_w)
        mem_unaligned_r = (mem_addr_r[1:0] != 2'b0);
    else if (opcode_valid_i && req_sh_lh_w)
        mem_unaligned_r = mem_addr_r[0];

    mem_rd_r = (opcode_valid_i && load_inst_w && !mem_unaligned_r);

    if (opcode_valid_i && ((opcode_opcode_i & `INST_SW_MASK) == `INST_SW) && !mem_unaligned_r)
    begin
        mem_data_r  = opcode_rb_operand_i;
        mem_wr_r    = 4'hF;
    end
    else if (opcode_valid_i && ((opcode_opcode_i & `INST_SH_MASK) == `INST_SH) && !mem_unaligned_r)
    begin
        case (mem_addr_r[1:0])
        2'h2 :
        begin
            mem_data_r  = {opcode_rb_operand_i[15:0],16'h0000};
            mem_wr_r    = 4'b1100;
        end
        default :
        begin
            mem_data_r  = {16'h0000,opcode_rb_operand_i[15:0]};
            mem_wr_r    = 4'b0011;
        end
        endcase
    end
    else if (opcode_valid_i && ((opcode_opcode_i & `INST_SB_MASK) == `INST_SB))
    begin
        case (mem_addr_r[1:0])
        2'h3 :
        begin
            mem_data_r  = {opcode_rb_operand_i[7:0],24'h000000};
            mem_wr_r    = 4'b1000;
        end
        2'h2 :
        begin
            mem_data_r  = {{8'h00,opcode_rb_operand_i[7:0]},16'h0000};
            mem_wr_r    = 4'b0100;
        end
        2'h1 :
        begin
            mem_data_r  = {{16'h0000,opcode_rb_operand_i[7:0]},8'h00};
            mem_wr_r    = 4'b0010;
        end
        2'h0 :
        begin
            mem_data_r  = {24'h000000,opcode_rb_operand_i[7:0]};
            mem_wr_r    = 4'b0001;
        end
        default :
        ;
        endcase
    end
    else
        mem_wr_r    = 4'b0;
end

wire dcache_flush_w      = ((opcode_opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW) && (opcode_opcode_i[31:20] == `CSR_DFLUSH);
wire dcache_writeback_w  = ((opcode_opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW) && (opcode_opcode_i[31:20] == `CSR_DWRITEBACK);
wire dcache_invalidate_w = ((opcode_opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW) && (opcode_opcode_i[31:20] == `CSR_DINVALIDATE);

//-----------------------------------------------------------------
// Sequential
//-----------------------------------------------------------------

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    mem_addr_q         <= 32'b0;
    mem_data_wr_q      <= 32'b0;
    mem_rd_q           <= 1'b0;
    mem_wr_q           <= 4'b0;
    mem_cacheable_q    <= 1'b0;
    mem_invalidate_q   <= 1'b0;
    mem_writeback_q    <= 1'b0;
    mem_flush_q        <= 1'b0;
    mem_unaligned_e1_q <= 1'b0;
    mem_load_q         <= 1'b0;
    mem_xb_q           <= 1'b0;
    mem_xh_q           <= 1'b0;
    mem_ls_q           <= 1'b0;
end
// Memory access fault - squash next operation (exception coming...)
else if (complete_err_e2_w || mem_unaligned_e2_q)
begin
    mem_addr_q         <= 32'b0;
    mem_data_wr_q      <= 32'b0;
    mem_rd_q           <= 1'b0;
    mem_wr_q           <= 4'b0;
    mem_cacheable_q    <= 1'b0;
    mem_invalidate_q   <= 1'b0;
    mem_writeback_q    <= 1'b0;
    mem_flush_q        <= 1'b0;
    mem_unaligned_e1_q <= 1'b0;
    mem_load_q         <= 1'b0;
    mem_xb_q           <= 1'b0;
    mem_xh_q           <= 1'b0;
    mem_ls_q           <= 1'b0;
end
else if ((mem_rd_q || (|mem_wr_q) || mem_unaligned_e1_q) && delay_lsu_e2_w)
    ;
else if (!((mem_writeback_o || mem_invalidate_o || mem_flush_o || mem_rd_o || mem_wr_o != 4'b0) && !mem_accept_i))
begin
    mem_addr_q         <= 32'b0;
    mem_data_wr_q      <= mem_data_r;
    mem_rd_q           <= mem_rd_r;
    mem_wr_q           <= mem_wr_r;
    mem_cacheable_q    <= 1'b0;
    mem_invalidate_q   <= 1'b0;
    mem_writeback_q    <= 1'b0;
    mem_flush_q        <= 1'b0;
    mem_unaligned_e1_q <= mem_unaligned_r;
    mem_load_q         <= opcode_valid_i && load_inst_w;
    mem_xb_q           <= req_lb_w | req_sb_w;
    mem_xh_q           <= req_lh_w | req_sh_w;
    mem_ls_q           <= load_signed_inst_w;

/* verilator lint_off UNSIGNED */
/* verilator lint_off CMPCONST */
    mem_cacheable_q  <= (mem_addr_r >= MEM_CACHE_ADDR_MIN && mem_addr_r <= MEM_CACHE_ADDR_MAX) ||
                        (opcode_valid_i && (dcache_invalidate_w || dcache_writeback_w || dcache_flush_w));
/* verilator lint_on CMPCONST */
/* verilator lint_on UNSIGNED */

    mem_invalidate_q <= opcode_valid_i & dcache_invalidate_w;
    mem_writeback_q  <= opcode_valid_i & dcache_writeback_w;
    mem_flush_q      <= opcode_valid_i & dcache_flush_w;
    mem_addr_q       <= mem_addr_r;
end

assign mem_addr_o       = {mem_addr_q[31:2], 2'b0};
assign mem_data_wr_o    = mem_data_wr_q;
assign mem_rd_o         = mem_rd_q & ~delay_lsu_e2_w;
assign mem_wr_o         = mem_wr_q & ~{4{delay_lsu_e2_w}};
assign mem_cacheable_o  = mem_cacheable_q;
assign mem_req_tag_o    = 11'b0;
assign mem_invalidate_o = mem_invalidate_q;
assign mem_writeback_o  = mem_writeback_q;
assign mem_flush_o      = mem_flush_q;

// Stall upstream if cache is busy
assign stall_o          = ((mem_writeback_o || mem_invalidate_o || mem_flush_o || mem_rd_o || mem_wr_o != 4'b0) && !mem_accept_i) || delay_lsu_e2_w || mem_unaligned_e1_q;

wire        resp_load_w;
wire [31:0] resp_addr_w;
wire        resp_byte_w;
wire        resp_half_w;
wire        resp_signed_w;

riscv_lsu_fifo
#(
     .WIDTH(36)
    ,.DEPTH(2)
    ,.ADDR_W(1)
)
u_lsu_request
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.push_i(((mem_rd_o || (|mem_wr_o) || mem_writeback_o || mem_invalidate_o || mem_flush_o) && mem_accept_i) || (mem_unaligned_e1_q && ~delay_lsu_e2_w))
    ,.data_in_i({mem_addr_q, mem_ls_q, mem_xh_q, mem_xb_q, mem_load_q})
    ,.accept_o()

    ,.valid_o()
    ,.data_out_o({resp_addr_w, resp_signed_w, resp_half_w, resp_byte_w, resp_load_w})
    ,.pop_i(mem_ack_i || mem_unaligned_e2_q)
);

//-----------------------------------------------------------------
// Load response
//-----------------------------------------------------------------
reg [1:0]  addr_lsb_r;
reg        load_byte_r;
reg        load_half_r;
reg        load_signed_r;
reg [31:0] wb_result_r;

always @ *
begin
    wb_result_r   = 32'b0;

    // Tag associated with load
    addr_lsb_r    = resp_addr_w[1:0];
    load_byte_r   = resp_byte_w;
    load_half_r   = resp_half_w;
    load_signed_r = resp_signed_w;

    // Access fault - pass badaddr on writeback result bus
    if ((mem_ack_i && mem_error_i) || mem_unaligned_e2_q)
        wb_result_r = resp_addr_w;
    // Handle responses
    else if (mem_ack_i && resp_load_w)
    begin
        if (load_byte_r)
        begin
            case (addr_lsb_r[1:0])
            2'h3: wb_result_r = {24'b0, mem_data_rd_i[31:24]};
            2'h2: wb_result_r = {24'b0, mem_data_rd_i[23:16]};
            2'h1: wb_result_r = {24'b0, mem_data_rd_i[15:8]};
            2'h0: wb_result_r = {24'b0, mem_data_rd_i[7:0]};
            endcase

            if (load_signed_r && wb_result_r[7])
                wb_result_r = {24'hFFFFFF, wb_result_r[7:0]};
        end
        else if (load_half_r)
        begin
            if (addr_lsb_r[1])
                wb_result_r = {16'b0, mem_data_rd_i[31:16]};
            else
                wb_result_r = {16'b0, mem_data_rd_i[15:0]};

            if (load_signed_r && wb_result_r[15])
                wb_result_r = {16'hFFFF, wb_result_r[15:0]};
        end
        else
            wb_result_r = mem_data_rd_i;
    end
end

assign writeback_valid_o    = mem_ack_i | mem_unaligned_e2_q;
assign writeback_value_o    = wb_result_r;

wire fault_load_align_w     = mem_unaligned_e2_q & resp_load_w;
wire fault_store_align_w    = mem_unaligned_e2_q & ~resp_load_w;
wire fault_load_bus_w       = mem_error_i &&  resp_load_w;
wire fault_store_bus_w      = mem_error_i && ~resp_load_w;
wire fault_load_page_w      = mem_error_i && mem_load_fault_i;
wire fault_store_page_w     = mem_error_i && mem_store_fault_i;


assign writeback_exception_o         = fault_load_align_w  ? `EXCEPTION_MISALIGNED_LOAD:
                                       fault_store_align_w ? `EXCEPTION_MISALIGNED_STORE:
                                       fault_load_page_w   ? `EXCEPTION_PAGE_FAULT_LOAD:
                                       fault_store_page_w  ? `EXCEPTION_PAGE_FAULT_STORE:
                                       fault_load_bus_w    ? `EXCEPTION_FAULT_LOAD:
                                       fault_store_bus_w   ? `EXCEPTION_FAULT_STORE:
                                       `EXCEPTION_W'b0;

endmodule 

module riscv_lsu_fifo
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
    parameter WIDTH   = 8,
    parameter DEPTH   = 4,
    parameter ADDR_W  = 2
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input               clk_i
    ,input               rst_i
    ,input  [WIDTH-1:0]  data_in_i
    ,input               push_i
    ,input               pop_i

    // Outputs
    ,output [WIDTH-1:0]  data_out_o
    ,output              accept_o
    ,output              valid_o
);

//-----------------------------------------------------------------
// Local Params
//-----------------------------------------------------------------
localparam COUNT_W = ADDR_W + 1;

//-----------------------------------------------------------------
// Registers
//-----------------------------------------------------------------
reg [WIDTH-1:0]   ram_q[DEPTH-1:0];
reg [ADDR_W-1:0]  rd_ptr_q;
reg [ADDR_W-1:0]  wr_ptr_q;
reg [COUNT_W-1:0] count_q;

integer i;

//-----------------------------------------------------------------
// Sequential
//-----------------------------------------------------------------
always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    count_q   <= {(COUNT_W) {1'b0}};
    rd_ptr_q  <= {(ADDR_W) {1'b0}};
    wr_ptr_q  <= {(ADDR_W) {1'b0}};

    for (i=0;i<DEPTH;i=i+1)
    begin
        ram_q[i] <= {(WIDTH) {1'b0}};
    end
end
else
begin
    // Push
    if (push_i & accept_o)
    begin
        ram_q[wr_ptr_q] <= data_in_i;
        wr_ptr_q        <= wr_ptr_q + 1;
    end

    // Pop
    if (pop_i & valid_o)
        rd_ptr_q      <= rd_ptr_q + 1;

    // Count up
    if ((push_i & accept_o) & ~(pop_i & valid_o))
        count_q <= count_q + 1;
    // Count down
    else if (~(push_i & accept_o) & (pop_i & valid_o))
        count_q <= count_q - 1;
end

//-------------------------------------------------------------------
// Combinatorial
//-------------------------------------------------------------------
/* verilator lint_off WIDTH */
assign valid_o       = (count_q != 0);
assign accept_o      = (count_q != DEPTH);
/* verilator lint_on WIDTH */

assign data_out_o    = ram_q[rd_ptr_q];



endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_mmu
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter MEM_CACHE_ADDR_MIN = 32'h80000000
    ,parameter MEM_CACHE_ADDR_MAX = 32'h8fffffff
    ,parameter SUPPORT_MMU      = 1
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [  1:0]  priv_d_i
    ,input           sum_i
    ,input           mxr_i
    ,input           flush_i
    ,input  [ 31:0]  satp_i
    ,input           fetch_in_rd_i
    ,input           fetch_in_flush_i
    ,input           fetch_in_invalidate_i
    ,input  [ 31:0]  fetch_in_pc_i
    ,input  [  1:0]  fetch_in_priv_i
    ,input           fetch_out_accept_i
    ,input           fetch_out_valid_i
    ,input           fetch_out_error_i
    ,input  [ 31:0]  fetch_out_inst_i
    ,input  [ 31:0]  lsu_in_addr_i
    ,input  [ 31:0]  lsu_in_data_wr_i
    ,input           lsu_in_rd_i
    ,input  [  3:0]  lsu_in_wr_i
    ,input           lsu_in_cacheable_i
    ,input  [ 10:0]  lsu_in_req_tag_i
    ,input           lsu_in_invalidate_i
    ,input           lsu_in_writeback_i
    ,input           lsu_in_flush_i
    ,input  [ 31:0]  lsu_out_data_rd_i
    ,input           lsu_out_accept_i
    ,input           lsu_out_ack_i
    ,input           lsu_out_error_i
    ,input  [ 10:0]  lsu_out_resp_tag_i

    // Outputs
    ,output          fetch_in_accept_o
    ,output          fetch_in_valid_o
    ,output          fetch_in_error_o
    ,output [ 31:0]  fetch_in_inst_o
    ,output          fetch_out_rd_o
    ,output          fetch_out_flush_o
    ,output          fetch_out_invalidate_o
    ,output [ 31:0]  fetch_out_pc_o
    ,output          fetch_in_fault_o
    ,output [ 31:0]  lsu_in_data_rd_o
    ,output          lsu_in_accept_o
    ,output          lsu_in_ack_o
    ,output          lsu_in_error_o
    ,output [ 10:0]  lsu_in_resp_tag_o
    ,output [ 31:0]  lsu_out_addr_o
    ,output [ 31:0]  lsu_out_data_wr_o
    ,output          lsu_out_rd_o
    ,output [  3:0]  lsu_out_wr_o
    ,output          lsu_out_cacheable_o
    ,output [ 10:0]  lsu_out_req_tag_o
    ,output          lsu_out_invalidate_o
    ,output          lsu_out_writeback_o
    ,output          lsu_out_flush_o
    ,output          lsu_in_load_fault_o
    ,output          lsu_in_store_fault_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

//-----------------------------------------------------------------
// Local defs
//-----------------------------------------------------------------
localparam  STATE_W            = 2;
localparam  STATE_IDLE         = 0;
localparam  STATE_LEVEL_FIRST  = 1;
localparam  STATE_LEVEL_SECOND = 2;
localparam  STATE_UPDATE       = 3;

//-----------------------------------------------------------------
// Basic MMU support
//-----------------------------------------------------------------
generate
if (SUPPORT_MMU)
begin

    //-----------------------------------------------------------------
    // Registers
    //-----------------------------------------------------------------
    reg [STATE_W-1:0] state_q;
    wire              idle_w = (state_q == STATE_IDLE);

    // Magic combo used only by MMU
    wire        resp_mmu_w   = (lsu_out_resp_tag_i[9:7] == 3'b111);
    wire        resp_valid_w = resp_mmu_w & lsu_out_ack_i;
    wire        resp_error_w = resp_mmu_w & lsu_out_error_i;
    wire [31:0] resp_data_w  = lsu_out_data_rd_i;

    wire        cpu_accept_w;

    //-----------------------------------------------------------------
    // Load / Store
    //-----------------------------------------------------------------
    reg       load_q;
    reg [3:0] store_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        load_q <= 1'b0;
    else if (lsu_in_rd_i)
        load_q <= ~lsu_in_accept_o;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        store_q <= 4'b0;
    else if (|lsu_in_wr_i)
        store_q <= lsu_in_accept_o ? 4'b0 : lsu_in_wr_i;

    wire       load_w  = lsu_in_rd_i | load_q;
    wire [3:0] store_w = lsu_in_wr_i | store_q;

    reg [31:0] lsu_in_addr_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        lsu_in_addr_q <= 32'b0;
    else if (load_w || (|store_w))
        lsu_in_addr_q <= lsu_in_addr_i;

    wire [31:0] lsu_addr_w = (load_w || (|store_w)) ? lsu_in_addr_i : lsu_in_addr_q;

    //-----------------------------------------------------------------
    // Page table walker
    //-----------------------------------------------------------------
    wire        itlb_hit_w;
    wire        dtlb_hit_w;

    reg         dtlb_req_q;

    // Global enable
    wire        vm_enable_w = satp_i[`SATP_MODE_R];
    wire [31:0] ptbr_w      = {satp_i[`SATP_PPN_R], 12'b0};

    wire        ifetch_vm_w = (fetch_in_priv_i != `PRIV_MACHINE);
    wire        dfetch_vm_w = (priv_d_i != `PRIV_MACHINE);

    wire        supervisor_i_w = (fetch_in_priv_i == `PRIV_SUPER);
    wire        supervisor_d_w = (priv_d_i == `PRIV_SUPER);

    wire        vm_i_enable_w = (ifetch_vm_w);
    wire        vm_d_enable_w = (vm_enable_w & dfetch_vm_w);

    // TLB entry does not match request address
    wire        itlb_miss_w = fetch_in_rd_i & vm_i_enable_w & ~itlb_hit_w;
    wire        dtlb_miss_w = (load_w || (|store_w)) & vm_d_enable_w & ~dtlb_hit_w;

    // Data miss is higher priority than instruction...
    wire [31:0] request_addr_w = idle_w ? 
                                (dtlb_miss_w ? lsu_addr_w : fetch_in_pc_i) :
                                 dtlb_req_q ? lsu_addr_w : fetch_in_pc_i;

    reg [31:0]  pte_addr_q;
    reg [31:0]  pte_entry_q;
    reg [31:0]  virt_addr_q;

    wire [31:0] pte_ppn_w   = {`PAGE_PFN_SHIFT'b0, resp_data_w[31:`PAGE_PFN_SHIFT]};
    wire [9:0]  pte_flags_w = resp_data_w[9:0];

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
    begin
        pte_addr_q  <= 32'b0;
        pte_entry_q <= 32'b0;
        virt_addr_q <= 32'b0;
        dtlb_req_q  <= 1'b0;
        state_q     <= STATE_IDLE;
    end
    else
    begin
        // TLB miss, walk page table
        if (state_q == STATE_IDLE && (itlb_miss_w || dtlb_miss_w))
        begin
            pte_addr_q  <= ptbr_w + {20'b0, request_addr_w[31:22], 2'b0};
            virt_addr_q <= request_addr_w;
            dtlb_req_q  <= dtlb_miss_w;

            state_q     <= STATE_LEVEL_FIRST;
        end
        // First level (4MB superpage)
        else if (state_q == STATE_LEVEL_FIRST && resp_valid_w)
        begin
            // Error or page not present
            if (resp_error_w || !resp_data_w[`PAGE_PRESENT])
            begin
                pte_entry_q <= 32'b0;
                state_q     <= STATE_UPDATE;
            end
            // Valid entry, but another level to fetch
            else if (!(resp_data_w[`PAGE_READ] || resp_data_w[`PAGE_WRITE] || resp_data_w[`PAGE_EXEC]))
            begin
                pte_addr_q  <= {resp_data_w[29:10], 12'b0} + {20'b0, request_addr_w[21:12], 2'b0};
                state_q     <= STATE_LEVEL_SECOND;
            end
            // Valid entry, actual valid PTE
            else
            begin
                pte_entry_q <= ((pte_ppn_w | {22'b0, request_addr_w[21:12]}) << `MMU_PGSHIFT) | {22'b0, pte_flags_w};
                state_q     <= STATE_UPDATE;
            end
        end
        // Second level (4KB page)
        else if (state_q == STATE_LEVEL_SECOND && resp_valid_w)
        begin
            // Valid entry, final level
            if (resp_data_w[`PAGE_PRESENT])
            begin
                pte_entry_q <= (pte_ppn_w << `MMU_PGSHIFT) | {22'b0, pte_flags_w};
                state_q     <= STATE_UPDATE;
            end
            // Page fault
            else
            begin
                pte_entry_q <= 32'b0;
                state_q     <= STATE_UPDATE;
            end
        end
        else if (state_q == STATE_UPDATE)
        begin
            state_q    <= STATE_IDLE;
        end
    end

    //-----------------------------------------------------------------
    // IMMU TLB
    //-----------------------------------------------------------------
    reg         itlb_valid_q;
    reg [31:12] itlb_va_addr_q;
    reg [31:0]  itlb_entry_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        itlb_valid_q <= 1'b0;
    else if (flush_i)
        itlb_valid_q <= 1'b0;
    else if (state_q == STATE_UPDATE && !dtlb_req_q)
        itlb_valid_q <= (itlb_va_addr_q == fetch_in_pc_i[31:12]); // Fetch TLB still matches incoming request
    else if (state_q != STATE_IDLE && !dtlb_req_q)
        itlb_valid_q <= 1'b0;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
    begin
        itlb_va_addr_q <= 20'b0;
        itlb_entry_q   <= 32'b0;
    end
    else if (state_q == STATE_UPDATE && !dtlb_req_q)
    begin
        itlb_va_addr_q <= virt_addr_q[31:12];
        itlb_entry_q   <= pte_entry_q;
    end

    // TLB address matched (even on page fault)
    assign itlb_hit_w   = fetch_in_rd_i & itlb_valid_q & (itlb_va_addr_q == fetch_in_pc_i[31:12]);

    reg pc_fault_r;
    always @ *
    begin
        pc_fault_r = 1'b0;

        if (vm_i_enable_w && itlb_hit_w)
        begin
            // Supervisor mode
            if (supervisor_i_w)
            begin
                // User page, supervisor cannot execute
                if (itlb_entry_q[`PAGE_USER])
                    pc_fault_r = 1'b1;
                // Check exec permissions
                else
                    pc_fault_r = ~itlb_entry_q[`PAGE_EXEC];
            end
            // User mode
            else
                pc_fault_r = (~itlb_entry_q[`PAGE_EXEC]) | (~itlb_entry_q[`PAGE_USER]);
        end
    end

    reg pc_fault_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        pc_fault_q <= 1'b0;
    else
        pc_fault_q <= pc_fault_r;

    assign fetch_out_rd_o         = (~vm_i_enable_w & fetch_in_rd_i) || (itlb_hit_w & ~pc_fault_r);
    assign fetch_out_pc_o         = vm_i_enable_w ? {itlb_entry_q[31:12], fetch_in_pc_i[11:0]} : fetch_in_pc_i;
    assign fetch_out_flush_o      = fetch_in_flush_i;
    assign fetch_out_invalidate_o = fetch_in_invalidate_i; // TODO: ...

    assign fetch_in_accept_o      = (~vm_i_enable_w & fetch_out_accept_i) | (vm_i_enable_w & itlb_hit_w & fetch_out_accept_i) | pc_fault_r;
    assign fetch_in_valid_o       = fetch_out_valid_i | pc_fault_q;
    assign fetch_in_error_o       = fetch_out_valid_i & fetch_out_error_i;
    assign fetch_in_fault_o       = pc_fault_q;
    assign fetch_in_inst_o        = fetch_out_inst_i;

    //-----------------------------------------------------------------
    // DMMU TLB
    //-----------------------------------------------------------------
    reg         dtlb_valid_q;
    reg [31:12] dtlb_va_addr_q;
    reg [31:0]  dtlb_entry_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        dtlb_valid_q <= 1'b0;
    else if (flush_i)
        dtlb_valid_q <= 1'b0;
    else if (state_q == STATE_UPDATE && dtlb_req_q)
        dtlb_valid_q <= 1'b1;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
    begin
        dtlb_va_addr_q <= 20'b0;
        dtlb_entry_q   <= 32'b0;
    end
    else if (state_q == STATE_UPDATE && dtlb_req_q)
    begin
        dtlb_va_addr_q <= virt_addr_q[31:12];
        dtlb_entry_q   <= pte_entry_q;
    end

    // TLB address matched (even on page fault)
    assign dtlb_hit_w   = dtlb_valid_q & (dtlb_va_addr_q == lsu_addr_w[31:12]);

    reg load_fault_r;
    always @ *
    begin
        load_fault_r = 1'b0;

        if (vm_d_enable_w && load_w && dtlb_hit_w)
        begin
            // Supervisor mode
            if (supervisor_d_w)
            begin
                // User page, supervisor user mode not enabled
                if (dtlb_entry_q[`PAGE_USER] && !sum_i)
                    load_fault_r = 1'b1;
                // Check exec permissions
                else
                    load_fault_r = ~(dtlb_entry_q[`PAGE_READ] | (mxr_i & dtlb_entry_q[`PAGE_EXEC]));
            end
            // User mode
            else
                load_fault_r = (~dtlb_entry_q[`PAGE_READ]) | (~dtlb_entry_q[`PAGE_USER]);
        end
    end

    reg store_fault_r;
    always @ *
    begin
        store_fault_r = 1'b0;

        if (vm_d_enable_w && (|store_w) && dtlb_hit_w)
        begin
            // Supervisor mode
            if (supervisor_d_w)
            begin
                // User page, supervisor user mode not enabled
                if (dtlb_entry_q[`PAGE_USER] && !sum_i)
                    store_fault_r = 1'b1;
                // Check exec permissions
                else
                    store_fault_r = (~dtlb_entry_q[`PAGE_READ]) | (~dtlb_entry_q[`PAGE_WRITE]);
            end
            // User mode
            else
                store_fault_r = (~dtlb_entry_q[`PAGE_READ]) | (~dtlb_entry_q[`PAGE_WRITE]) | (~dtlb_entry_q[`PAGE_USER]);
        end
    end

    reg store_fault_q;
    reg load_fault_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        store_fault_q <= 1'b0;
    else
        store_fault_q <= store_fault_r;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        load_fault_q <= 1'b0;
    else
        load_fault_q <= load_fault_r;   

    wire        lsu_out_rd_w         = vm_d_enable_w ? (load_w  & dtlb_hit_w & ~load_fault_r)       : lsu_in_rd_i;
    wire [3:0]  lsu_out_wr_w         = vm_d_enable_w ? (store_w & {4{dtlb_hit_w & ~store_fault_r}}) : lsu_in_wr_i;
    wire [31:0] lsu_out_addr_w       = vm_d_enable_w ? {dtlb_entry_q[31:12], lsu_addr_w[11:0]}      : lsu_addr_w;
    wire [31:0] lsu_out_data_wr_w    = lsu_in_data_wr_i;

    wire        lsu_out_invalidate_w = lsu_in_invalidate_i;
    wire        lsu_out_writeback_w  = lsu_in_writeback_i;

    reg         lsu_out_cacheable_r;
    always @ *
    begin
/* verilator lint_off UNSIGNED */
/* verilator lint_off CMPCONST */
        if (lsu_in_invalidate_i || lsu_in_writeback_i || lsu_in_flush_i)
            lsu_out_cacheable_r = 1'b1;
        else
            lsu_out_cacheable_r = (lsu_out_addr_w >= MEM_CACHE_ADDR_MIN && lsu_out_addr_w <= MEM_CACHE_ADDR_MAX);
/* verilator lint_on CMPCONST */
/* verilator lint_on UNSIGNED */
    end

    wire [10:0] lsu_out_req_tag_w    = lsu_in_req_tag_i;
    wire        lsu_out_flush_w      = lsu_in_flush_i;

    assign lsu_in_ack_o         = (lsu_out_ack_i & ~resp_mmu_w) | store_fault_q | load_fault_q;
    assign lsu_in_resp_tag_o    = lsu_out_resp_tag_i;
    assign lsu_in_error_o       = (lsu_out_error_i & ~resp_mmu_w) | store_fault_q | load_fault_q;
    assign lsu_in_data_rd_o     = lsu_out_data_rd_i;
    assign lsu_in_store_fault_o = store_fault_q;
    assign lsu_in_load_fault_o  = load_fault_q;

    assign lsu_in_accept_o      = (~vm_d_enable_w & cpu_accept_w) | (vm_d_enable_w & dtlb_hit_w & cpu_accept_w) | store_fault_r | load_fault_r;

    //-----------------------------------------------------------------
    // PTE Fetch Port
    //-----------------------------------------------------------------
    reg mem_req_q;
    wire mmu_accept_w;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
        mem_req_q <= 1'b0;
    else if (state_q == STATE_IDLE && (itlb_miss_w || dtlb_miss_w))
        mem_req_q <= 1'b1;
    else if (state_q == STATE_LEVEL_FIRST && resp_valid_w && !resp_error_w && resp_data_w[`PAGE_PRESENT] && (!(resp_data_w[`PAGE_READ] || resp_data_w[`PAGE_WRITE] || resp_data_w[`PAGE_EXEC])))
        mem_req_q <= 1'b1;    
    else if (mmu_accept_w)
        mem_req_q <= 1'b0;

    //-----------------------------------------------------------------
    // Request Muxing
    //-----------------------------------------------------------------
    reg  read_hold_q;
    reg  src_mmu_q;
    wire src_mmu_w = read_hold_q ? src_mmu_q : mem_req_q;

    always @ (posedge clk_i or posedge rst_i)
    if (rst_i)
    begin
        read_hold_q  <= 1'b0;
        src_mmu_q    <= 1'b0;
    end
    else if ((lsu_out_rd_o || (|lsu_out_wr_o)) && !lsu_out_accept_i)
    begin
        read_hold_q  <= 1'b1;
        src_mmu_q    <= src_mmu_w;
    end
    else if (lsu_out_accept_i)
        read_hold_q  <= 1'b0;

    assign mmu_accept_w         = src_mmu_w  & lsu_out_accept_i;
    assign cpu_accept_w         = ~src_mmu_w & lsu_out_accept_i;

    assign lsu_out_rd_o         = src_mmu_w ? mem_req_q  : lsu_out_rd_w;
    assign lsu_out_wr_o         = src_mmu_w ? 4'b0       : lsu_out_wr_w;
    assign lsu_out_addr_o       = src_mmu_w ? pte_addr_q : lsu_out_addr_w;
    assign lsu_out_data_wr_o    = lsu_out_data_wr_w;

    assign lsu_out_invalidate_o = src_mmu_w ? 1'b0 : lsu_out_invalidate_w;
    assign lsu_out_writeback_o  = src_mmu_w ? 1'b0 : lsu_out_writeback_w;
    assign lsu_out_cacheable_o  = src_mmu_w ? 1'b1 : lsu_out_cacheable_r;
    assign lsu_out_req_tag_o    = src_mmu_w ? {1'b0, 3'b111, 7'b0} : lsu_out_req_tag_w;
    assign lsu_out_flush_o      = src_mmu_w ? 1'b0 : lsu_out_flush_w;

end
//-----------------------------------------------------------------
// No MMU support
//-----------------------------------------------------------------
else
begin
    assign fetch_out_rd_o         = fetch_in_rd_i;
    assign fetch_out_pc_o         = fetch_in_pc_i;
    assign fetch_out_flush_o      = fetch_in_flush_i;
    assign fetch_out_invalidate_o = fetch_in_invalidate_i;
    assign fetch_in_accept_o      = fetch_out_accept_i;
    assign fetch_in_valid_o       = fetch_out_valid_i;
    assign fetch_in_error_o       = fetch_out_error_i;
    assign fetch_in_fault_o       = 1'b0;
    assign fetch_in_inst_o        = fetch_out_inst_i;

    assign lsu_out_rd_o           = lsu_in_rd_i;
    assign lsu_out_wr_o           = lsu_in_wr_i;
    assign lsu_out_addr_o         = lsu_in_addr_i;
    assign lsu_out_data_wr_o      = lsu_in_data_wr_i;
    assign lsu_out_invalidate_o   = lsu_in_invalidate_i;
    assign lsu_out_writeback_o    = lsu_in_writeback_i;
    assign lsu_out_cacheable_o    = lsu_in_cacheable_i;
    assign lsu_out_req_tag_o      = lsu_in_req_tag_i;
    assign lsu_out_flush_o        = lsu_in_flush_i;
    
    assign lsu_in_ack_o           = lsu_out_ack_i;
    assign lsu_in_resp_tag_o      = lsu_out_resp_tag_i;
    assign lsu_in_error_o         = lsu_out_error_i;
    assign lsu_in_data_rd_o       = lsu_out_data_rd_i;
    assign lsu_in_store_fault_o   = 1'b0;
    assign lsu_in_load_fault_o    = 1'b0;

    assign lsu_in_accept_o        = lsu_out_accept_i;
end
endgenerate

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------

module riscv_multiplier
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           opcode_valid_i
    ,input  [ 31:0]  opcode_opcode_i
    ,input  [ 31:0]  opcode_pc_i
    ,input           opcode_invalid_i
    ,input  [  4:0]  opcode_rd_idx_i
    ,input  [  4:0]  opcode_ra_idx_i
    ,input  [  4:0]  opcode_rb_idx_i
    ,input  [ 31:0]  opcode_ra_operand_i
    ,input  [ 31:0]  opcode_rb_operand_i
    ,input           hold_i

    // Outputs
    ,output [ 31:0]  writeback_value_o
);



//-----------------------------------------------------------------
// Includes
//-----------------------------------------------------------------
`include "riscv_defs.v"

localparam MULT_STAGES = 2; // 2 or 3

//-------------------------------------------------------------
// Registers / Wires
//-------------------------------------------------------------
reg  [31:0]  result_e2_q;
reg  [31:0]  result_e3_q;

reg [32:0]   operand_a_e1_q;
reg [32:0]   operand_b_e1_q;
reg          mulhi_sel_e1_q;

//-------------------------------------------------------------
// Multiplier
//-------------------------------------------------------------
wire [64:0]  mult_result_w;
reg  [32:0]  operand_b_r;
reg  [32:0]  operand_a_r;
reg  [31:0]  result_r;

wire mult_inst_w    = ((opcode_opcode_i & `INST_MUL_MASK) == `INST_MUL)        || 
                      ((opcode_opcode_i & `INST_MULH_MASK) == `INST_MULH)      ||
                      ((opcode_opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU)  ||
                      ((opcode_opcode_i & `INST_MULHU_MASK) == `INST_MULHU);


always @ *
begin
    if ((opcode_opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU)
        operand_a_r = {opcode_ra_operand_i[31], opcode_ra_operand_i[31:0]};
    else if ((opcode_opcode_i & `INST_MULH_MASK) == `INST_MULH)
        operand_a_r = {opcode_ra_operand_i[31], opcode_ra_operand_i[31:0]};
    else // MULHU || MUL
        operand_a_r = {1'b0, opcode_ra_operand_i[31:0]};
end

always @ *
begin
    if ((opcode_opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU)
        operand_b_r = {1'b0, opcode_rb_operand_i[31:0]};
    else if ((opcode_opcode_i & `INST_MULH_MASK) == `INST_MULH)
        operand_b_r = {opcode_rb_operand_i[31], opcode_rb_operand_i[31:0]};
    else // MULHU || MUL
        operand_b_r = {1'b0, opcode_rb_operand_i[31:0]};
end


// Pipeline flops for multiplier
always @(posedge clk_i or posedge rst_i)
if (rst_i)
begin
    operand_a_e1_q <= 33'b0;
    operand_b_e1_q <= 33'b0;
    mulhi_sel_e1_q <= 1'b0;
end
else if (hold_i)
    ;
else if (opcode_valid_i && mult_inst_w)
begin
    operand_a_e1_q <= operand_a_r;
    operand_b_e1_q <= operand_b_r;
    mulhi_sel_e1_q <= ~((opcode_opcode_i & `INST_MUL_MASK) == `INST_MUL);
end
else
begin
    operand_a_e1_q <= 33'b0;
    operand_b_e1_q <= 33'b0;
    mulhi_sel_e1_q <= 1'b0;
end

assign mult_result_w = {{ 32 {operand_a_e1_q[32]}}, operand_a_e1_q}*{{ 32 {operand_b_e1_q[32]}}, operand_b_e1_q};

always @ *
begin
    result_r = mulhi_sel_e1_q ? mult_result_w[63:32] : mult_result_w[31:0];
end

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    result_e2_q <= 32'b0;
else if (~hold_i)
    result_e2_q <= result_r;

always @(posedge clk_i or posedge rst_i)
if (rst_i)
    result_e3_q <= 32'b0;
else if (~hold_i)
    result_e3_q <= result_e2_q;

assign writeback_value_o  = (MULT_STAGES == 3) ? result_e3_q : result_e2_q;


endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
module riscv_pipe_ctrl
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_LOAD_BYPASS = 1
    ,parameter SUPPORT_MUL_BYPASS  = 1
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
     input           clk_i
    ,input           rst_i

    // Issue
    ,input           issue_valid_i
    ,input           issue_accept_i
    ,input           issue_stall_i
    ,input           issue_lsu_i
    ,input           issue_csr_i
    ,input           issue_div_i
    ,input           issue_mul_i
    ,input           issue_branch_i
    ,input           issue_rd_valid_i
    ,input  [4:0]    issue_rd_i
    ,input  [5:0]    issue_exception_i
    ,input           take_interrupt_i
    ,input           issue_branch_taken_i
    ,input [31:0]    issue_branch_target_i
    ,input [31:0]    issue_pc_i
    ,input [31:0]    issue_opcode_i
    ,input [31:0]    issue_operand_ra_i
    ,input [31:0]    issue_operand_rb_i

    // Execution stage 1: ALU result
    ,input [31:0]    alu_result_e1_i

    // Execution stage 1: CSR read result / early exceptions
    ,input [ 31:0]   csr_result_value_e1_i
    ,input           csr_result_write_e1_i
    ,input [ 31:0]   csr_result_wdata_e1_i
    ,input [  5:0]   csr_result_exception_e1_i

    // Execution stage 1
    ,output          load_e1_o
    ,output          store_e1_o
    ,output          mul_e1_o
    ,output          branch_e1_o
    ,output [  4:0]  rd_e1_o
    ,output [31:0]   pc_e1_o
    ,output [31:0]   opcode_e1_o
    ,output [31:0]   operand_ra_e1_o
    ,output [31:0]   operand_rb_e1_o

    // Execution stage 2: Other results
    ,input           mem_complete_i
    ,input [31:0]    mem_result_e2_i
    ,input  [5:0]    mem_exception_e2_i
    ,input [31:0]    mul_result_e2_i

    // Execution stage 2
    ,output          load_e2_o
    ,output          mul_e2_o
    ,output [  4:0]  rd_e2_o
    ,output [31:0]   result_e2_o

    // Out of pipe: Divide Result
    ,input           div_complete_i
    ,input  [31:0]   div_result_i

    // Commit
    ,output          valid_wb_o
    ,output          csr_wb_o
    ,output [  4:0]  rd_wb_o
    ,output [31:0]   result_wb_o
    ,output [31:0]   pc_wb_o
    ,output [31:0]   opcode_wb_o
    ,output [31:0]   operand_ra_wb_o
    ,output [31:0]   operand_rb_wb_o
    ,output [5:0]    exception_wb_o
    ,output          csr_write_wb_o
    ,output [11:0]   csr_waddr_wb_o
    ,output [31:0]   csr_wdata_wb_o

    ,output          stall_o
    ,output          squash_e1_e2_o
    ,input           squash_e1_e2_i
    ,input           squash_wb_i
);

//-------------------------------------------------------------
// Includes
//-------------------------------------------------------------
`include "riscv_defs.v"

wire squash_e1_e2_w;
wire branch_misaligned_w = (issue_branch_taken_i && issue_branch_target_i[1:0] != 2'b0);

//-------------------------------------------------------------
// E1 / Address
//------------------------------------------------------------- 
`define PCINFO_W     10
`define PCINFO_ALU       0
`define PCINFO_LOAD      1
`define PCINFO_STORE     2
`define PCINFO_CSR       3
`define PCINFO_DIV       4
`define PCINFO_MUL       5
`define PCINFO_BRANCH    6
`define PCINFO_RD_VALID  7
`define PCINFO_INTR      8
`define PCINFO_COMPLETE  9

`define RD_IDX_R    11:7

reg                     valid_e1_q;
reg [`PCINFO_W-1:0]     ctrl_e1_q;
reg [31:0]              pc_e1_q;
reg [31:0]              npc_e1_q;
reg [31:0]              opcode_e1_q;
reg [31:0]              operand_ra_e1_q;
reg [31:0]              operand_rb_e1_q;
reg [`EXCEPTION_W-1:0]  exception_e1_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    valid_e1_q      <= 1'b0;
    ctrl_e1_q       <= `PCINFO_W'b0;
    pc_e1_q         <= 32'b0;
    npc_e1_q        <= 32'b0;
    opcode_e1_q     <= 32'b0;
    operand_ra_e1_q <= 32'b0;
    operand_rb_e1_q <= 32'b0;
    exception_e1_q  <= `EXCEPTION_W'b0;
end
// Stall - no change in E1 state
else if (issue_stall_i)
    ;
else if ((issue_valid_i && issue_accept_i) && ~(squash_e1_e2_o || squash_e1_e2_i))
begin
    valid_e1_q                  <= 1'b1;
    ctrl_e1_q[`PCINFO_ALU]      <= ~(issue_lsu_i | issue_csr_i | issue_div_i | issue_mul_i);
    ctrl_e1_q[`PCINFO_LOAD]     <= issue_lsu_i &  issue_rd_valid_i & ~take_interrupt_i; // TODO: Check
    ctrl_e1_q[`PCINFO_STORE]    <= issue_lsu_i & ~issue_rd_valid_i & ~take_interrupt_i;
    ctrl_e1_q[`PCINFO_CSR]      <= issue_csr_i & ~take_interrupt_i;
    ctrl_e1_q[`PCINFO_DIV]      <= issue_div_i & ~take_interrupt_i;
    ctrl_e1_q[`PCINFO_MUL]      <= issue_mul_i & ~take_interrupt_i;
    ctrl_e1_q[`PCINFO_BRANCH]   <= issue_branch_i & ~take_interrupt_i;
    ctrl_e1_q[`PCINFO_RD_VALID] <= issue_rd_valid_i & ~take_interrupt_i;
    ctrl_e1_q[`PCINFO_INTR]     <= take_interrupt_i;
    ctrl_e1_q[`PCINFO_COMPLETE] <= 1'b1;

    pc_e1_q         <= issue_pc_i;
    npc_e1_q        <= issue_branch_taken_i ? issue_branch_target_i : issue_pc_i + 32'd4;
    opcode_e1_q     <= issue_opcode_i;
    operand_ra_e1_q <= issue_operand_ra_i;
    operand_rb_e1_q <= issue_operand_rb_i;
    exception_e1_q  <= (|issue_exception_i) ? issue_exception_i : 
                       branch_misaligned_w  ? `EXCEPTION_MISALIGNED_FETCH : `EXCEPTION_W'b0;
end
// No valid instruction (or pipeline flush event)
else
begin
    valid_e1_q      <= 1'b0;
    ctrl_e1_q       <= `PCINFO_W'b0;
    pc_e1_q         <= 32'b0;
    npc_e1_q        <= 32'b0;
    opcode_e1_q     <= 32'b0;
    operand_ra_e1_q <= 32'b0;
    operand_rb_e1_q <= 32'b0;
    exception_e1_q  <= `EXCEPTION_W'b0;
end

wire   alu_e1_w        = ctrl_e1_q[`PCINFO_ALU];
assign load_e1_o       = ctrl_e1_q[`PCINFO_LOAD];
assign store_e1_o      = ctrl_e1_q[`PCINFO_STORE];
wire   csr_e1_w        = ctrl_e1_q[`PCINFO_CSR];
wire   div_e1_w        = ctrl_e1_q[`PCINFO_DIV];
assign mul_e1_o        = ctrl_e1_q[`PCINFO_MUL];
assign branch_e1_o     = ctrl_e1_q[`PCINFO_BRANCH];
assign rd_e1_o         = {5{ctrl_e1_q[`PCINFO_RD_VALID]}} & opcode_e1_q[`RD_IDX_R];
assign pc_e1_o         = pc_e1_q;
assign opcode_e1_o     = opcode_e1_q;
assign operand_ra_e1_o = operand_ra_e1_q;
assign operand_rb_e1_o = operand_rb_e1_q;

//-------------------------------------------------------------
// E2 / Mem result
//------------------------------------------------------------- 
reg                     valid_e2_q;
reg [`PCINFO_W-1:0]     ctrl_e2_q;
reg                     csr_wr_e2_q;
reg [31:0]              csr_wdata_e2_q;
reg [31:0]              result_e2_q;
reg [31:0]              pc_e2_q;
reg [31:0]              npc_e2_q;
reg [31:0]              opcode_e2_q;
reg [31:0]              operand_ra_e2_q;
reg [31:0]              operand_rb_e2_q;
reg [`EXCEPTION_W-1:0]  exception_e2_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    valid_e2_q      <= 1'b0;
    ctrl_e2_q       <= `PCINFO_W'b0;
    csr_wr_e2_q     <= 1'b0;
    csr_wdata_e2_q  <= 32'b0;
    pc_e2_q         <= 32'b0;
    npc_e2_q        <= 32'b0;
    opcode_e2_q     <= 32'b0;
    operand_ra_e2_q <= 32'b0;
    operand_rb_e2_q <= 32'b0;
    result_e2_q     <= 32'b0;
    exception_e2_q  <= `EXCEPTION_W'b0;
end
// Stall - no change in E2 state
else if (issue_stall_i)
    ;
// Pipeline flush
else if (squash_e1_e2_o || squash_e1_e2_i)
begin
    valid_e2_q      <= 1'b0;
    ctrl_e2_q       <= `PCINFO_W'b0;
    csr_wr_e2_q     <= 1'b0;
    csr_wdata_e2_q  <= 32'b0;
    pc_e2_q         <= 32'b0;
    npc_e2_q        <= 32'b0;
    opcode_e2_q     <= 32'b0;
    operand_ra_e2_q <= 32'b0;
    operand_rb_e2_q <= 32'b0;
    result_e2_q     <= 32'b0;
    exception_e2_q  <= `EXCEPTION_W'b0;
end
// Normal pipeline advance
else
begin
    valid_e2_q      <= valid_e1_q;
    ctrl_e2_q       <= ctrl_e1_q;
    csr_wr_e2_q     <= csr_result_write_e1_i;
    csr_wdata_e2_q  <= csr_result_wdata_e1_i;
    pc_e2_q         <= pc_e1_q;
    npc_e2_q        <= npc_e1_q;
    opcode_e2_q     <= opcode_e1_q;
    operand_ra_e2_q <= operand_ra_e1_q;
    operand_rb_e2_q <= operand_rb_e1_q;

    // Launch interrupt
    if (ctrl_e1_q[`PCINFO_INTR])
        exception_e2_q  <= `EXCEPTION_INTERRUPT;
    // If frontend reports bad instruction, ignore later CSR errors...
    else if (|exception_e1_q)
    begin
        valid_e2_q      <= 1'b0;
        exception_e2_q  <= exception_e1_q;
    end
    else
        exception_e2_q  <= csr_result_exception_e1_i;

    if (ctrl_e1_q[`PCINFO_DIV])
        result_e2_q <= div_result_i; 
    else if (ctrl_e1_q[`PCINFO_CSR])
        result_e2_q <= csr_result_value_e1_i;
    else
        result_e2_q <= alu_result_e1_i;
end

reg [31:0] result_e2_r;

wire valid_e2_w      = valid_e2_q & ~issue_stall_i;

always @ *
begin
    // Default: ALU result
    result_e2_r = result_e2_q;

    if (SUPPORT_LOAD_BYPASS && valid_e2_w && (ctrl_e2_q[`PCINFO_LOAD] || ctrl_e2_q[`PCINFO_STORE]))
        result_e2_r = mem_result_e2_i;
    else if (SUPPORT_MUL_BYPASS && valid_e2_w && ctrl_e2_q[`PCINFO_MUL])
        result_e2_r = mul_result_e2_i;
end

wire   load_store_e2_w = ctrl_e2_q[`PCINFO_LOAD] | ctrl_e2_q[`PCINFO_STORE];
assign load_e2_o       = ctrl_e2_q[`PCINFO_LOAD];
assign mul_e2_o        = ctrl_e2_q[`PCINFO_MUL];
assign rd_e2_o         = {5{(valid_e2_w && ctrl_e2_q[`PCINFO_RD_VALID] && ~stall_o)}} & opcode_e2_q[`RD_IDX_R];
assign result_e2_o     = result_e2_r;

// Load store result not ready when reaching E2
assign stall_o         = (ctrl_e1_q[`PCINFO_DIV] && ~div_complete_i) || ((ctrl_e2_q[`PCINFO_LOAD] | ctrl_e2_q[`PCINFO_STORE]) & ~mem_complete_i);

reg [`EXCEPTION_W-1:0] exception_e2_r;
always @ *
begin
    if (valid_e2_q && (ctrl_e2_q[`PCINFO_LOAD] || ctrl_e2_q[`PCINFO_STORE]) && mem_complete_i)
        exception_e2_r = mem_exception_e2_i;
    else
        exception_e2_r = exception_e2_q;
end

assign squash_e1_e2_w = |exception_e2_r;

reg squash_e1_e2_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    squash_e1_e2_q <= 1'b0;
else if (~issue_stall_i)
    squash_e1_e2_q <= squash_e1_e2_w;

assign squash_e1_e2_o = squash_e1_e2_w | squash_e1_e2_q;

//-------------------------------------------------------------
// Writeback / Commit
//------------------------------------------------------------- 
reg                     valid_wb_q;
reg [`PCINFO_W-1:0]     ctrl_wb_q;
reg                     csr_wr_wb_q;
reg [31:0]              csr_wdata_wb_q;
reg [31:0]              result_wb_q;
reg [31:0]              pc_wb_q;
reg [31:0]              npc_wb_q;
reg [31:0]              opcode_wb_q;
reg [31:0]              operand_ra_wb_q;
reg [31:0]              operand_rb_wb_q;
reg [`EXCEPTION_W-1:0]  exception_wb_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    valid_wb_q      <= 1'b0;
    ctrl_wb_q       <= `PCINFO_W'b0;
    csr_wr_wb_q     <= 1'b0;
    csr_wdata_wb_q  <= 32'b0;
    pc_wb_q         <= 32'b0;
    npc_wb_q        <= 32'b0;
    opcode_wb_q     <= 32'b0;
    operand_ra_wb_q <= 32'b0;
    operand_rb_wb_q <= 32'b0;
    result_wb_q     <= 32'b0;
    exception_wb_q  <= `EXCEPTION_W'b0;
end
// Stall - no change in WB state
else if (issue_stall_i)
    ;
else if (squash_wb_i)
begin
    valid_wb_q      <= 1'b0;
    ctrl_wb_q       <= `PCINFO_W'b0;
    csr_wr_wb_q     <= 1'b0;
    csr_wdata_wb_q  <= 32'b0;
    pc_wb_q         <= 32'b0;
    npc_wb_q        <= 32'b0;
    opcode_wb_q     <= 32'b0;
    operand_ra_wb_q <= 32'b0;
    operand_rb_wb_q <= 32'b0;
    result_wb_q     <= 32'b0;
    exception_wb_q  <= `EXCEPTION_W'b0;
end
else
begin
    // Squash instruction valid on memory faults
    case (exception_e2_r)
    `EXCEPTION_MISALIGNED_LOAD,
    `EXCEPTION_FAULT_LOAD,
    `EXCEPTION_MISALIGNED_STORE,
    `EXCEPTION_FAULT_STORE,
    `EXCEPTION_PAGE_FAULT_LOAD,
    `EXCEPTION_PAGE_FAULT_STORE:
        valid_wb_q      <= 1'b0;
    default:
        valid_wb_q      <= valid_e2_q;
    endcase

    csr_wr_wb_q     <= csr_wr_e2_q;  // TODO: Fault disable???
    csr_wdata_wb_q  <= csr_wdata_e2_q;

    // Exception - squash writeback
    if (|exception_e2_r)
        ctrl_wb_q       <= ctrl_e2_q & ~(1 << `PCINFO_RD_VALID);
    else
        ctrl_wb_q       <= ctrl_e2_q;

    pc_wb_q         <= pc_e2_q;
    npc_wb_q        <= npc_e2_q;
    opcode_wb_q     <= opcode_e2_q;
    operand_ra_wb_q <= operand_ra_e2_q;
    operand_rb_wb_q <= operand_rb_e2_q;
    exception_wb_q  <= exception_e2_r;

    if (valid_e2_w && (ctrl_e2_q[`PCINFO_LOAD] || ctrl_e2_q[`PCINFO_STORE]))
        result_wb_q <= mem_result_e2_i;
    else if (valid_e2_w && ctrl_e2_q[`PCINFO_MUL])
        result_wb_q <= mul_result_e2_i;
    else
        result_wb_q <= result_e2_q;
end

// Instruction completion (for debug)
wire complete_wb_w     = ctrl_wb_q[`PCINFO_COMPLETE] & ~issue_stall_i;

assign valid_wb_o      = valid_wb_q & ~issue_stall_i;
assign csr_wb_o        = ctrl_wb_q[`PCINFO_CSR] & ~issue_stall_i; // TODO: Fault disable???
assign rd_wb_o         = {5{(valid_wb_o && ctrl_wb_q[`PCINFO_RD_VALID] && ~stall_o)}} & opcode_wb_q[`RD_IDX_R];
assign result_wb_o     = result_wb_q;
assign pc_wb_o         = pc_wb_q;
assign opcode_wb_o     = opcode_wb_q;
assign operand_ra_wb_o = operand_ra_wb_q;
assign operand_rb_wb_o = operand_rb_wb_q;

assign exception_wb_o  = exception_wb_q;

assign csr_write_wb_o  = csr_wr_wb_q;
assign csr_waddr_wb_o  = opcode_wb_q[31:20];
assign csr_wdata_wb_o  = csr_wdata_wb_q;

`ifdef verilator
riscv_trace_sim
u_trace_d
(
     .valid_i(issue_valid_i)
    ,.pc_i(issue_pc_i)
    ,.opcode_i(issue_opcode_i)
);

riscv_trace_sim
u_trace_wb
(
     .valid_i(valid_wb_o)
    ,.pc_i(pc_wb_o)
    ,.opcode_i(opcode_wb_o)
);
`endif

endmodule//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
module riscv_regfile
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter SUPPORT_REGFILE_XILINX = 0
)
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [  4:0]  rd0_i
    ,input  [ 31:0]  rd0_value_i
    ,input  [  4:0]  ra0_i
    ,input  [  4:0]  rb0_i

    // Outputs
    ,output [ 31:0]  ra0_value_o
    ,output [ 31:0]  rb0_value_o
);

//-----------------------------------------------------------------
// Xilinx specific register file (single issue)
//-----------------------------------------------------------------
generate
if (SUPPORT_REGFILE_XILINX)
begin: REGFILE_XILINX_SINGLE

    riscv_xilinx_2r1w
    u_reg
    (
        // Inputs
         .clk_i(clk_i)
        ,.rst_i(rst_i)
        ,.rd0_i(rd0_i)
        ,.rd0_value_i(rd0_value_i)
        ,.ra_i(ra0_i)
        ,.rb_i(rb0_i)

        // Outputs
        ,.ra_value_o(ra0_value_o)
        ,.rb_value_o(rb0_value_o)
    );
end
//-----------------------------------------------------------------
// Flop based register file
//-----------------------------------------------------------------
else
begin: REGFILE
    reg [31:0] reg_r1_q;
    reg [31:0] reg_r2_q;
    reg [31:0] reg_r3_q;
    reg [31:0] reg_r4_q;
    reg [31:0] reg_r5_q;
    reg [31:0] reg_r6_q;
    reg [31:0] reg_r7_q;
    reg [31:0] reg_r8_q;
    reg [31:0] reg_r9_q;
    reg [31:0] reg_r10_q;
    reg [31:0] reg_r11_q;
    reg [31:0] reg_r12_q;
    reg [31:0] reg_r13_q;
    reg [31:0] reg_r14_q;
    reg [31:0] reg_r15_q;
    reg [31:0] reg_r16_q;
    reg [31:0] reg_r17_q;
    reg [31:0] reg_r18_q;
    reg [31:0] reg_r19_q;
    reg [31:0] reg_r20_q;
    reg [31:0] reg_r21_q;
    reg [31:0] reg_r22_q;
    reg [31:0] reg_r23_q;
    reg [31:0] reg_r24_q;
    reg [31:0] reg_r25_q;
    reg [31:0] reg_r26_q;
    reg [31:0] reg_r27_q;
    reg [31:0] reg_r28_q;
    reg [31:0] reg_r29_q;
    reg [31:0] reg_r30_q;
    reg [31:0] reg_r31_q;

    // Simulation friendly names
    wire [31:0] x0_zero_w = 32'b0;
    wire [31:0] x1_ra_w   = reg_r1_q;
    wire [31:0] x2_sp_w   = reg_r2_q;
    wire [31:0] x3_gp_w   = reg_r3_q;
    wire [31:0] x4_tp_w   = reg_r4_q;
    wire [31:0] x5_t0_w   = reg_r5_q;
    wire [31:0] x6_t1_w   = reg_r6_q;
    wire [31:0] x7_t2_w   = reg_r7_q;
    wire [31:0] x8_s0_w   = reg_r8_q;
    wire [31:0] x9_s1_w   = reg_r9_q;
    wire [31:0] x10_a0_w  = reg_r10_q;
    wire [31:0] x11_a1_w  = reg_r11_q;
    wire [31:0] x12_a2_w  = reg_r12_q;
    wire [31:0] x13_a3_w  = reg_r13_q;
    wire [31:0] x14_a4_w  = reg_r14_q;
    wire [31:0] x15_a5_w  = reg_r15_q;
    wire [31:0] x16_a6_w  = reg_r16_q;
    wire [31:0] x17_a7_w  = reg_r17_q;
    wire [31:0] x18_s2_w  = reg_r18_q;
    wire [31:0] x19_s3_w  = reg_r19_q;
    wire [31:0] x20_s4_w  = reg_r20_q;
    wire [31:0] x21_s5_w  = reg_r21_q;
    wire [31:0] x22_s6_w  = reg_r22_q;
    wire [31:0] x23_s7_w  = reg_r23_q;
    wire [31:0] x24_s8_w  = reg_r24_q;
    wire [31:0] x25_s9_w  = reg_r25_q;
    wire [31:0] x26_s10_w = reg_r26_q;
    wire [31:0] x27_s11_w = reg_r27_q;
    wire [31:0] x28_t3_w  = reg_r28_q;
    wire [31:0] x29_t4_w  = reg_r29_q;
    wire [31:0] x30_t5_w  = reg_r30_q;
    wire [31:0] x31_t6_w  = reg_r31_q;

    //-----------------------------------------------------------------
    // Flop based register File (for simulation)
    //-----------------------------------------------------------------

    // Synchronous register write back
    always @ (posedge clk_i )
    if (rst_i)
    begin
        reg_r1_q       <= 32'h00000000;
        reg_r2_q       <= 32'h00000000;
        reg_r3_q       <= 32'h00000000;
        reg_r4_q       <= 32'h00000000;
        reg_r5_q       <= 32'h00000000;
        reg_r6_q       <= 32'h00000000;
        reg_r7_q       <= 32'h00000000;
        reg_r8_q       <= 32'h00000000;
        reg_r9_q       <= 32'h00000000;
        reg_r10_q      <= 32'h00000000;
        reg_r11_q      <= 32'h00000000;
        reg_r12_q      <= 32'h00000000;
        reg_r13_q      <= 32'h00000000;
        reg_r14_q      <= 32'h00000000;
        reg_r15_q      <= 32'h00000000;
        reg_r16_q      <= 32'h00000000;
        reg_r17_q      <= 32'h00000000;
        reg_r18_q      <= 32'h00000000;
        reg_r19_q      <= 32'h00000000;
        reg_r20_q      <= 32'h00000000;
        reg_r21_q      <= 32'h00000000;
        reg_r22_q      <= 32'h00000000;
        reg_r23_q      <= 32'h00000000;
        reg_r24_q      <= 32'h00000000;
        reg_r25_q      <= 32'h00000000;
        reg_r26_q      <= 32'h00000000;
        reg_r27_q      <= 32'h00000000;
        reg_r28_q      <= 32'h00000000;
        reg_r29_q      <= 32'h00000000;
        reg_r30_q      <= 32'h00000000;
        reg_r31_q      <= 32'h00000000;
    end
    else
    begin
        if      (rd0_i == 5'd1) reg_r1_q <= rd0_value_i;
        if      (rd0_i == 5'd2) reg_r2_q <= rd0_value_i;
        if      (rd0_i == 5'd3) reg_r3_q <= rd0_value_i;
        if      (rd0_i == 5'd4) reg_r4_q <= rd0_value_i;
        if      (rd0_i == 5'd5) reg_r5_q <= rd0_value_i;
        if      (rd0_i == 5'd6) reg_r6_q <= rd0_value_i;
        if      (rd0_i == 5'd7) reg_r7_q <= rd0_value_i;
        if      (rd0_i == 5'd8) reg_r8_q <= rd0_value_i;
        if      (rd0_i == 5'd9) reg_r9_q <= rd0_value_i;
        if      (rd0_i == 5'd10) reg_r10_q <= rd0_value_i;
        if      (rd0_i == 5'd11) reg_r11_q <= rd0_value_i;
        if      (rd0_i == 5'd12) reg_r12_q <= rd0_value_i;
        if      (rd0_i == 5'd13) reg_r13_q <= rd0_value_i;
        if      (rd0_i == 5'd14) reg_r14_q <= rd0_value_i;
        if      (rd0_i == 5'd15) reg_r15_q <= rd0_value_i;
        if      (rd0_i == 5'd16) reg_r16_q <= rd0_value_i;
        if      (rd0_i == 5'd17) reg_r17_q <= rd0_value_i;
        if      (rd0_i == 5'd18) reg_r18_q <= rd0_value_i;
        if      (rd0_i == 5'd19) reg_r19_q <= rd0_value_i;
        if      (rd0_i == 5'd20) reg_r20_q <= rd0_value_i;
        if      (rd0_i == 5'd21) reg_r21_q <= rd0_value_i;
        if      (rd0_i == 5'd22) reg_r22_q <= rd0_value_i;
        if      (rd0_i == 5'd23) reg_r23_q <= rd0_value_i;
        if      (rd0_i == 5'd24) reg_r24_q <= rd0_value_i;
        if      (rd0_i == 5'd25) reg_r25_q <= rd0_value_i;
        if      (rd0_i == 5'd26) reg_r26_q <= rd0_value_i;
        if      (rd0_i == 5'd27) reg_r27_q <= rd0_value_i;
        if      (rd0_i == 5'd28) reg_r28_q <= rd0_value_i;
        if      (rd0_i == 5'd29) reg_r29_q <= rd0_value_i;
        if      (rd0_i == 5'd30) reg_r30_q <= rd0_value_i;
        if      (rd0_i == 5'd31) reg_r31_q <= rd0_value_i;
    end

    //-----------------------------------------------------------------
    // Asynchronous read
    //-----------------------------------------------------------------
    reg [31:0] ra0_value_r;
    reg [31:0] rb0_value_r;
    always @ *
    begin
        case (ra0_i)
        5'd1: ra0_value_r = reg_r1_q;
        5'd2: ra0_value_r = reg_r2_q;
        5'd3: ra0_value_r = reg_r3_q;
        5'd4: ra0_value_r = reg_r4_q;
        5'd5: ra0_value_r = reg_r5_q;
        5'd6: ra0_value_r = reg_r6_q;
        5'd7: ra0_value_r = reg_r7_q;
        5'd8: ra0_value_r = reg_r8_q;
        5'd9: ra0_value_r = reg_r9_q;
        5'd10: ra0_value_r = reg_r10_q;
        5'd11: ra0_value_r = reg_r11_q;
        5'd12: ra0_value_r = reg_r12_q;
        5'd13: ra0_value_r = reg_r13_q;
        5'd14: ra0_value_r = reg_r14_q;
        5'd15: ra0_value_r = reg_r15_q;
        5'd16: ra0_value_r = reg_r16_q;
        5'd17: ra0_value_r = reg_r17_q;
        5'd18: ra0_value_r = reg_r18_q;
        5'd19: ra0_value_r = reg_r19_q;
        5'd20: ra0_value_r = reg_r20_q;
        5'd21: ra0_value_r = reg_r21_q;
        5'd22: ra0_value_r = reg_r22_q;
        5'd23: ra0_value_r = reg_r23_q;
        5'd24: ra0_value_r = reg_r24_q;
        5'd25: ra0_value_r = reg_r25_q;
        5'd26: ra0_value_r = reg_r26_q;
        5'd27: ra0_value_r = reg_r27_q;
        5'd28: ra0_value_r = reg_r28_q;
        5'd29: ra0_value_r = reg_r29_q;
        5'd30: ra0_value_r = reg_r30_q;
        5'd31: ra0_value_r = reg_r31_q;
        default : ra0_value_r = 32'h00000000;
        endcase

        case (rb0_i)
        5'd1: rb0_value_r = reg_r1_q;
        5'd2: rb0_value_r = reg_r2_q;
        5'd3: rb0_value_r = reg_r3_q;
        5'd4: rb0_value_r = reg_r4_q;
        5'd5: rb0_value_r = reg_r5_q;
        5'd6: rb0_value_r = reg_r6_q;
        5'd7: rb0_value_r = reg_r7_q;
        5'd8: rb0_value_r = reg_r8_q;
        5'd9: rb0_value_r = reg_r9_q;
        5'd10: rb0_value_r = reg_r10_q;
        5'd11: rb0_value_r = reg_r11_q;
        5'd12: rb0_value_r = reg_r12_q;
        5'd13: rb0_value_r = reg_r13_q;
        5'd14: rb0_value_r = reg_r14_q;
        5'd15: rb0_value_r = reg_r15_q;
        5'd16: rb0_value_r = reg_r16_q;
        5'd17: rb0_value_r = reg_r17_q;
        5'd18: rb0_value_r = reg_r18_q;
        5'd19: rb0_value_r = reg_r19_q;
        5'd20: rb0_value_r = reg_r20_q;
        5'd21: rb0_value_r = reg_r21_q;
        5'd22: rb0_value_r = reg_r22_q;
        5'd23: rb0_value_r = reg_r23_q;
        5'd24: rb0_value_r = reg_r24_q;
        5'd25: rb0_value_r = reg_r25_q;
        5'd26: rb0_value_r = reg_r26_q;
        5'd27: rb0_value_r = reg_r27_q;
        5'd28: rb0_value_r = reg_r28_q;
        5'd29: rb0_value_r = reg_r29_q;
        5'd30: rb0_value_r = reg_r30_q;
        5'd31: rb0_value_r = reg_r31_q;
        default : rb0_value_r = 32'h00000000;
        endcase
    end

    assign ra0_value_o = ra0_value_r;
    assign rb0_value_o = rb0_value_r;

    //-------------------------------------------------------------
    // get_register: Read register file
    //-------------------------------------------------------------
    `ifdef verilator
    function [31:0] get_register; /*verilator public*/
        input [4:0] r;
    begin
        case (r)
        5'd1: get_register = reg_r1_q;
        5'd2: get_register = reg_r2_q;
        5'd3: get_register = reg_r3_q;
        5'd4: get_register = reg_r4_q;
        5'd5: get_register = reg_r5_q;
        5'd6: get_register = reg_r6_q;
        5'd7: get_register = reg_r7_q;
        5'd8: get_register = reg_r8_q;
        5'd9: get_register = reg_r9_q;
        5'd10: get_register = reg_r10_q;
        5'd11: get_register = reg_r11_q;
        5'd12: get_register = reg_r12_q;
        5'd13: get_register = reg_r13_q;
        5'd14: get_register = reg_r14_q;
        5'd15: get_register = reg_r15_q;
        5'd16: get_register = reg_r16_q;
        5'd17: get_register = reg_r17_q;
        5'd18: get_register = reg_r18_q;
        5'd19: get_register = reg_r19_q;
        5'd20: get_register = reg_r20_q;
        5'd21: get_register = reg_r21_q;
        5'd22: get_register = reg_r22_q;
        5'd23: get_register = reg_r23_q;
        5'd24: get_register = reg_r24_q;
        5'd25: get_register = reg_r25_q;
        5'd26: get_register = reg_r26_q;
        5'd27: get_register = reg_r27_q;
        5'd28: get_register = reg_r28_q;
        5'd29: get_register = reg_r29_q;
        5'd30: get_register = reg_r30_q;
        5'd31: get_register = reg_r31_q;
        default : get_register = 32'h00000000;
        endcase
    end
    endfunction
    //-------------------------------------------------------------
    // set_register: Write register file
    //-------------------------------------------------------------
    function set_register; /*verilator public*/
        input [4:0] r;
        input [31:0] value;
    begin
        //case (r)
        //5'd1:  reg_r1_q  <= value;
        //5'd2:  reg_r2_q  <= value;
        //5'd3:  reg_r3_q  <= value;
        //5'd4:  reg_r4_q  <= value;
        //5'd5:  reg_r5_q  <= value;
        //5'd6:  reg_r6_q  <= value;
        //5'd7:  reg_r7_q  <= value;
        //5'd8:  reg_r8_q  <= value;
        //5'd9:  reg_r9_q  <= value;
        //5'd10: reg_r10_q <= value;
        //5'd11: reg_r11_q <= value;
        //5'd12: reg_r12_q <= value;
        //5'd13: reg_r13_q <= value;
        //5'd14: reg_r14_q <= value;
        //5'd15: reg_r15_q <= value;
        //5'd16: reg_r16_q <= value;
        //5'd17: reg_r17_q <= value;
        //5'd18: reg_r18_q <= value;
        //5'd19: reg_r19_q <= value;
        //5'd20: reg_r20_q <= value;
        //5'd21: reg_r21_q <= value;
        //5'd22: reg_r22_q <= value;
        //5'd23: reg_r23_q <= value;
        //5'd24: reg_r24_q <= value;
        //5'd25: reg_r25_q <= value;
        //5'd26: reg_r26_q <= value;
        //5'd27: reg_r27_q <= value;
        //5'd28: reg_r28_q <= value;
        //5'd29: reg_r29_q <= value;
        //5'd30: reg_r30_q <= value;
        //5'd31: reg_r31_q <= value;
        //default :
        //    ;
        //endcase
    end
    endfunction
    `endif

end
endgenerate

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
`include "riscv_defs.v"

module riscv_trace_sim
(
     input                        valid_i
    ,input  [31:0]                pc_i
    ,input  [31:0]                opcode_i
);

//-----------------------------------------------------------------
// get_regname_str: Convert register number to string
//-----------------------------------------------------------------
`ifdef verilator
function [79:0] get_regname_str;
    input  [4:0] regnum;
begin
    case (regnum)
        5'd0:  get_regname_str = "zero";
        5'd1:  get_regname_str = "ra";
        5'd2:  get_regname_str = "sp";
        5'd3:  get_regname_str = "gp";
        5'd4:  get_regname_str = "tp";
        5'd5:  get_regname_str = "t0";
        5'd6:  get_regname_str = "t1";
        5'd7:  get_regname_str = "t2";
        5'd8:  get_regname_str = "s0";
        5'd9:  get_regname_str = "s1";
        5'd10: get_regname_str = "a0";
        5'd11: get_regname_str = "a1";
        5'd12: get_regname_str = "a2";
        5'd13: get_regname_str = "a3";
        5'd14: get_regname_str = "a4";
        5'd15: get_regname_str = "a5";
        5'd16: get_regname_str = "a6";
        5'd17: get_regname_str = "a7";
        5'd18: get_regname_str = "s2";
        5'd19: get_regname_str = "s3";
        5'd20: get_regname_str = "s4";
        5'd21: get_regname_str = "s5";
        5'd22: get_regname_str = "s6";
        5'd23: get_regname_str = "s7";
        5'd24: get_regname_str = "s8";
        5'd25: get_regname_str = "s9";
        5'd26: get_regname_str = "s10";
        5'd27: get_regname_str = "s11";
        5'd28: get_regname_str = "t3";
        5'd29: get_regname_str = "t4";
        5'd30: get_regname_str = "t5";
        5'd31: get_regname_str = "t6";
    endcase
end
endfunction

//-------------------------------------------------------------------
// Debug strings
//-------------------------------------------------------------------
reg [79:0] dbg_inst_str;
reg [79:0] dbg_inst_ra;
reg [79:0] dbg_inst_rb;
reg [79:0] dbg_inst_rd;
reg [31:0] dbg_inst_imm;
reg [31:0] dbg_inst_pc;

wire [4:0] ra_idx_w = opcode_i[19:15];
wire [4:0] rb_idx_w = opcode_i[24:20];
wire [4:0] rd_idx_w = opcode_i[11:7];

`define DBG_IMM_IMM20     {opcode_i[31:12], 12'b0}
`define DBG_IMM_IMM12     {{20{opcode_i[31]}}, opcode_i[31:20]}
`define DBG_IMM_BIMM      {{19{opcode_i[31]}}, opcode_i[31], opcode_i[7], opcode_i[30:25], opcode_i[11:8], 1'b0}
`define DBG_IMM_JIMM20    {{12{opcode_i[31]}}, opcode_i[19:12], opcode_i[20], opcode_i[30:25], opcode_i[24:21], 1'b0}
`define DBG_IMM_STOREIMM  {{20{opcode_i[31]}}, opcode_i[31:25], opcode_i[11:7]}
`define DBG_IMM_SHAMT     opcode_i[24:20]

always @ *
begin
    dbg_inst_str = "-";
    dbg_inst_ra  = "-";
    dbg_inst_rb  = "-";
    dbg_inst_rd  = "-";
    dbg_inst_pc  = 32'bx;

    if (valid_i)
    begin
        dbg_inst_pc  = pc_i;
        dbg_inst_ra  = get_regname_str(ra_idx_w);
        dbg_inst_rb  = get_regname_str(rb_idx_w);
        dbg_inst_rd  = get_regname_str(rd_idx_w);

        case (1'b1)
            ((opcode_i & `INST_ANDI_MASK) == `INST_ANDI)   : dbg_inst_str = "andi";
            ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI)   : dbg_inst_str = "addi";
            ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI)   : dbg_inst_str = "slti";
            ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU)  : dbg_inst_str = "sltiu";
            ((opcode_i & `INST_ORI_MASK) == `INST_ORI)    : dbg_inst_str = "ori";
            ((opcode_i & `INST_XORI_MASK) == `INST_XORI)   : dbg_inst_str = "xori";
            ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI)   : dbg_inst_str = "slli";
            ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI)   : dbg_inst_str = "srli";
            ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI)   : dbg_inst_str = "srai";
            ((opcode_i & `INST_LUI_MASK) == `INST_LUI)    : dbg_inst_str = "lui";
            ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC)  : dbg_inst_str = "auipc";
            ((opcode_i & `INST_ADD_MASK) == `INST_ADD)    : dbg_inst_str = "add";
            ((opcode_i & `INST_SUB_MASK) == `INST_SUB)    : dbg_inst_str = "sub";
            ((opcode_i & `INST_SLT_MASK) == `INST_SLT)    : dbg_inst_str = "slt";
            ((opcode_i & `INST_SLTU_MASK) == `INST_SLTU)   : dbg_inst_str = "sltu";
            ((opcode_i & `INST_XOR_MASK) == `INST_XOR)    : dbg_inst_str = "xor";
            ((opcode_i & `INST_OR_MASK) == `INST_OR)     : dbg_inst_str = "or";
            ((opcode_i & `INST_AND_MASK) == `INST_AND)    : dbg_inst_str = "and";
            ((opcode_i & `INST_SLL_MASK) == `INST_SLL)    : dbg_inst_str = "sll";
            ((opcode_i & `INST_SRL_MASK) == `INST_SRL)    : dbg_inst_str = "srl";
            ((opcode_i & `INST_SRA_MASK) == `INST_SRA)    : dbg_inst_str = "sra";
            ((opcode_i & `INST_JAL_MASK) == `INST_JAL)    : dbg_inst_str = "jal";
            ((opcode_i & `INST_JALR_MASK) == `INST_JALR)   : dbg_inst_str = "jalr";
            ((opcode_i & `INST_BEQ_MASK) == `INST_BEQ)    : dbg_inst_str = "beq";
            ((opcode_i & `INST_BNE_MASK) == `INST_BNE)    : dbg_inst_str = "bne";
            ((opcode_i & `INST_BLT_MASK) == `INST_BLT)    : dbg_inst_str = "blt";
            ((opcode_i & `INST_BGE_MASK) == `INST_BGE)    : dbg_inst_str = "bge";
            ((opcode_i & `INST_BLTU_MASK) == `INST_BLTU)   : dbg_inst_str = "bltu";
            ((opcode_i & `INST_BGEU_MASK) == `INST_BGEU)   : dbg_inst_str = "bgeu";
            ((opcode_i & `INST_LB_MASK) == `INST_LB)     : dbg_inst_str = "lb";
            ((opcode_i & `INST_LH_MASK) == `INST_LH)     : dbg_inst_str = "lh";
            ((opcode_i & `INST_LW_MASK) == `INST_LW)     : dbg_inst_str = "lw";
            ((opcode_i & `INST_LBU_MASK) == `INST_LBU)    : dbg_inst_str = "lbu";
            ((opcode_i & `INST_LHU_MASK) == `INST_LHU)    : dbg_inst_str = "lhu";
            ((opcode_i & `INST_LWU_MASK) == `INST_LWU)    : dbg_inst_str = "lwu";
            ((opcode_i & `INST_SB_MASK) == `INST_SB)     : dbg_inst_str = "sb";
            ((opcode_i & `INST_SH_MASK) == `INST_SH)     : dbg_inst_str = "sh";
            ((opcode_i & `INST_SW_MASK) == `INST_SW)     : dbg_inst_str = "sw";
            ((opcode_i & `INST_ECALL_MASK) == `INST_ECALL)  : dbg_inst_str = "ecall";
            ((opcode_i & `INST_EBREAK_MASK) == `INST_EBREAK) : dbg_inst_str = "ebreak";
            ((opcode_i & `INST_ERET_MASK) == `INST_ERET)   : dbg_inst_str = "eret";
            ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW)  : dbg_inst_str = "csrrw";
            ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS)  : dbg_inst_str = "csrrs";
            ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC)  : dbg_inst_str = "csrrc";
            ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI) : dbg_inst_str = "csrrwi";
            ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI) : dbg_inst_str = "csrrsi";
            ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI) : dbg_inst_str = "csrrci";
            ((opcode_i & `INST_MUL_MASK) == `INST_MUL)    : dbg_inst_str = "mul";
            ((opcode_i & `INST_MULH_MASK) == `INST_MULH)   : dbg_inst_str = "mulh";
            ((opcode_i & `INST_MULHSU_MASK) == `INST_MULHSU) : dbg_inst_str = "mulhsu";
            ((opcode_i & `INST_MULHU_MASK) == `INST_MULHU)  : dbg_inst_str = "mulhu";
            ((opcode_i & `INST_DIV_MASK) == `INST_DIV)    : dbg_inst_str = "div";
            ((opcode_i & `INST_DIVU_MASK) == `INST_DIVU)   : dbg_inst_str = "divu";
            ((opcode_i & `INST_REM_MASK) == `INST_REM)    : dbg_inst_str = "rem";
            ((opcode_i & `INST_REMU_MASK) == `INST_REMU)   : dbg_inst_str = "remu";
            ((opcode_i & `INST_IFENCE_MASK) == `INST_IFENCE)  : dbg_inst_str = "fence.i";
        endcase

        case (1'b1)

            ((opcode_i & `INST_ADDI_MASK) == `INST_ADDI) ,  // addi
            ((opcode_i & `INST_ANDI_MASK) == `INST_ANDI) ,  // andi
            ((opcode_i & `INST_SLTI_MASK) == `INST_SLTI) ,  // slti
            ((opcode_i & `INST_SLTIU_MASK) == `INST_SLTIU) , // sltiu
            ((opcode_i & `INST_ORI_MASK) == `INST_ORI) ,   // ori
            ((opcode_i & `INST_XORI_MASK) == `INST_XORI) ,  // xori
            ((opcode_i & `INST_CSRRW_MASK) == `INST_CSRRW) , // csrrw
            ((opcode_i & `INST_CSRRS_MASK) == `INST_CSRRS) , // csrrs
            ((opcode_i & `INST_CSRRC_MASK) == `INST_CSRRC) , // csrrc
            ((opcode_i & `INST_CSRRWI_MASK) == `INST_CSRRWI) ,// csrrwi
            ((opcode_i & `INST_CSRRSI_MASK) == `INST_CSRRSI) ,// csrrsi
            ((opcode_i & `INST_CSRRCI_MASK) == `INST_CSRRCI) :// csrrci
            begin
                dbg_inst_rb  = "-";
                dbg_inst_imm = `DBG_IMM_IMM12;
            end

            ((opcode_i & `INST_SLLI_MASK) == `INST_SLLI) , // slli
            ((opcode_i & `INST_SRLI_MASK) == `INST_SRLI) , // srli
            ((opcode_i & `INST_SRAI_MASK) == `INST_SRAI) : // srai
            begin
                dbg_inst_rb  = "-";
                dbg_inst_imm = {27'b0, `DBG_IMM_SHAMT};
            end

            ((opcode_i & `INST_LUI_MASK) == `INST_LUI) : // lui
            begin
                dbg_inst_ra  = "-";
                dbg_inst_rb  = "-";
                dbg_inst_imm = `DBG_IMM_IMM20;
            end

            ((opcode_i & `INST_AUIPC_MASK) == `INST_AUIPC) : // auipc
            begin
                dbg_inst_ra  = "pc";
                dbg_inst_rb  = "-";
                dbg_inst_imm = `DBG_IMM_IMM20;
            end   

            ((opcode_i & `INST_JAL_MASK) == `INST_JAL) :  // jal
            begin
                dbg_inst_ra  = "-";
                dbg_inst_rb  = "-";
                dbg_inst_imm = pc_i + `DBG_IMM_JIMM20;

                if (rd_idx_w == 5'd1)
                    dbg_inst_str = "call";
            end

            ((opcode_i & `INST_JALR_MASK) == `INST_JALR) : // jalr
            begin
                dbg_inst_rb  = "-";
                dbg_inst_imm = `DBG_IMM_IMM12;

               if (ra_idx_w == 5'd1 && `DBG_IMM_IMM12 == 32'b0)
                    dbg_inst_str = "ret";
               else if (rd_idx_w == 5'd1)
                    dbg_inst_str = "call (R)";
            end

            // lb lh lw lbu lhu lwu
            ((opcode_i & `INST_LB_MASK) == `INST_LB) ,
            ((opcode_i & `INST_LH_MASK) == `INST_LH) ,
            ((opcode_i & `INST_LW_MASK) == `INST_LW) ,
            ((opcode_i & `INST_LBU_MASK) == `INST_LBU) ,
            ((opcode_i & `INST_LHU_MASK) == `INST_LHU) ,
            ((opcode_i & `INST_LWU_MASK) == `INST_LWU) :
            begin
                dbg_inst_rb  = "-";
                dbg_inst_imm = `DBG_IMM_IMM12;
            end 

            // sb sh sw
            ((opcode_i & `INST_SB_MASK) == `INST_SB) ,
            ((opcode_i & `INST_SH_MASK) == `INST_SH) ,
            ((opcode_i & `INST_SW_MASK) == `INST_SW) :
            begin
                dbg_inst_rd  = "-";
                dbg_inst_imm = `DBG_IMM_STOREIMM;
            end
        endcase        
    end
end
`endif

endmodule
//-----------------------------------------------------------------
//                         RISC-V Core
//                            V1.0.1
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                   admin@ultra-embedded.com
//
//                       License: BSD
//-----------------------------------------------------------------
//
// Copyright (c) 2014-2019, Ultra-Embedded.com
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions 
// are met:
//   - Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer 
//     in the documentation and/or other materials provided with the 
//     distribution.
//   - Neither the name of the author nor the names of its contributors 
//     may be used to endorse or promote products derived from this 
//     software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF 
// SUCH DAMAGE.
//-----------------------------------------------------------------
//-----------------------------------------------------------------
// Module - Xilinx register file (2 async read, 1 write port)
//-----------------------------------------------------------------
module riscv_xilinx_2r1w
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [  4:0]  rd0_i
    ,input  [ 31:0]  rd0_value_i
    ,input  [  4:0]  ra_i
    ,input  [  4:0]  rb_i

    // Outputs
    ,output [ 31:0]  ra_value_o
    ,output [ 31:0]  rb_value_o
);


//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
wire [31:0]     reg_rs1_w;
wire [31:0]     reg_rs2_w;
wire [31:0]     rs1_0_15_w;
wire [31:0]     rs1_16_31_w;
wire [31:0]     rs2_0_15_w;
wire [31:0]     rs2_16_31_w;
wire            write_enable_w;
wire            write_banka_w;
wire            write_bankb_w;

//-----------------------------------------------------------------
// Register File (using RAM16X1D )
//-----------------------------------------------------------------
genvar i;

// Registers 0 - 15
generate
for (i=0;i<32;i=i+1)
begin : reg_loop1
    RAM16X1D reg_bit1a(.WCLK(clk_i), .WE(write_banka_w), .A0(rd0_i[0]), .A1(rd0_i[1]), .A2(rd0_i[2]), .A3(rd0_i[3]), .D(rd0_value_i[i]), .DPRA0(ra_i[0]), .DPRA1(ra_i[1]), .DPRA2(ra_i[2]), .DPRA3(ra_i[3]), .DPO(rs1_0_15_w[i]), .SPO(/* open */));
    RAM16X1D reg_bit2a(.WCLK(clk_i), .WE(write_banka_w), .A0(rd0_i[0]), .A1(rd0_i[1]), .A2(rd0_i[2]), .A3(rd0_i[3]), .D(rd0_value_i[i]), .DPRA0(rb_i[0]), .DPRA1(rb_i[1]), .DPRA2(rb_i[2]), .DPRA3(rb_i[3]), .DPO(rs2_0_15_w[i]), .SPO(/* open */));
end
endgenerate

// Registers 16 - 31
generate
for (i=0;i<32;i=i+1)
begin : reg_loop2
    RAM16X1D reg_bit1b(.WCLK(clk_i), .WE(write_bankb_w), .A0(rd0_i[0]), .A1(rd0_i[1]), .A2(rd0_i[2]), .A3(rd0_i[3]), .D(rd0_value_i[i]), .DPRA0(ra_i[0]), .DPRA1(ra_i[1]), .DPRA2(ra_i[2]), .DPRA3(ra_i[3]), .DPO(rs1_16_31_w[i]), .SPO(/* open */));
    RAM16X1D reg_bit2b(.WCLK(clk_i), .WE(write_bankb_w), .A0(rd0_i[0]), .A1(rd0_i[1]), .A2(rd0_i[2]), .A3(rd0_i[3]), .D(rd0_value_i[i]), .DPRA0(rb_i[0]), .DPRA1(rb_i[1]), .DPRA2(rb_i[2]), .DPRA3(rb_i[3]), .DPO(rs2_16_31_w[i]), .SPO(/* open */));
end
endgenerate

//-----------------------------------------------------------------
// Combinatorial Assignments
//-----------------------------------------------------------------
assign reg_rs1_w       = (ra_i[4] == 1'b0) ? rs1_0_15_w : rs1_16_31_w;
assign reg_rs2_w       = (rb_i[4] == 1'b0) ? rs2_0_15_w : rs2_16_31_w;

assign write_enable_w = (rd0_i != 5'b00000);

assign write_banka_w  = (write_enable_w & (~rd0_i[4]));
assign write_bankb_w  = (write_enable_w & rd0_i[4]);

reg [31:0] ra_value_r;
reg [31:0] rb_value_r;

// Register read ports
always @ *
begin
    if (ra_i == 5'b00000)
        ra_value_r = 32'h00000000;
    else
        ra_value_r = reg_rs1_w;

    if (rb_i == 5'b00000)
        rb_value_r = 32'h00000000;
    else
        rb_value_r = reg_rs2_w;
end

assign ra_value_o = ra_value_r;
assign rb_value_o = rb_value_r;

endmodule

//-------------------------------------------------------------
// RAM16X1D: Verilator target RAM16X1D model
//-------------------------------------------------------------
`ifdef verilator
module RAM16X1D (DPO, SPO, A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE);

    parameter INIT = 16'h0000;

    output DPO, SPO;

    input  A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE;

    reg  [15:0] mem;
    wire [3:0] adr;

    assign adr = {A3, A2, A1, A0};
    assign SPO = mem[adr];
    assign DPO = mem[{DPRA3, DPRA2, DPRA1, DPRA0}];

    initial 
        mem = INIT;

    always @(posedge WCLK) 
        if (WE == 1'b1)
            mem[adr] <= D;

endmodule
`endif
