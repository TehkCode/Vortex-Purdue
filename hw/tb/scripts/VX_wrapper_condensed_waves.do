onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Vortex_wrapper_condensed_tb/test_case
add wave -noupdate /Vortex_wrapper_condensed_tb/sub_test_case
add wave -noupdate /Vortex_wrapper_condensed_tb/num_errors
add wave -noupdate /Vortex_wrapper_condensed_tb/delay
add wave -noupdate /Vortex_wrapper_condensed_tb/cycle_count
add wave -noupdate /Vortex_wrapper_condensed_tb/poll_period
add wave -noupdate /Vortex_wrapper_condensed_tb/program_terminated
add wave -noupdate /Vortex_wrapper_condensed_tb/clk
add wave -noupdate /Vortex_wrapper_condensed_tb/nRST
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_valid
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_rw
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_byteen
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_addr
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_data
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_tag
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_req_ready
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_rsp_valid
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_rsp_data
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_rsp_tag
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_mem_rsp_ready
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_busy
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_reset
add wave -noupdate /Vortex_wrapper_condensed_tb/Vortex_PC_reset_val
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_Vortex_mem_req_ready
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_Vortex_mem_rsp_valid
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_Vortex_mem_rsp_data
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_Vortex_mem_rsp_tag
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_mem_slave_bpif_rdata
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_mem_slave_bpif_error
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_mem_slave_bpif_request_stall
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ctrl_status_bpif_rdata
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ctrl_status_bpif_error
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ctrl_status_bpif_request_stall
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_Vortex_reset
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_Vortex_PC_reset_val
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HWRITE
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HTRANS
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HSIZE
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HADDR
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HWDATA
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HWSTRB
add wave -noupdate /Vortex_wrapper_condensed_tb/expected_ahb_manager_ahbif_HSEL
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4156292 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4509921 ps}
