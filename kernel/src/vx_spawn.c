#include <vx_spawn.h>
#include <vx_intrinsics.h>
#include <inttypes.h>
#include <vx_csr_defs.h>
#include <vx_print.h>

#ifdef __cplusplus
extern "C"
{
#endif

#define NUM_CORES_MAX 1024

#ifndef MIN
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif

void interrupt_simt_handler();
void return_handler();
void (*return_handler_ptr)();
void (*interrupt_simt_handler_ptr)();

typedef struct
{
    vx_spawn_tasks_cb callback;
    void *arg;
    int offset;  // task offset
    int NWs;     // number of NW batches where NW=<total warps per core>.
    int RWs;     // number of remaining warps in the core
    int fWindex; // nth rotation of a full warp
} wspawn_tasks_args_t;

typedef struct
{
    context_t *ctx;
    vx_spawn_kernel_cb callback;
    void *arg;
    int offset; // task offset
    int NWs;    // number of NW batches where NW=<total warps per core>.
    int RWs;    // number of remaining warps in the core
    char isXYpow2;
    char log2XY;
    char log2X;
} wspawn_kernel_args_t;

void *g_wspawn_args[NUM_CORES_MAX];

inline char is_log2(int x)
{
    return ((x & (x - 1)) == 0);
}

inline int fast_log2(int x)
{
    float f = x;
    return (*(int *)(&f) >> 23) - 127;
}

static void __attribute__((noinline)) spawn_tasks_all_stub()
{
    int NT = vx_num_threads();
    int NW = vx_num_warps();
    int cid = vx_core_id();
    int wid = vx_warp_id();
    int tid = vx_thread_id();

    wspawn_tasks_args_t *p_wspawn_args = (wspawn_tasks_args_t *)g_wspawn_args[cid];

    vx_spawn_tasks_cb callback = p_wspawn_args->callback;
    void *arg = p_wspawn_args->arg;

    int warp_gid = (p_wspawn_args->fWindex * NW) + wid;
    int thread_gid = warp_gid * NT + tid + p_wspawn_args->offset;
    // vx_printf("VXSpawn: cid=%d, wid=%d, tid=%d, wK=%d, tK=%d, offset=%d, taskids=%d-%d, fWindex=%d, warp_gid=%d, thread_gid=%d\n",cid, wid, tid, wK, tK, offset, (offset), (offset+tK-1),p_wspawn_args->fWindex,warp_gid,thread_gid);
    vx_printf("VXSpawn: cid=%d, wid=%d, tid=%d, fWiWndex=%d, offset= %d, warp_gid=%d, thread_gid=%d\n", cid, wid, tid, p_wspawn_args->fWindex, p_wspawn_args->offset, warp_gid, thread_gid);
    
    // Set the nth bit to 1 in JALOL reg. The n is the wid of the warp.
    csr_write(VXX_HW_ITR_JALOL, 1);
    callback(thread_gid, arg);

    // WORKAROUND
    // this nop is in place to avoid compiler optimization where it directly jumps 2 functions to return back
    // the hardware overloading of JAL fails that time.
    asm volatile("addi x0, x0, 0"); 
}

static void __attribute__((noinline)) spawn_tasks_rem_stub()
{
    int cid = vx_core_id();
    int tid = vx_thread_id();

    wspawn_tasks_args_t *p_wspawn_args = (wspawn_tasks_args_t *)g_wspawn_args[cid];
    int task_id = p_wspawn_args->offset + tid;
    (p_wspawn_args->callback)(task_id, p_wspawn_args->arg);
}

static void __attribute__((noinline)) spawn_tasks_all_cb()
{
    // activate all threads
    vx_tmc(-1);

    // call stub routine
    spawn_tasks_all_stub();

    // disable warp
    vx_tmc_zero();
}

// Add returnhandler funct.                       --- done
// write handler to the hw csr reg VXX_HW_ITR_RHA --- done
// write the interrupt handler to the CSR reg     --- done
// write the itnerupt handler                     --- done
// turn on the return function jump jal overload flag - right before the warp spawn. --- done. 
// overloading for the 2 extra regs for local tid, and wid. 

// return handler
// load in to r1 the correct thing. and jump there.

void return_handler()
{
    int core_id = vx_core_id();

    if (core_id == 0)
    { // simt core, get wid.
        if (vx_warp_id() == 0)
        {
            asm volatile("csrr x1, %0" : : "i"(VXX_HW_ITR_RAVW0) :); //return back to SIMT kernel scheduler
        }
        else
        {
            vx_tmc_zero(); // kill self. kill the current warp
        }
    }
    else if (core_id == 1)
    { // scalar core.
        asm volatile("csrr x1, %0" : : "i"(VXX_HW_ITR_RAS) :);
        // do something to the csr here to reset the stupid ass wid tid regs. 
    }

    // automatically ret to the link register.
}

void interrupt_simt_handler() 
{
    asm volatile("isr_start:\n\t"
                "csrw %0, %1" :: "i"(VXX_HW_ITR_R1), "r"(1));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R2), "r"(2));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R3), "r"(3));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R4), "r"(4));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R5), "r"(5));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R6), "r"(6));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R7), "r"(7));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R8), "r"(8));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R9), "r"(9));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R10), "r"(10));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R11), "r"(11));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R12), "r"(12));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R13), "r"(13));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R14), "r"(14));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R15), "r"(15));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R16), "r"(16));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R17), "r"(17));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R18), "r"(18));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R19), "r"(19));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R20), "r"(20));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R21), "r"(21));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R22), "r"(22));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R23), "r"(23));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R24), "r"(24));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R25), "r"(25));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R26), "r"(26));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R27), "r"(27));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R28), "r"(28));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R29), "r"(29));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R30), "r"(30));
    asm volatile("csrw %0, %1" :: "i"(VXX_HW_ITR_R31), "r"(31));
    asm volatile("j isr_start");
}


void vx_spawn_tasks(int num_tasks, vx_spawn_tasks_cb callback, void *arg)
{
    return_handler_ptr = return_handler;
    interrupt_simt_handler_ptr = interrupt_simt_handler;

    csr_write(VXX_HW_ITR_RHA, return_handler_ptr);
    csr_write(VXX_HW_ITR_IRQ, interrupt_simt_handler_ptr);

    int NC_total = vx_num_cores();
    int NC = NC_total / 2;
    int NW = vx_num_warps();
    int NT = vx_num_threads();

    // current core id
    int core_id = vx_core_id();
    // assign non-priority tasks only to the first half cores
    if (core_id >= (NC_total / 2)) /// 2
    {
        vx_printf("Vx_spawn_tasks core_id too high, so returning core_id:%d, total cores=%d\n", core_id, NC_total);
        return;
    }

    vx_printf("VXspawn starting spawn,  core_id=%d\n", core_id);
    // calculate necessary active cores
    int WT = NW * NT;
    int nC1 = (num_tasks > WT) ? (num_tasks / WT) : 1;
    int nc = MIN(nC1, NC_total / 2);
    int nCoreIDMax = nc - 1;
    if (core_id > nCoreIDMax)
    {
        vx_printf("VXspawn returning coz core_id=%d >= nc=%d nCoreIDMax=%d\n (nC1=%d, NC_total/2=%d)", core_id, nc, nCoreIDMax, nC1, NC_total / 2);
        return; // terminate extra cores
    }

    // number of tasks per core
    int tasks_per_core = num_tasks / nc;
    int tasks_per_core_n1 = tasks_per_core;
    if (core_id == (nc - 1))
    {
        int rem = num_tasks - (nc * tasks_per_core);
        tasks_per_core_n1 += rem; // last core also executes remaining tasks
    }

    // number of tasks per warp
    int TW = tasks_per_core_n1 / NT;      // occupied warps
    int rT = tasks_per_core_n1 - TW * NT; // remaining threads
    // TW = tasks_per_core_n1;
    // rT = 0;
    int fW = 1, rW = 0;
    if (TW >= NW)
    {
        fW = TW / NW;      // full warps iterations
        rW = TW - fW * NW; // remaining warps
    }

    wspawn_tasks_args_t wspawn_args = {callback, arg, core_id * tasks_per_core, fW, rW, 0};
    g_wspawn_args[core_id] = &wspawn_args;
    int nw = MIN(TW, NW);
    vx_printf("VXSpawn: core_id=%d num_tasks=%d NC=%d NW=%d NT=%d WT=%d nC1=%d nc=%d tasks_per_core_n1=%d TW=%d rT=%d fW=%d rW=%d offset=%d nw=%d\n", core_id, num_tasks, NC, NW, NT, WT, nC1, nc, tasks_per_core_n1, TW, rT, fW, rW, core_id * tasks_per_core, nw);
    if (TW >= 1)
    {
        for (int i = 0; i < fW; i++)
        {
            // execute callback on other warps
            wspawn_args.fWindex = i;
            // go off right here.
            vx_wspawn(nw, spawn_tasks_all_cb);

            // activate all threads
            vx_tmc(-1);

            // vx_tmc_one();

            // call stub routine
            spawn_tasks_all_stub();

            // back to single-threaded
            vx_tmc_one();

            // wait for spawn warps to terminate
            vx_wspawn_wait();
        }
        if (rW > 0)
        {
            // execute callback on other warps
            wspawn_args.fWindex = fW;
            vx_wspawn(rW, spawn_tasks_all_cb);

            // activate all threads
            vx_tmc(-1);

            // vx_tmc_one();

            // call stub routine
            spawn_tasks_all_stub();

            // back to single-threaded
            vx_tmc_one();

            // wait for spawn warps to terminate
            vx_wspawn_wait();
        }
    }

    vx_printf("VXSpawn: I am done with the for loop\n");
    if (rT != 0)
    {
        // adjust offset
        wspawn_args.offset += (tasks_per_core_n1 - rT);

        // activate remaining threads
        int tmask = (1 << rT) - 1;
        vx_tmc(tmask);

        // call stub routine
        spawn_tasks_rem_stub();

        // back to single-threaded
        vx_tmc_one();
    }

    csr_write(VXX_HW_ITR_ACC, 0);
    csr_write(VXX_HW_ITR_ACCEND, 1);
}

void vx_spawn_priority_tasks(int num_tasks, int priority_tasks_offset, vx_spawn_tasks_cb callback, void *arg)
{

    vx_printf("VXPSpawn: Priority thread scheduler on scalar core has begun");

    int priority_threads[15] = {3, 6, 8, 9, 10, 12, 1, 2, 4, 5, 7, 11, 13, 15, 14};

    volatile int accel = csr_read(VXX_HW_ITR_ACC);
    volatile int accel_end = csr_read(VXX_HW_ITR_ACCEND);
    volatile int temp = 0;

    // poll loop on the accel register.
    // once this is turned on: leave the loop
    while (!accel)
    {
        accel = csr_read(VXX_HW_ITR_ACC);
        accel_end = csr_read(VXX_HW_ITR_ACCEND);

        if (accel_end)
        {
            return;
        }
    }

    // start pulling all the threads from the SIMT core.
    int idx = 0;

    accel_end = csr_read(VXX_HW_ITR_ACCEND);
    while (!accel_end && idx < 15)
    {
        //================================= Request a Thread from the Scalar Core ======================================
        csr_write(VXX_HW_ITR_TID, priority_threads[idx]);
        csr_write(VXX_HW_ITR_S2V, 1);
        idx++;

        //================================= Wait for hardware interrupt controller to respond ===========================
        temp = csr_read(VXX_HW_ITR_V2S);
        while (!temp)
        {
            temp = csr_read(VXX_HW_ITR_V2S);
        }

        //================================= Check the error register, if it fails, get the next thread id ==============
        temp = csr_read(VXX_HW_ITR_ERR);
        if (temp)
        {
            csr_write(VXX_HW_ITR_S2V, 0);
            continue;
        }

        //================================ Copy in all the correct regs, and mark the clobbers  ========================

        asm volatile("csrr x1, %0" : : "i"(VXX_HW_ITR_R1) : "x1"); // return address, has to get saved properly.
        asm volatile("csrr x3, %0" : : "i"(VXX_HW_ITR_R3) : "x3");
        asm volatile("csrr x4, %0" : : "i"(VXX_HW_ITR_R4) : "x4");
        asm volatile("csrr x5, %0" : : "i"(VXX_HW_ITR_R5) : "x5");
        asm volatile("csrr x6, %0" : : "i"(VXX_HW_ITR_R6) : "x6");
        asm volatile("csrr x7, %0" : : "i"(VXX_HW_ITR_R7) : "x7");
        asm volatile("csrr x8, %0" : : "i"(VXX_HW_ITR_R8) : "x8");
        asm volatile("csrr x9, %0" : : "i"(VXX_HW_ITR_R9) : "x9");
        asm volatile("csrr x10, %0" : : "i"(VXX_HW_ITR_R10) : "x10");
        asm volatile("csrr x11, %0" : : "i"(VXX_HW_ITR_R11) : "x11");
        asm volatile("csrr x12, %0" : : "i"(VXX_HW_ITR_R12) : "x12");
        asm volatile("csrr x13, %0" : : "i"(VXX_HW_ITR_R13) : "x13");
        asm volatile("csrr x14, %0" : : "i"(VXX_HW_ITR_R14) : "x14");
        asm volatile("csrr x15, %0" : : "i"(VXX_HW_ITR_R15) : "x15");
        asm volatile("csrr x16, %0" : : "i"(VXX_HW_ITR_R16) : "x16");
        asm volatile("csrr x17, %0" : : "i"(VXX_HW_ITR_R17) : "x17");
        asm volatile("csrr x18, %0" : : "i"(VXX_HW_ITR_R18) : "x18");
        asm volatile("csrr x19, %0" : : "i"(VXX_HW_ITR_R19) : "x19");
        asm volatile("csrr x20, %0" : : "i"(VXX_HW_ITR_R20) : "x20");
        asm volatile("csrr x21, %0" : : "i"(VXX_HW_ITR_R21) : "x21");
        asm volatile("csrr x22, %0" : : "i"(VXX_HW_ITR_R22) : "x22");
        asm volatile("csrr x23, %0" : : "i"(VXX_HW_ITR_R23) : "x23");
        asm volatile("csrr x24, %0" : : "i"(VXX_HW_ITR_R24) : "x24");
        asm volatile("csrr x25, %0" : : "i"(VXX_HW_ITR_R25) : "x25");
        asm volatile("csrr x26, %0" : : "i"(VXX_HW_ITR_R26) : "x26");
        asm volatile("csrr x27, %0" : : "i"(VXX_HW_ITR_R27) : "x27");
        asm volatile("csrr x28, %0" : : "i"(VXX_HW_ITR_R28) : "x28");
        asm volatile("csrr x29, %0" : : "i"(VXX_HW_ITR_R29) : "x29");
        asm volatile("csrr x30, %0" : : "i"(VXX_HW_ITR_R30) : "x30");
        asm volatile("csrr x31, %0" : : "i"(VXX_HW_ITR_R31) : "x31");

        // Stack pointer has to be safe.
        // I have to first save the stack pointer to the HW_ITR_CTRL.
        // Then we have to load in the new stack pointer.
        // Don't need to throw this on the clobber list.
        // we might need to store this into a safe space first on our own.
        asm volatile("csrw %0, x2" : : "i"(VXX_HW_ITR_SSP));
        asm volatile("csrr x2, %0" : : "i"(VXX_HW_ITR_R2) :); // dont mark this reg as a clobber.
        asm volatile("csrw %0, %1" ::"i"(VXX_HW_ITR_S2V), "i"(0));

        // csr_write(VXX_HW_ITR_RAS, scheduler_resume_point);
        // csr_write(VXX_HW_ITR_J_TO_KERNEL, 1);

        // jump to interrupted PC of the kernel pulled from SIMT
        // jr 0 is overloaded special instruction that does not behave normally
        asm volatile("jr x0");
        // asm volatile(".insn r %0, 1, 0, x0, %1, %2" ::"i"(RISCV_CUSTOM0), "r"("x0"), "r"("x0"));
                                                                          
scheduler_resume_point: // this PC is stored in VXX_HW_ITR_RAS
        // csr_write(VXX_HW_ITR_J_TO_KERNEL, 0);
        asm volatile("csrr x2, %0" : : "i"(VXX_HW_ITR_SSP) :); // restore the stack ptr.
        accel_end = csr_read(VXX_HW_ITR_ACCEND);
    }
}

///////////////////////////////////////////////////////////////////////////////

static void __attribute__((noinline)) spawn_kernel_all_stub()
{
    int NT = vx_num_threads();
    int cid = vx_core_id();
    int wid = vx_warp_id();
    int tid = vx_thread_id();

    wspawn_kernel_args_t *p_wspawn_args = (wspawn_kernel_args_t *)g_wspawn_args[cid];

    int wK = (p_wspawn_args->NWs * wid) + MIN(p_wspawn_args->RWs, wid);
    int tK = p_wspawn_args->NWs + (wid < p_wspawn_args->RWs);
    int offset = p_wspawn_args->offset + (wK * NT) + (tid * tK);

    int X = p_wspawn_args->ctx->num_groups[0];
    int Y = p_wspawn_args->ctx->num_groups[1];
    int XY = X * Y;

    if (p_wspawn_args->isXYpow2)
    {
        for (int wg_id = offset, N = wg_id + tK; wg_id < N; ++wg_id)
        {
            int k = wg_id >> p_wspawn_args->log2XY;
            int wg_2d = wg_id - k * XY;
            int j = wg_2d >> p_wspawn_args->log2X;
            int i = wg_2d - j * X;
            (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
        }
    }
    else
    {
        for (int wg_id = offset, N = wg_id + tK; wg_id < N; ++wg_id)
        {
            int k = wg_id / XY;
            int wg_2d = wg_id - k * XY;
            int j = wg_2d / X;
            int i = wg_2d - j * X;
            (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
        }
    }
}

static void __attribute__((noinline)) spawn_kernel_rem_stub()
{
    int cid = vx_core_id();
    int tid = vx_thread_id();

    wspawn_kernel_args_t *p_wspawn_args = (wspawn_kernel_args_t *)g_wspawn_args[cid];

    int wg_id = p_wspawn_args->offset + tid;

    int X = p_wspawn_args->ctx->num_groups[0];
    int Y = p_wspawn_args->ctx->num_groups[1];
    int XY = X * Y;

    if (p_wspawn_args->isXYpow2)
    {
        int k = wg_id >> p_wspawn_args->log2XY;
        int wg_2d = wg_id - k * XY;
        int j = wg_2d >> p_wspawn_args->log2X;
        int i = wg_2d - j * X;
        (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
    }
    else
    {
        int k = wg_id / XY;
        int wg_2d = wg_id - k * XY;
        int j = wg_2d / X;
        int i = wg_2d - j * X;
        (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
    }
}

static void __attribute__((noinline)) spawn_kernel_all_cb()
{
    // activate all threads
    vx_tmc(-1);

    // call stub routine
    spawn_kernel_all_stub();

    // disable warp
    vx_tmc_zero();
}

void vx_spawn_kernel(context_t *ctx, vx_spawn_kernel_cb callback, void *arg)
{
    // total number of WGs
    int X = ctx->num_groups[0];
    int Y = ctx->num_groups[1];
    int Z = ctx->num_groups[2];
    int XY = X * Y;
    int num_tasks = XY * Z;

    // device specs
    int NC = vx_num_cores();
    int NW = vx_num_warps();
    int NT = vx_num_threads();

    // current core id
    int core_id = vx_core_id();
    if (core_id >= NUM_CORES_MAX)
        return;

    // calculate necessary active cores
    int WT = NW * NT;
    int nC = (num_tasks > WT) ? (num_tasks / WT) : 1;
    int nc = MIN(nC, NC);
    if (core_id >= nc)
        return; // terminate extra cores

    // number of tasks per core
    int tasks_per_core = num_tasks / nc;
    int tasks_per_core_n1 = tasks_per_core;
    if (core_id == (nc - 1))
    {
        int rem = num_tasks - (nc * tasks_per_core);
        tasks_per_core_n1 += rem; // last core also executes remaining WGs
    }

    // number of tasks per warp
    int TW = tasks_per_core_n1 / NT;      // occupied warps
    int rT = tasks_per_core_n1 - TW * NT; // remaining threads
    int fW = 1, rW = 0;
    if (TW >= NW)
    {
        fW = TW / NW;      // full warps iterations
        rW = TW - fW * NW; // remaining warps
    }

    // fast path handling
    char isXYpow2 = is_log2(XY);
    char log2XY = fast_log2(XY);
    char log2X = fast_log2(X);

    wspawn_kernel_args_t wspawn_args = {
        ctx, callback, arg, core_id * tasks_per_core, fW, rW, isXYpow2, log2XY, log2X};
    g_wspawn_args[core_id] = &wspawn_args;

    if (TW >= 1)
    {
        // execute callback on other warps
        int nw = MIN(TW, NW);
        vx_wspawn(nw, spawn_kernel_all_cb);

        // activate all threads
        vx_tmc(-1);

        // call stub routine
        asm volatile("" ::: "memory");
        spawn_kernel_all_stub();

        // back to single-threaded
        vx_tmc_one();

        // wait for spawn warps to terminate
        vx_wspawn_wait();
    }

    if (rT != 0)
    {
        // adjust offset
        wspawn_args.offset += (tasks_per_core_n1 - rT);

        // activate remaining threads
        int tmask = (1 << rT) - 1;
        vx_tmc(tmask);

        // call stub routine
        spawn_kernel_rem_stub();

        // back to single-threaded
        vx_tmc_one();
    }
}

#ifdef __cplusplus
}
#endif