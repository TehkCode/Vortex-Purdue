#include <stdint.h>
#include <vx_intrinsics.h>
#include <vx_spawn.h>
#include <vx_print.h>
#include "common.h"

void kernel_body(int task_id, kernel_arg_t* __UNIFORM__ arg) {
	uint32_t count    = arg->task_size;
	int32_t* src0_ptr = (int32_t*)arg->src0_addr;
	int32_t* src1_ptr = (int32_t*)arg->src1_addr;
	int32_t* dst_ptr  = (int32_t*)arg->dst_addr;
	
	uint32_t offset = task_id * count;

	for (uint32_t i = 0; i < count; ++i) {
		dst_ptr[offset+i] = src0_ptr[offset+i] + src1_ptr[offset+i];
	}
}

// void kernel_body_private(int task_id, kernel_arg_t* __UNIFORM__ arg) {
// 	uint32_t count    = arg->task_size;
// 	int32_t* src0_ptr = (int32_t*)arg->src0_addr;
// 	int32_t* src1_ptr = (int32_t*)arg->src1_addr;
// 	int32_t* dst_ptr  = (int32_t*)arg->dst_addr;
	
// 	uint32_t offset = task_id * count;

// 	for (uint32_t i = 0; i < count; ++i) {
// 		dst_ptr[offset+i] = src0_ptr[offset+i] + src1_ptr[offset+i];
// 	}
// }

int main() {
	kernel_arg_t* arg = (kernel_arg_t*)KERNEL_ARG_DEV_MEM_ADDR;
	// kernel_arg_t* arg = (kernel_arg_t*)KERNEL_ARG_DEV_MEM_ADDR2;
	vx_printf("Calling VXSpawn\n");
	vx_spawn_tasks(arg->num_tasks, (vx_spawn_tasks_cb)kernel_body, arg);
	vx_printf("Calling VXPSpawn\n");
	vx_spawn_priority_tasks(arg->num_tasks, (vx_spawn_tasks_cb)kernel_body, arg);
	return 0;
}
