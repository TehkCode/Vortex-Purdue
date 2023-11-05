onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /VX_local_mem_tb/clk
add wave -noupdate /VX_local_mem_tb/reset
add wave -noupdate -divider {Vortex Signals}
add wave -noupdate -expand -group Vortex -divider Inputs
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_tag
add wave -noupdate -expand -group Vortex -divider Outputs
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_rw
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_addr
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/busy
add wave -noupdate -expand -group Vortex -divider {ICACHE RAM}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/CACHE_ID}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/BANK_ID}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/data_store/genblk1/genblk1/genblk1/genblk1/ram}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/data_store/addr}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/data_store/wren}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/data_store/wdata}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/icache/genblk5[0]/bank/data_access/data_store/rdata}
add wave -noupdate -expand -group Vortex -divider {DCACHE RAM}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/CACHE_ID}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/BANK_ID}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/data_store/genblk1/genblk1/genblk1/genblk1/ram}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/data_store/addr}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/data_store/wren}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/data_store/wdata}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_unit/dcache/genblk5[3]/bank/data_access/data_store/rdata}
add wave -noupdate -divider MEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 296
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
WaveRestoreZoom {29957 ps} {30003 ps}
