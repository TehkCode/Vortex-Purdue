#include <stdint.h>
#include <vx_intrinsics.h>
#include <vx_spawn.h>
#include <vx_print.h>
#include "common.h"
#include "post.h"  

// void kernel_body(int task_id, kernel_arg_t* __UNIFORM__ arg) {
//     uint32_t count    = arg->task_size;
//     int32_t* src0_ptr = (int32_t*)arg->src0_addr;
//     int32_t* src1_ptr = (int32_t*)arg->src1_addr;
//     int32_t* dst_ptr  = (int32_t*)arg->dst_addr;

//     uint32_t offset = task_id * count;

//     for (uint32_t i = 0; i < count; ++i) {
//         if(src0_ptr[offset+i] % 2 == 0 && src1_ptr[offset+i] % 2 == 0) {
//             dst_ptr[offset+i] = src0_ptr[offset+i] + src1_ptr[offset+i];
//         }
//         else if(src0_ptr[offset+i] % 2 == 1 && src1_ptr[offset+i] % 2 == 0) {
//             dst_ptr[offset+i] = src0_ptr[offset+i] - src1_ptr[offset+i];
//         }
//         else if(src0_ptr[offset+i] % 2 == 0 && src1_ptr[offset+i] % 2 == 1) {
//             dst_ptr[offset+i] = src0_ptr[offset+i] * src1_ptr[offset+i];
//         }
//         else {
//             dst_ptr[offset+i] = 2 * src0_ptr[offset+i] - src1_ptr[offset+i];
//         }
//     }
// }

// priority task: newPost
// nonpriority task: getPostByUser

// Define a structure for task data that includes information about the task type and necessary parameters
struct TaskData {
    int userID;
    std::string postContent;  // Only used for newPost tasks
};

void kernel_body_priority(int task_id, kernel_arg_t* __UNIFORM__ arg) {
    uint32_t count    = arg->task_size;
   
    int32_t* dst_ptr  = (int32_t*)arg->dst_addr;

   
    // TaskData* taskDataArray = (TaskData*)arg->src0_addr;  // Assuming task data is passed in src0_addr
    uint32_t offset = task_id * count;
    
// 0,1,2,3,4,5,6,7,8,9
// 0,1,2,3,4,5,6,7,8,9
// 0,1,2,3,4,5,6,7,8,9

    for(int i=0; i<count; ++i)
    {

        newPost(offset + i, "New_post + i");

        int64_t postID =  1;

        //save to built-in memcached
        struct post _newpost;
        _newpost.user_id=userID;
        _newpost.post_id=postID;
        _newpost.post_string=post;
        
        post_memcached.insert(make_pair(userID, _newpost));
        
        //save to storage
        post_storage<<userID<<","<<postID<<","<<post<<endl;


        // TaskData task = taskDataArray[offset + i];        
        // newPost(task.userID, task.postContent);
    }
}

void kernel_body_nonpriority(int task_id, kernel_arg_t* __UNIFORM__ arg) {
    uint32_t count    = arg->task_size;
    
    int32_t* src0_ptr = (int32_t*)arg->src0_addr;
    int32_t* src1_ptr = (int32_t*)arg->src1_addr;
    int32_t* dst_ptr  = (int32_t*)arg->dst_addr;

    TaskData* taskDataArray = (TaskData*)arg->src1_addr;  // Assuming task data is passed in src0_addr

    uint32_t offset = task_id * count;

    for(int i=0; i<count; ++i)
    {
        TaskData task = taskDataArray[offset + i];

        vector<string> posts;        
        getPostByUser(task.userID, posts, 10); //get 10 posts from this user
        
        cout << "number of posts: " << posts.size() <<endl;
        for(int i=0; i < posts.size(); ++i) cout << "post " << i << " : "<< posts[i]  <<endl;

        // char* postsBuffer = (char*)arg->dst_addr;
        // TaskData task = taskDataArray[offset + i];
        // int numPosts = getPostByUser(task.userID, postsBuffer, 10); 
        // postsBuffer += numPosts * MAX_POST_SIZE;

    }
    
}

int main() {
	kernel_arg_t* arg = (kernel_arg_t*)KERNEL_ARG_DEV_MEM_ADDR;
	
    // vx_printf("Calling VXSpawn\n");
	vx_spawn_tasks(arg->num_tasks_nonpriority, (vx_spawn_tasks_cb)kernel_body_nonpriority, arg);

	// vx_printf("Calling VXPSpawn\n");
	vx_spawn_priority_tasks(arg->num_tasks_priority, arg->num_tasks_nonpriority, (vx_spawn_tasks_cb)kernel_body_priority, arg);
	return 0;
}

