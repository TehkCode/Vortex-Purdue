onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /VX_local_mem_tb/clk
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/CORE_ID}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/busy}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/join_else}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/join_pc}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/join_tmask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/active_warps}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/active_warps_n}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/stalled_warps}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/thread_masks}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/warp_pcs}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/barrier_masks}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/reached_barrier_limit}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/wspawn_pc}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/use_wspawn}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/schedule_wid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/schedule_tmask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/schedule_pc}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/schedule_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/warp_scheduled}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/issued_instrs}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/ifetch_req_fire}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/tmc_active}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/active_barrier_count}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/barrier_mask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/barrier_stalls}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/ipdom_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/ipdom_index}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/ready_warps}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/schedule_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/stall_out}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -group {Warp Sched} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/warp_sched/instr_uuid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/addr}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/uuid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/tmask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/wid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/PC}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/uuid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/tmask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/wid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/PC}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group req_metadata {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/req_metadata/wren}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group req_metadata {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/req_metadata/waddr}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group req_metadata {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/req_metadata/wdata}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group req_metadata {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/req_metadata/raddr}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group req_metadata {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/req_metadata/rdata}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group pipe_reg {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/pipe_reg/enable}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group pipe_reg {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/pipe_reg/data_in}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group {I-cache Stage} -expand -group pipe_reg {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/icache_stage/pipe_reg/data_out}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/CORE_ID}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_rw}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_byteen}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_addr}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/busy}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/CLUSTER_ID}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_rw}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_byteen}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_addr}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/busy}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_rw}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_byteen}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_addr}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_busy}
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/clk
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/reset
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_valid_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_tag_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_addr_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_rw_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_byteen_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_data_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_ready_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_valid_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_tag_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_addr_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_rw_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_byteen_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_data_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_ready_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_valid_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_tag_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_data_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_ready_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_valid_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_tag_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_data_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_ready_out
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_rw
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_addr
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/busy
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_rw
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_addr
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_busy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {114 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 93
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
WaveRestoreZoom {0 ns} {861 ns}
