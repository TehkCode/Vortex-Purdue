#ifndef _COMMON_H_
#define _COMMON_H_

#define KERNEL_ARG_DEV_MEM_ADDR 0x7ffff000

// typedef struct {
//   uint32_t num_tasks;
//   uint32_t task_size;
//   uint64_t src0_addr;
//   uint64_t src1_addr;
//   uint64_t dst_addr;  

// } kernel_arg_t;

typedef struct {
  uint32_t num_tasks_nonpriority;
  uint32_t task_size;
  uint64_t src0_addr;
  uint64_t src1_addr;
  uint64_t dst_addr;

  uint32_t num_tasks_priority;
  //uint32_t priority_task_offset; // Thread number of where the priority tasks start
} kernel_arg_t;

#endif