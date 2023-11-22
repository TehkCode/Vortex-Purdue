onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Vortex_wrapper_tb/test_case
add wave -noupdate /Vortex_wrapper_tb/sub_test_case
add wave -noupdate /Vortex_wrapper_tb/num_errors
add wave -noupdate -radix decimal /Vortex_wrapper_tb/cycle_count
add wave -noupdate /Vortex_wrapper_tb/clk
add wave -noupdate /Vortex_wrapper_tb/nRST
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_reset
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/expected_Vortex_reset
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_busy
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_PC_reset_val
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/expected_Vortex_PC_reset_val
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_valid
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_rw
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_byteen
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_addr
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_data
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_tag
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_req_ready
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/expected_Vortex_mem_req_ready
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/expected_Vortex_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_rsp_data
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/expected_Vortex_mem_rsp_data
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/expected_Vortex_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Side Signals} /Vortex_wrapper_tb/Vortex_mem_rsp_ready
add wave -noupdate -expand -group {Vortex Internal Signals} {/Vortex_wrapper_tb/Vortex_Instance/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/warp_pcs}
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/wen
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/ren
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/request_stall
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/expected_mem_slave_bpif_request_stall
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/addr
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/error
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/expected_mem_slave_bpif_error
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/strobe
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/wdata
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/mem_slave_bpif/rdata
add wave -noupdate -expand -group {Vortex_mem_slave AHB Side Signals} /Vortex_wrapper_tb/expected_mem_slave_bpif_rdata
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/wen
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/ren
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/request_stall
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/expected_ctrl_status_bpif_request_stall
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/addr
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/error
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/expected_ctrl_status_bpif_error
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/strobe
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/wdata
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/ctrl_status_bpif/rdata
add wave -noupdate -expand -group {CTRL/Status AHB Side Signals} /Vortex_wrapper_tb/expected_ctrl_status_bpif_rdata
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HCLK
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HRESETn
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HSEL
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HSEL
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HREADYOUT
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HWRITE
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HWRITE
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HRESP
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HTRANS
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HTRANS
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HSIZE
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HSIZE
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HADDR
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HADDR
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HWDATA
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HWDATA
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HRDATA
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/ahb_manager_ahbif/HWSTRB
add wave -noupdate -expand -group {VX_ahb_adapter AHB Side Signals} /Vortex_wrapper_tb/expected_ahb_manager_ahbif_HWSTRB
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/clk
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/nRST
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_valid
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_rw
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_byteen
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_addr
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_data
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_tag
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_req_ready
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_rsp_valid
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_rsp_data
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_rsp_tag
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_mem_rsp_ready
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_busy
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_reset
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/Vortex_PC_reset_val
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_valid
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_rw
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_byteen
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_addr
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_data
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_tag
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_req_ready
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_rsp_valid
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_rsp_data
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_rsp_tag
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_slave_mem_rsp_ready
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_valid
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_rw
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_byteen
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_addr
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_data
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_tag
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_req_ready
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_rsp_valid
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_rsp_data
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_rsp_tag
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ahb_manager_mem_rsp_ready
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_rsp_valid_buffer
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/next_mem_rsp_valid_buffer
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_rsp_data_buffer
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/next_mem_rsp_data_buffer
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/mem_rsp_tag_buffer
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/next_mem_rsp_tag_buffer
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/double_mem_rsp
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ctrl_status_busy
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/next_ctrl_status_busy
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ctrl_status_start_triggered
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ctrl_status_PC_reset_val
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/next_ctrl_status_PC_reset_val
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/ctrl_status_reset_state
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/next_ctrl_status_reset_state
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/inside_Vortex_mem_slave_space
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/inside_VX_ahb_adapter_space
add wave -noupdate -expand -group {Wrapper Internal Signals} /Vortex_wrapper_tb/Vortex_wrapper_no_Vortex_Instance/between_Vortex_mem_slave_VX_ahb_adapter_space
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30954920 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 323
configure wave -valuecolwidth 160
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
WaveRestoreZoom {0 ps} {129946175 ps}
