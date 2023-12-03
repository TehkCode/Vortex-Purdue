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
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/id_ex_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/id_ex_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf.PC
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf.PC_nxt
add wave -noupdate /system_tb/DUT/CPU/DP/halt_ff
add wave -noupdate /system_tb/DUT/CPU/DP/s_type_ins_mem
add wave -noupdate /system_tb/DUT/CPU/DP/if_id_intf
add wave -noupdate /system_tb/DUT/CPU/DP/id_ex_intf
add wave -noupdate /system_tb/DUT/CPU/DP/ex_mem_intf
add wave -noupdate /system_tb/DUT/CPU/DP/mem_wr_intf
add wave -noupdate -divider {Ram signals}
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate -divider dcif
add wave -noupdate /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate /system_tb/DUT/CPU/dcif/halt
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/dcif/datomic
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -divider ctrlunt
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/ALUSrc
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/MemWr
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/MemtoReg
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/dmemREN
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/imemREN
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/halt
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/rs1
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/rs2
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/rd
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/ins
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/imm
add wave -noupdate /system_tb/DUT/CPU/DP/ctrlunt/ALUOp
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/alu_imm
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/r_ins
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/i_ins
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/s_ins
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/u_ins
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/s_imm
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/b_imm
add wave -noupdate /system_tb/DUT/CPU/DP/CTRLUNT/jal_imm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {120757 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
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
WaveRestoreZoom {0 ps} {488372 ps}
