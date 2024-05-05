#include <stdint.h>
#include <vx_intrinsics.h>
#include <vx_spawn.h>
#include "common.h"
#include "vx_print.h"
#include <stdlib.h>

void kernel_body(int task_id, kernel_arg_t* __UNIFORM__ arg) {
	auto src0_ptr = reinterpret_cast<TYPE*>(arg->src0_addr);
	auto src1_ptr = reinterpret_cast<TYPE*>(arg->src1_addr);
	auto dst_ptr = reinterpret_cast<TYPE*>(arg->dst_addr);


	uint32_t count = arg->task_size;
	uint32_t offset = task_id * count;


	// int y = 0xf00d1111;
	// csr_write(VXX_HW_ITR_S2V, y);
	// int x = csr_read(VXX_HW_ITR_S2V);
	// // vx_printf("The value I am reading from VX_HW_ITR_S2V is: 0x%x\n", x);
	// // vx_printf("The value I am reading from VX_HW_ITR_V2S is: 0x%x\n", x);
	// // vx_printf("The value I am reading from VX_HW_ITR_V2S is: 0x%x\n", x);
	// // vx_printf("The value I am reading from VX_HW_ITR_V2S is: 0x%x\n", x);


	// y = 0xf00d2222;
	// csr_write(VXX_HW_ITR_V2S, y);
	// x = csr_read(VXX_HW_ITR_V2S);
	// // vx_printf("The value I am reading from VX_HW_ITR_V2S is: 0x%x\n", x);

	// y = 0xf00d3333;
	// csr_write(VXX_HW_ITR_R1, y);
	// x = csr_read(VXX_HW_ITR_R1);
	// // vx_printf("The value I am reading from VX_HW_ITR_R1 is: 0x%x\n", x);

	// y = 0xf00d4444;
	// csr_write(VXX_HW_ITR_R31, y);
	// x = csr_read(VXX_HW_ITR_R31);
	// // vx_printf("The value I am reading from VX_HW_ITR_R31 is: 0x%x\n", x);

	for (uint32_t i = 0; i < count; ++i) {
		dst_ptr[offset+i] = src0_ptr[offset+i] + src1_ptr[offset+i];
	}

}


int main() {
    kernel_arg_t* arg = (kernel_arg_t*)KERNEL_ARG_DEV_MEM_ADDR;
    // kernel_arg_t* arg = (kernel_arg_t*)KERNEL_ARG_DEV_MEM_ADDR2;
    vx_spawn_tasks(arg->num_tasks_nonpriority, (vx_spawn_tasks_cb)kernel_body, arg);
    vx_spawn_priority_tasks(arg->num_tasks_priority,arg->num_tasks_nonpriority, (vx_spawn_tasks_cb)kernel_body, arg);
    return 0;
}
