onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /VX_ahb_adapter_tb/prog/tests
add wave -noupdate -radix unsigned /VX_ahb_adapter_tb/prog/fails
add wave -noupdate -radix unsigned /VX_ahb_adapter_tb/prog/test_num
add wave -noupdate /VX_ahb_adapter_tb/prog/test_case
add wave -noupdate -divider System
add wave -noupdate /VX_ahb_adapter_tb/prog/CLK
add wave -noupdate /VX_ahb_adapter_tb/prog/nRST
add wave -noupdate -divider {AHB inputs}
add wave -noupdate /VX_ahb_adapter_tb/ahbif/HREADYOUT
add wave -noupdate /VX_ahb_adapter_tb/ahbif/HRESP
add wave -noupdate /VX_ahb_adapter_tb/ahbif/HRDATA
add wave -noupdate /VX_ahb_adapter_tb/prog/ahb_buffer
add wave -noupdate -divider {AHB outputs}
add wave -noupdate -expand -group HSEL -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_HSEL
add wave -noupdate -expand -group HSEL /VX_ahb_adapter_tb/ahbif/HSEL
add wave -noupdate -expand -group HWRITE -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_HWRITE
add wave -noupdate -expand -group HWRITE /VX_ahb_adapter_tb/ahbif/HWRITE
add wave -noupdate -expand -group HSIZE -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_HSIZE
add wave -noupdate -expand -group HSIZE /VX_ahb_adapter_tb/ahbif/HSIZE
add wave -noupdate -expand -group HADDR -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_HADDR
add wave -noupdate -expand -group HADDR /VX_ahb_adapter_tb/ahbif/HADDR
add wave -noupdate -expand -group HWDATA -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_HWDATA
add wave -noupdate -expand -group HWDATA /VX_ahb_adapter_tb/ahbif/HWDATA
add wave -noupdate -expand -group HWSTRB -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_HWSTRB
add wave -noupdate -expand -group HWSTRB /VX_ahb_adapter_tb/ahbif/HWSTRB
add wave -noupdate -divider {VX inputs}
add wave -noupdate /VX_ahb_adapter_tb/mreqif/valid
add wave -noupdate /VX_ahb_adapter_tb/mreqif/rw
add wave -noupdate /VX_ahb_adapter_tb/mreqif/byteen
add wave -noupdate /VX_ahb_adapter_tb/mreqif/addr
add wave -noupdate /VX_ahb_adapter_tb/mreqif/data
add wave -noupdate /VX_ahb_adapter_tb/mreqif/tag
add wave -noupdate /VX_ahb_adapter_tb/mreqif/ready
add wave -noupdate -divider {VX outputs}
add wave -noupdate -expand -group req_ready /VX_ahb_adapter_tb/prog/expected_req_ready
add wave -noupdate -expand -group req_ready /VX_ahb_adapter_tb/prog/mreqif/ready
add wave -noupdate -expand -group rsp_valid -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_rsp_valid
add wave -noupdate -expand -group rsp_valid /VX_ahb_adapter_tb/mrspif/valid
add wave -noupdate -expand -group rsp_data -color {Cornflower Blue} /VX_ahb_adapter_tb/prog/expected_rsp_data
add wave -noupdate -expand -group rsp_data /VX_ahb_adapter_tb/mrspif/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {132 ns} 0}
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
WaveRestoreZoom {36 ns} {314 ns}
