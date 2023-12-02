onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Vortex_wrapper_no_Vortex_condensed_tb/test_case
add wave -noupdate /Vortex_wrapper_no_Vortex_condensed_tb/sub_test_case
add wave -noupdate /Vortex_wrapper_no_Vortex_condensed_tb/num_errors
add wave -noupdate /Vortex_wrapper_no_Vortex_condensed_tb/clk
add wave -noupdate /Vortex_wrapper_no_Vortex_condensed_tb/nRST
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_valid
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_rw
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_byteen
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_addr
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_data
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_tag
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_req_ready
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_rsp_valid
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_rsp_data
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_rsp_tag
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_mem_rsp_ready
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_busy
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_reset
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/Vortex_PC_reset_val
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_Vortex_mem_req_ready
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_Vortex_mem_rsp_valid
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_Vortex_mem_rsp_data
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_Vortex_mem_rsp_tag
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_mem_slave_bpif_rdata
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_mem_slave_bpif_error
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_mem_slave_bpif_request_stall
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ctrl_status_bpif_rdata
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ctrl_status_bpif_error
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ctrl_status_bpif_request_stall
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_Vortex_reset
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_Vortex_PC_reset_val
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HWRITE
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HTRANS
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HSIZE
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HADDR
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HWDATA
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HWSTRB
add wave -noupdate -expand -group {tb level signals} /Vortex_wrapper_no_Vortex_condensed_tb/expected_ahb_manager_ahbif_HSEL
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/wen
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/ren
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/request_stall
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/addr
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/error
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/strobe
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/wdata
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/rdata
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/is_burst
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/burst_type
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/burst_length
add wave -noupdate -expand -group {Vortex_mem_slave bpif} /Vortex_wrapper_no_Vortex_condensed_tb/mem_slave_bpif/secure_transfer
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/wen
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/ren
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/request_stall
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/addr
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/error
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/strobe
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/wdata
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/rdata
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/is_burst
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/burst_type
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/burst_length
add wave -noupdate -expand -group {CTRL/Status bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ctrl_status_bpif/secure_transfer
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HCLK
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HRESETn
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HSEL
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HREADY
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HREADYOUT
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HWRITE
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HMASTLOCK
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HRESP
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HTRANS
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HBURST
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HSIZE
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HADDR
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HWDATA
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HRDATA
add wave -noupdate -expand -group {VX_ahb_adapter bpif} /Vortex_wrapper_no_Vortex_condensed_tb/ahb_manager_ahbif/HWSTRB
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/clk
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/nRST
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_valid
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_rw
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_byteen
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_addr
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_data
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_tag
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_req_ready
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_rsp_valid
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_rsp_data
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_rsp_tag
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/mem_rsp_ready
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/busy
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/Vortex_bad_address
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/AHB_bad_address
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/next_mem_rsp_valid
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/next_mem_rsp_data
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/next_mem_rsp_tag
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/reg_file_chunk_read_en
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/reg_file_chunk_read_val
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/reg_file_chunk_write_en
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/reg_file_chunk_write_val
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/reg_file_chunk_addr
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/wordwise_512_reg_file_read
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/bytewise_512_reg_file_write
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/bytewise_512_reg_file_read
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/bytewise_512_mem_req_data
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/bytewise_32_bpif_wdata
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/reg_file
add wave -noupdate -expand -group {Vortex_mem_slave Internal Signals} /Vortex_wrapper_no_Vortex_condensed_tb/DUT/genblk1/mem_slave/next_reg_file
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {354 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 275
configure wave -valuecolwidth 129
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
WaveRestoreZoom {268 ns} {362 ns}
