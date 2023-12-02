onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf.ins
add wave -noupdate /system_tb/DUT/CPU/DP/id_ex_intf.ins
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf.ins
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf.ins
add wave -noupdate /system_tb/DUT/CPU/DP/PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/PC
add wave -noupdate /system_tb/DUT/CPU/DP/br_pd/Wr_enable
add wave -noupdate /system_tb/DUT/CPU/DP/br_pd/is_taken
add wave -noupdate /system_tb/DUT/CPU/DP/br_pd/predicted_PC
add wave -noupdate /system_tb/DUT/CPU/DP/br_pd/current_PC
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP/BRPD/btb_index
add wave -noupdate /system_tb/DUT/CPU/DP/br_pd/update_PC
add wave -noupdate /system_tb/DUT/CPU/DP/br_pd/update_target_PC
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP/BRPD/update_btb_index
add wave -noupdate /system_tb/DUT/CPU/DP/r_type_ins_mem.opcode
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/id_ex_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/id_ex_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/BRPD/btb_target
add wave -noupdate /system_tb/DUT/CPU/DP/BRPD/btb_tag
add wave -noupdate -radix binary -childformat {{{/system_tb/DUT/CPU/DP/BRPD/counter[0]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[1]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[2]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[3]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[4]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[5]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[6]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[7]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[8]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[9]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[10]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[11]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[12]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[13]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[14]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[15]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[16]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[17]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[18]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[19]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[20]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[21]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[22]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[23]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[24]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[25]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[26]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[27]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[28]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[29]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[30]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[31]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[32]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[33]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[34]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[35]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[36]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[37]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[38]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[39]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[40]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[41]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[42]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[43]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[44]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[45]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[46]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[47]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[48]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[49]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[50]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[51]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[52]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[53]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[54]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[55]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[56]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[57]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[58]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[59]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[60]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[61]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[62]} -radix binary} {{/system_tb/DUT/CPU/DP/BRPD/counter[63]} -radix binary}} -subitemconfig {{/system_tb/DUT/CPU/DP/BRPD/counter[0]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[1]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[2]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[3]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[4]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[5]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[6]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[7]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[8]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[9]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[10]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[11]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[12]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[13]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[14]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[15]} {-height 16 -radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[16]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[17]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[18]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[19]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[20]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[21]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[22]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[23]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[24]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[25]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[26]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[27]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[28]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[29]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[30]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[31]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[32]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[33]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[34]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[35]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[36]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[37]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[38]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[39]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[40]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[41]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[42]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[43]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[44]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[45]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[46]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[47]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[48]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[49]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[50]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[51]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[52]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[53]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[54]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[55]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[56]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[57]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[58]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[59]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[60]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[61]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[62]} {-radix binary} {/system_tb/DUT/CPU/DP/BRPD/counter[63]} {-radix binary}} /system_tb/DUT/CPU/DP/BRPD/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {813307 ps} 0}
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
WaveRestoreZoom {750 ns} {1250 ns}
