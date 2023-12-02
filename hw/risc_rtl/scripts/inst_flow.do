onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPU/DP/IF_ID/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/IF_ID/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/IF_ID/if_id_intf/ins_in
add wave -noupdate /system_tb/DUT/CPU/DP/IF_ID/if_id_intf/ins_out
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/id_ex_intf/ins_out
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf/ins_out
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf/ins_out
add wave -noupdate /system_tb/DUT/CPU/DP/IF_ID/if_id_intf/PC_nxt_out
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/id_ex_intf/PC_nxt_out
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf/PC_nxt_out
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf/PC_nxt_out
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf/dmemREN_in
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf/imemREN_in
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf/Rt_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {356100 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {212500 ps} {462500 ps}
