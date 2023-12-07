#include"uniqueID.h"
#include"post.h"

using namespace std;

struct post{
int user_id;
int64_t post_id;
string post_string;	
};

unordered_multimap<int, post> post_memcached;
typedef unordered_multimap<int, post>::iterator umit;

#define USER_NUM 10
#define newPost_API_RATIO 90

std::ofstream post_storage;
 
void newPost(int userID, string post)
{
    int64_t postID =  UploadUniqueId(userID);

	//TO DO
	//call the text service from grpc call
	//save the post from memcahced or DB
	
	//save to built-in memcached
	struct post _newpost;
	_newpost.user_id=userID;
	_newpost.post_id=postID;
	_newpost.post_string=post;
	
	post_memcached.insert(make_pair(userID, _newpost));
	
	//save to storage
	post_storage<<userID<<","<<postID<<","<<post<<endl;


}

void getPostByUser(int userID, vector<string>& posts, int post_num)
{
	//TO DO
	//get post from memcahced or DB
	//get the url original from the url service
	
	//get all post from this user from our memcached
	    pair<umit, umit> it = post_memcached.equal_range(userID);
		umit it1 = it.first;
		pair<int, post> tmp;
		int num=0;
 
    // looping over all values associated with key
    while (it1 != it.second && num < post_num)
    {
        tmp = *it1;
        posts.push_back(tmp.second.post_string);
        it1++;
		num++;
    }
	
}

