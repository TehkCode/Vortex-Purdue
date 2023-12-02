onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /local_mem_tb/PROG/clk
add wave -noupdate /local_mem_tb/PROG/reset
add wave -noupdate -expand -group {TB Signals} -radix unsigned /local_mem_tb/PROG/test_num
add wave -noupdate -expand -group {TB Signals} /local_mem_tb/PROG/test_string
add wave -noupdate -expand -group {TB Signals} /local_mem_tb/PROG/task_string
add wave -noupdate -expand -group {TB Signals} -color Gold -radix binary /local_mem_tb/PROG/testing
add wave -noupdate -expand -group {TB Signals} -color Red -radix binary /local_mem_tb/PROG/error
add wave -noupdate -expand -group {TB Signals} -radix unsigned /local_mem_tb/PROG/num_errors
add wave -noupdate -expand -group {TB Signals} /local_mem_tb/PROG/tb_control_ram
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_req_valid
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_req_rw
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_req_byteen
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_req_addr
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_req_data
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_req_tag
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/mem_rsp_ready
add wave -noupdate -expand -group {Input Signals} /local_mem_tb/PROG/busy
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/expected_mem_req_ready
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/mem_req_ready
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/expected_mem_rsp_valid
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/mem_rsp_valid
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/expected_mem_rsp_data
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/mem_rsp_data
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/expected_mem_rsp_tag
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/mem_rsp_tag
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/expected_tb_addr_out_of_bounds
add wave -noupdate -expand -group {Output Signals} /local_mem_tb/PROG/tb_addr_out_of_bounds
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wen_0_80000000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wsel_0_80000000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wdata_0_80000000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/rsel_0_80000000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/rdata_0_80000000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wen_1_80001000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wsel_1_80001000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wdata_1_80001000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/rsel_1_80001000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/rdata_1_80001000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wen_2_80002000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wsel_2_80002000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/wdata_2_80002000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/rsel_2_80002000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/rdata_2_80002000
add wave -noupdate -expand -group {Internal Signals} /local_mem_tb/DUT/chunk_sel
add wave -noupdate -expand -group {Reg File Signals} /local_mem_tb/DUT/reg_val_0_80000000
add wave -noupdate -expand -group {Reg File Signals} /local_mem_tb/DUT/next_reg_val_0_80000000
add wave -noupdate -expand -group {Reg File Signals} /local_mem_tb/DUT/reg_val_1_80001000
add wave -noupdate -expand -group {Reg File Signals} /local_mem_tb/DUT/next_reg_val_1_80001000
add wave -noupdate -expand -group {Reg File Signals} /local_mem_tb/DUT/reg_val_2_80002000
add wave -noupdate -expand -group {Reg File Signals} /local_mem_tb/DUT/next_reg_val_2_80002000
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {62 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 219
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
WaveRestoreZoom {26 ns} {96 ns}
