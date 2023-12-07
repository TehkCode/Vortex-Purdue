#ifndef _POST_H_
#define _POST_H_

#include"uniqueID.h"
#include <fstream>
#include <unordered_map>
#include <algorithm>

void newPost(int userID, string post);
void getPostByUser(int userID, vector<string>& posts, int post_num);

#endif