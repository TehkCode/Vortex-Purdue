#ifndef _COMMON_H_
#define _COMMON_H_

#define KERNEL_ARG_DEV_MEM_ADDR 0x7ffff000

#ifndef TYPE
#define TYPE uint64_t
#endif

typedef struct {
  uint32_t num_tasks_nonpriority;
  uint32_t task_size;
  uint64_t src0_addr;
  uint64_t src1_addr;
  uint64_t dst_addr;

  uint32_t num_tasks_priority;
  //uint32_t priority_task_offset; // Thread number of where the priority tasks start
} kernel_arg_t;

#define VXX_CSR_RASTER_BEGIN             0x7c0
#define VXX_CSR_RASTER_POS_MASK          (VXX_CSR_RASTER_BEGIN+0)
#define VXX_CSR_RASTER_BCOORD_X0         (VXX_CSR_RASTER_BEGIN+1)
#define VXX_CSR_RASTER_BCOORD_X1         (VXX_CSR_RASTER_BEGIN+2)
#define VXX_CSR_RASTER_BCOORD_X2         (VXX_CSR_RASTER_BEGIN+3)
#define VXX_CSR_RASTER_BCOORD_X3         (VXX_CSR_RASTER_BEGIN+4)
#define VXX_CSR_RASTER_BCOORD_Y0         (VXX_CSR_RASTER_BEGIN+5)
#define VXX_CSR_RASTER_BCOORD_Y1         (VXX_CSR_RASTER_BEGIN+6)
#define VXX_CSR_RASTER_BCOORD_Y2         (VXX_CSR_RASTER_BEGIN+7)
#define VXX_CSR_RASTER_BCOORD_Y3         (VXX_CSR_RASTER_BEGIN+8)
#define VXX_CSR_RASTER_BCOORD_Z0         (VXX_CSR_RASTER_BEGIN+9)
#define VXX_CSR_RASTER_BCOORD_Z1         (VXX_CSR_RASTER_BEGIN+10)
#define VXX_CSR_RASTER_BCOORD_Z2         (VXX_CSR_RASTER_BEGIN+11)
#define VXX_CSR_RASTER_BCOORD_Z3         (VXX_CSR_RASTER_BEGIN+12)
#define VXX_CSR_RASTER_END               (VXX_CSR_RASTER_BEGIN+13)
#define VXX_CSR_RASTER_COUNT             (VXX_CSR_RASTER_END-VXX_CSR_RASTER_BEGIN)

// ROP unit CSRs

#define VXX_CSR_ROP_BEGIN                VXX_CSR_RASTER_END
#define VXX_CSR_ROP_RT_IDX               (VXX_CSR_ROP_BEGIN+0)
#define VXX_CSR_ROP_SAMPLE_IDX           (VXX_CSR_ROP_BEGIN+1)
#define VXX_CSR_ROP_END                  (VXX_CSR_ROP_BEGIN+2)
#define VXX_CSR_ROP_COUNT                (VXX_CSR_ROP_END-VXX_CSR_ROP_BEGIN)

// Texture unit CSRs

#define VXX_CSR_TEX_BEGIN                VXX_CSR_ROP_END
#define VXX_CSR_TEX_END                  (VXX_CSR_TEX_BEGIN+0)
#define VXX_CSR_TEX_COUNT                (VXX_CSR_TEX_END-VXX_CSR_TEX_BEGIN)

// #define VXX_HW_ITR_CTRL_BEGIN (VXX_CSR_TEX_END+1)
// #define VXX_HW_ITR_S2V        (VXX_HW_ITR_CTRL_BEGIN+0)
// #define VXX_HW_ITR_V2S        (VXX_HW_ITR_CTRL_BEGIN+1)
// #define VXX_HW_ITR_TID        (VXX_HW_ITR_CTRL_BEGIN+2)
// #define VXX_HW_ITR_IPC        (VXX_HW_ITR_CTRL_BEGIN+3)
// #define VXX_HW_ITR_IRQ        (VXX_HW_ITR_CTRL_BEGIN+4)
// #define VXX_HW_ITR_ACC        (VXX_HW_ITR_CTRL_BEGIN+5)
// #define VXX_HW_ITR_ERR        (VXX_HW_ITR_CTRL_BEGIN+6)
// #define VXX_HW_ITR_R1         (VXX_HW_ITR_CTRL_BEGIN+7)
// #define VXX_HW_ITR_R2         (VXX_HW_ITR_CTRL_BEGIN+8)
// #define VXX_HW_ITR_R3         (VXX_HW_ITR_CTRL_BEGIN+9)
// #define VXX_HW_ITR_R4         (VXX_HW_ITR_CTRL_BEGIN+10)
// #define VXX_HW_ITR_R5         (VXX_HW_ITR_CTRL_BEGIN+11)
// #define VXX_HW_ITR_R6         (VXX_HW_ITR_CTRL_BEGIN+12)
// #define VXX_HW_ITR_R7         (VXX_HW_ITR_CTRL_BEGIN+13)
// #define VXX_HW_ITR_R8         (VXX_HW_ITR_CTRL_BEGIN+14)
// #define VXX_HW_ITR_R9         (VXX_HW_ITR_CTRL_BEGIN+15)
// #define VXX_HW_ITR_R10        (VXX_HW_ITR_CTRL_BEGIN+16)
// #define VXX_HW_ITR_R11        (VXX_HW_ITR_CTRL_BEGIN+17)
// #define VXX_HW_ITR_R12        (VXX_HW_ITR_CTRL_BEGIN+18)
// #define VXX_HW_ITR_R13        (VXX_HW_ITR_CTRL_BEGIN+19)
// #define VXX_HW_ITR_R14        (VXX_HW_ITR_CTRL_BEGIN+20)
// #define VXX_HW_ITR_R15        (VXX_HW_ITR_CTRL_BEGIN+21)
// #define VXX_HW_ITR_R16        (VXX_HW_ITR_CTRL_BEGIN+22)
// #define VXX_HW_ITR_R17        (VXX_HW_ITR_CTRL_BEGIN+23)
// #define VXX_HW_ITR_R18        (VXX_HW_ITR_CTRL_BEGIN+24)
// #define VXX_HW_ITR_R19        (VXX_HW_ITR_CTRL_BEGIN+25)
// #define VXX_HW_ITR_R20        (VXX_HW_ITR_CTRL_BEGIN+26)
// #define VXX_HW_ITR_R21        (VXX_HW_ITR_CTRL_BEGIN+27)
// #define VXX_HW_ITR_R22        (VXX_HW_ITR_CTRL_BEGIN+28)
// #define VXX_HW_ITR_R23        (VXX_HW_ITR_CTRL_BEGIN+29)
// #define VXX_HW_ITR_R24        (VXX_HW_ITR_CTRL_BEGIN+30)
// #define VXX_HW_ITR_R25        (VXX_HW_ITR_CTRL_BEGIN+31)
// #define VXX_HW_ITR_R26        (VXX_HW_ITR_CTRL_BEGIN+32)
// #define VXX_HW_ITR_R27        (VXX_HW_ITR_CTRL_BEGIN+33)
// #define VXX_HW_ITR_R28        (VXX_HW_ITR_CTRL_BEGIN+34)
// #define VXX_HW_ITR_R29        (VXX_HW_ITR_CTRL_BEGIN+35)
// #define VXX_HW_ITR_R30        (VXX_HW_ITR_CTRL_BEGIN+36)
// #define VXX_HW_ITR_R31        (VXX_HW_ITR_CTRL_BEGIN+37)
// #define VXX_HW_ITR_JALOL      (VXX_HW_ITR_CTRL_BEGIN+38)
// #define VXX_HW_ITR_RHA        (VXX_HW_ITR_CTRL_BEGIN+39)
// #define VXX_HW_ITR_ACCEND     (VXX_HW_ITR_CTRL_BEGIN+40)
// #define VXX_HW_ITR_RAV        (VXX_HW_ITR_CTRL_BEGIN+41)
// #define VXX_HW_ITR_RAS        (VXX_HW_ITR_CTRL_BEGIN+42)
// #define VXX_HW_ITR_SSP        (VXX_HW_ITR_CTRL_BEGIN+43)
// #define VXX_HW_ITR_RAVW0      (VXX_HW_ITR_CTRL_BEGIN+44)
// #define VXX_HW_ITR_LTID       (VXX_HW_ITR_CTRL_BEGIN+45)
// #define VXX_HW_ITR_LWID       (VXX_HW_ITR_CTRL_BEGIN+46)
// #define VXX_HW_ITR_CTRL_END   (VXX_HW_ITR_CTRL_BEGIN+47)
// #define VXX_HW_ITR_COUNT     (VXX_HW_ITR_CTRL_BEGIN-VXX_HW_ITR_CTRL_END)

#endif
