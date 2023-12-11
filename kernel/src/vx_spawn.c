
// Copyright © 2019-2023
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <vx_spawn.h>
#include <vx_intrinsics.h>
#include <inttypes.h>
#include <vx_print.h>

#ifdef __cplusplus
extern "C" {
#endif

#define NUM_CORES_MAX 1024

#ifndef MIN
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#endif

typedef struct {
	vx_spawn_tasks_cb callback;
	void* arg;
	int offset; // task offset
	int NWs;    // number of NW batches where NW=<total warps per core>.
	int RWs;    // number of remaining warps in the core
  int fWindex; // nth rotation of a full warp
} wspawn_tasks_args_t;

typedef struct {
  context_t * ctx;
  vx_spawn_kernel_cb callback;
  void* arg;
	int offset; // task offset
	int NWs;    // number of NW batches where NW=<total warps per core>.
	int RWs;    // number of remaining warps in the core
  char isXYpow2;
  char log2XY;
  char log2X;
} wspawn_kernel_args_t;

void* g_wspawn_args[NUM_CORES_MAX];

inline char is_log2(int x) {
  return ((x & (x-1)) == 0);
}

inline int fast_log2(int x) {
  float f = x;
  return (*(int*)(&f)>>23) - 127;
}

static void __attribute__ ((noinline)) spawn_tasks_all_stub() {
  int NT  = vx_num_threads();
  int NW = vx_num_warps();
  int cid = vx_core_id();
  int wid = vx_warp_id();
  int tid = vx_thread_id();

  wspawn_tasks_args_t* p_wspawn_args = (wspawn_tasks_args_t*)g_wspawn_args[cid];

  // int wK = (p_wspawn_args->NWs * wid) + MIN(p_wspawn_args->RWs, wid);
  // int tK = p_wspawn_args->NWs + (wid < p_wspawn_args->RWs);
  // int offset = p_wspawn_args->offset + (wK * NT) + (tid * tK);

  
  vx_spawn_tasks_cb callback = p_wspawn_args->callback;
  void* arg = p_wspawn_args->arg;

  int warp_gid = (p_wspawn_args->fWindex * NW) + wid; 
  int thread_gid = warp_gid * NT + tid + p_wspawn_args->offset; 
  // vx_printf("VXSpawn: cid=%d, wid=%d, tid=%d, wK=%d, tK=%d, offset=%d, taskids=%d-%d, fWindex=%d, warp_gid=%d, thread_gid=%d\n",cid, wid, tid, wK, tK, offset, (offset), (offset+tK-1),p_wspawn_args->fWindex,warp_gid,thread_gid);
  vx_printf("VXSpawn: cid=%d, wid=%d, tid=%d, fWindex=%d, offset= %d, warp_gid=%d, thread_gid=%d\n",cid, wid, tid, p_wspawn_args->fWindex,p_wspawn_args->offset,warp_gid,thread_gid);
  callback(thread_gid, arg);

  // for (int task_id = offset, N = task_id + tK; task_id < N; ++task_id) {
  //   callback(task_id, arg);
  // }
}

static void __attribute__ ((noinline)) spawn_tasks_rem_stub() {
  int cid = vx_core_id();
  int tid = vx_thread_id();
  
  wspawn_tasks_args_t* p_wspawn_args = (wspawn_tasks_args_t*)g_wspawn_args[cid];
  int task_id = p_wspawn_args->offset + tid;
  (p_wspawn_args->callback)(task_id, p_wspawn_args->arg);
}

static void __attribute__ ((noinline)) spawn_tasks_all_cb() {  
  // activate all threads
  vx_tmc(-1);

  // vx_tmc_one();

  // call stub routine
  spawn_tasks_all_stub();

  // disable warp
  vx_tmc_zero();
}


void vx_spawn_tasks(int num_tasks, vx_spawn_tasks_cb callback , void * arg) {
	// device specs
  
  int NC_total = vx_num_cores();
  int NC = NC_total/2;
  int NW = vx_num_warps();
  int NT = vx_num_threads();

  // current core id
  int core_id = vx_core_id();
  // assign non-priority tasks only to the first half cores
  if (core_id >= (NC_total/2)) ///2
  {
    vx_printf("Vx_spawn_tasks core_id too high, so returning core_id:%d, total cores=%d\n", core_id, NC_total);
    return;
  }

  vx_printf("VXspawn starting spawn,  core_id=%d\n",core_id);
  // calculate necessary active cores
  int WT = NW * NT;
  int nC1 = (num_tasks > WT) ? (num_tasks / WT) : 1;
  int nc = MIN(nC1, NC_total/2);
  int nCoreIDMax = nc-1;
  if (core_id > nCoreIDMax)
  {
    vx_printf("VXspawn returning coz core_id=%d >= nc=%d nCoreIDMax=%d\n (nC1=%d, NC_total/2=%d)",core_id,nc,nCoreIDMax, nC1, NC_total/2);
    return; // terminate extra cores
  }
    

  // number of tasks per core
  int tasks_per_core = num_tasks / nc;
  int tasks_per_core_n1 = tasks_per_core;  
  if (core_id == (nc-1)) {    
    int rem = num_tasks - (nc * tasks_per_core); 
    tasks_per_core_n1 += rem; // last core also executes remaining tasks
  }

  // number of tasks per warp
  int TW = tasks_per_core_n1 / NT;      // occupied warps
  int rT = tasks_per_core_n1 - TW * NT; // remaining threads
  // TW = tasks_per_core_n1;
  // rT = 0;
  int fW = 1, rW = 0;
  if (TW >= NW) {
    fW = TW / NW;			                  // full warps iterations
    rW = TW - fW * NW;                  // remaining warps
  }
  
  wspawn_tasks_args_t wspawn_args = { callback, arg, core_id * tasks_per_core, fW, rW,0 };
  g_wspawn_args[core_id] = &wspawn_args;
  int nw = MIN(TW, NW);
  vx_printf("VXSpawn: core_id=%d num_tasks=%d NC=%d NW=%d NT=%d WT=%d nC1=%d nc=%d tasks_per_core_n1=%d TW=%d rT=%d fW=%d rW=%d offset=%d nw=%d\n", core_id, num_tasks,NC, NW, NT,WT, nC1, nc, tasks_per_core_n1, TW, rT, fW, rW, core_id*tasks_per_core, nw);
	if(TW>=1)
  {
  for (int i=0; i<fW; i++)
    {
      // execute callback on other warps
      wspawn_args.fWindex = i;
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
    if(rW>0)
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
  if (rT != 0) {
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

}


static void __attribute__ ((noinline)) spawn_priority_tasks_all_stub() {
  int NT  = 1; //vx_num_threads();
  int NW = vx_num_warps();
  int cid = vx_core_id();
  int wid = vx_warp_id();
  int tid = vx_thread_id();
  
  wspawn_tasks_args_t* p_wspawn_args = (wspawn_tasks_args_t*)g_wspawn_args[cid]; 

  // int wK = (p_wspawn_args->NWs * wid) + MIN(p_wspawn_args->RWs, wid);
  // int tK = p_wspawn_args->NWs + (wid < p_wspawn_args->RWs);
  // int offset = p_wspawn_args->offset + (wK * NT) + (tid * tK);

  vx_spawn_tasks_cb callback = p_wspawn_args->callback;
  void* arg = p_wspawn_args->arg; 

  int warp_gid = (p_wspawn_args->fWindex * NW) + wid; 
  int thread_gid = warp_gid * NT + tid + p_wspawn_args->offset; 
  // vx_printf("VXPSpawn: cid=%d, wid=%d, tid=%d, wK=%d, tK=%d, offset=%d, taskids=%d-%d, fWindex=%d, warp_gid=%d, thread_gid=%d\n",cid, wid, tid, wK, tK, offset, (offset), (offset+tK-1),p_wspawn_args->fWindex,warp_gid,thread_gid);
  vx_printf("VXPSpawn: cid=%d, wid=%d, tid=%d, fWindex=%d, offset= %d, warp_gid=%d, thread_gid=%d\n",cid, wid, tid, p_wspawn_args->fWindex,p_wspawn_args->offset,warp_gid,thread_gid);
  callback(thread_gid, arg);
  // vx_printf("VXPspawn: p_wspawn_args->NWs=%d, p_wspawn_args->RWs=%d, p_wspawn_args->offset=%d, cid=%d, wid=%d, tid=%d, wK=%d, tK=%d, offset=%d \n",p_wspawn_args->NWs,p_wspawn_args->RWs,p_wspawn_args->offset,cid,wid, tid, wK, tK, offset);
  // for (int task_id = offset, N = task_id + tK; task_id < N; ++task_id) {
  //   callback(task_id, arg);
  // }
}

static void __attribute__ ((noinline)) spawn_priority_tasks_all_cb() {  
  // activate the 1 priority thread
  // vx_tmc(-1);

  vx_tmc_one();

  // call stub routine
  spawn_priority_tasks_all_stub();

  // disable warp
  vx_tmc_zero();
}


void vx_spawn_priority_tasks(int num_tasks, int priority_tasks_offset,vx_spawn_tasks_cb callback , void * arg) {
	// device specs
  int NC_total = vx_num_cores();
  int NC = NC_total/2;
  int NW = vx_num_warps(); 
  int NT = 1; //vx_num_threads(); //priority warps are made of only 1 thread, will be run on scalar core 

  // current core id
  int core_id = vx_core_id();
  int core_second = (NC_total/2);
  // vx_printf("VXPspawn where are we skipping? ,  core_boundary=%d\n",core_second);
  
  if (core_id >= NUM_CORES_MAX) 
    return;

  // assign priority tasks only to second half cores
  if(core_id >= (NC_total/2))
  {
    vx_printf("VXPspawn starting spawn,  core_id=%d\n",core_id);
    // calculate necessary active cores
    int WT = NW * NT;
    int nC1 = (num_tasks > WT) ? (num_tasks / WT) : 1;
    int nc = MIN(nC1, NC_total/2);
    int nCoreIDMax = (nc+ (NC_total/2)-1);
    if (core_id > nCoreIDMax )
    {
      vx_printf("VXPspawn returning coz core_id=%d >= nc=%d nCoreIDMax=%d\n (nC1=%d, NC_total/2=%d)",core_id,nc,nCoreIDMax, nC1, NC_total/2);
      return; // terminate extra cores
    }
      

    // number of tasks per core
    int tasks_per_core = (num_tasks / nc);
    int tasks_per_core_n1 = tasks_per_core;  
    if (core_id == (nc-1)) {    
      int rem = num_tasks - (nc * tasks_per_core); 
      tasks_per_core_n1 += rem; // last core also executes remaining tasks
    }

    // number of tasks per warp
    // int TW = tasks_per_core_n1 / NT ;      // occupied warps
    // int rT = tasks_per_core_n1 - TW; // remaining threads
    int TW = tasks_per_core_n1;
    int rT = 0;
    int fW = 1, rW = 0;
    if (TW >= NW) {
      fW = TW / NW;			                  // full warps iterations
      rW = TW - fW * NW;                  // remaining warps
    }

    wspawn_tasks_args_t wspawn_args = { callback, arg, priority_tasks_offset + ((core_id - core_second) * tasks_per_core), fW, rW,0 };
    g_wspawn_args[core_id] = &wspawn_args;
    int nw = MIN(TW, NW);
    vx_printf("VXPSpawn: core_id=%d num_tasks=%d NC=%d NW=%d NT=%d WT=%d nC1=%d nc=%d tasks_per_core_n1=%d TW=%d rT=%d fW=%d rW=%d offset=%d nw=%d\n", core_id, num_tasks,NC, NW, NT,WT, nC1, nc, tasks_per_core_n1, TW, rT, fW, rW, core_id*tasks_per_core, nw);
    if (TW >= 1)	{
      for(int i=0; i<fW; i++)
      {
      // execute callback on other warps
      wspawn_args.fWindex = i;
      vx_wspawn(nw, spawn_priority_tasks_all_cb);

      // activate all threads
      // vx_tmc(-1);

      vx_tmc_one();

      // call stub routine
      spawn_priority_tasks_all_stub();

      // back to single-threaded
      vx_tmc_one();
      
      // wait for spawn warps to terminate
      vx_wspawn_wait();
      }
      if(rW>0)
      {
        // execute callback on other warps
        wspawn_args.fWindex = fW;
        vx_wspawn(rW, spawn_priority_tasks_all_cb);

        // activate all threads
        // vx_tmc(-1);

        vx_tmc_one();

        // call stub routine
        spawn_priority_tasks_all_stub();

        // back to single-threaded
        vx_tmc_one();
        
        // wait for spawn warps to terminate
        vx_wspawn_wait();
      }
    }  

    // vx_printf("VXPSpawn: I am done with the for loop\n");
    // This part might not be necessary since all threads are assigned a 1-thread warp. 
    // if (rT != 0) {
    //   // adjust offset
    //   wspawn_args.offset += (tasks_per_core_n1 - rT);
      
    //   // activate remaining threads  
    //   int tmask = (1 << rT) - 1;
    //   vx_tmc(tmask);

    //   // call stub routine
    //   spawn_tasks_rem_stub();

    //   // back to single-threaded
    //   vx_tmc_one();
    // }
  }
  else
  {
    vx_printf("VXPspawn skipping spawning core id too low,  core_id=%d\n",core_id);
  }
}

///////////////////////////////////////////////////////////////////////////////

static void __attribute__ ((noinline)) spawn_kernel_all_stub() {
  int NT  = vx_num_threads();
  int cid = vx_core_id();
  int wid = vx_warp_id();
  int tid = vx_thread_id();

  wspawn_kernel_args_t* p_wspawn_args = (wspawn_kernel_args_t*)g_wspawn_args[cid];

  int wK = (p_wspawn_args->NWs * wid) + MIN(p_wspawn_args->RWs, wid);
  int tK = p_wspawn_args->NWs + (wid < p_wspawn_args->RWs);
  int offset = p_wspawn_args->offset + (wK * NT) + (tid * tK);

  int X = p_wspawn_args->ctx->num_groups[0];
  int Y = p_wspawn_args->ctx->num_groups[1];
  int XY = X * Y;

  if (p_wspawn_args->isXYpow2) {
    for (int wg_id = offset, N = wg_id + tK; wg_id < N; ++wg_id) {    
      int k = wg_id >> p_wspawn_args->log2XY;
      int wg_2d = wg_id - k * XY;
      int j = wg_2d >> p_wspawn_args->log2X;
      int i = wg_2d - j * X;
      (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
    }
  } else {
    for (int wg_id = offset, N = wg_id + tK; wg_id < N; ++wg_id) {    
      int k = wg_id / XY;
      int wg_2d = wg_id - k * XY;
      int j = wg_2d / X;
      int i = wg_2d - j * X;
      (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
    }
  }
}

static void __attribute__ ((noinline)) spawn_kernel_rem_stub() {
  int cid = vx_core_id();
  int tid = vx_thread_id();

  wspawn_kernel_args_t* p_wspawn_args = (wspawn_kernel_args_t*)g_wspawn_args[cid];

  int wg_id = p_wspawn_args->offset + tid;

  int X = p_wspawn_args->ctx->num_groups[0];
  int Y = p_wspawn_args->ctx->num_groups[1];
  int XY = X * Y;

  if (p_wspawn_args->isXYpow2) {
    int k = wg_id >> p_wspawn_args->log2XY;
    int wg_2d = wg_id - k * XY;
    int j = wg_2d >> p_wspawn_args->log2X;
    int i = wg_2d - j * X;
    (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
  } else {
    int k = wg_id / XY;
    int wg_2d = wg_id - k * XY;
    int j = wg_2d / X;
    int i = wg_2d - j * X;
    (p_wspawn_args->callback)(p_wspawn_args->arg, p_wspawn_args->ctx, i, j, k);
  }
}

static void __attribute__ ((noinline)) spawn_kernel_all_cb() {  
  // activate all threads
  vx_tmc(-1);

  // call stub routine
  spawn_kernel_all_stub();

  // disable warp
  vx_tmc_zero();
}

void vx_spawn_kernel(context_t * ctx, vx_spawn_kernel_cb callback, void * arg) {  
  // total number of WGs
  int X  = ctx->num_groups[0];
  int Y  = ctx->num_groups[1];
  int Z  = ctx->num_groups[2];
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
  if (core_id == (nc-1)) {    
    int rem = num_tasks - (nc * tasks_per_core); 
    tasks_per_core_n1 += rem; // last core also executes remaining WGs
  }

  // number of tasks per warp
  int TW = tasks_per_core_n1 / NT;      // occupied warps
  int rT = tasks_per_core_n1 - TW * NT; // remaining threads
  int fW = 1, rW = 0;
  if (TW >= NW) {
    fW = TW / NW;			                  // full warps iterations
    rW = TW - fW * NW;                  // remaining warps
  }

  // fast path handling
  char isXYpow2 = is_log2(XY);
  char log2XY   = fast_log2(XY);
  char log2X    = fast_log2(X);

  wspawn_kernel_args_t wspawn_args = { 
    ctx, callback, arg, core_id * tasks_per_core, fW, rW, isXYpow2, log2XY, log2X
  };
  g_wspawn_args[core_id] = &wspawn_args;

	if (TW >= 1)	{
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

  if (rT != 0) {
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
