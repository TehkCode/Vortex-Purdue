#include "picosha2.h"
#include"uniqueID.h"
#include"utils.h"
#include <fstream>
#include <unordered_map>
#include <algorithm>
using namespace std;

struct user{
int user_id;
string first_name;
string last_name;	
string username;	
string passowrd_hashed;	
string data_birth;	
};

unordered_map<string, user> user_memcached;
 std::ofstream user_storage;
 
#define newUser_API_RATIO 10

void newUser(string first_name, string last_name, string username, string password, string data_birth)
{
     int64_t userID =  UploadUniqueId(0);
	
	//save to built-in memcached
	struct user _newuser;
	_newuser.first_name=first_name;
	_newuser.last_name=last_name;
	_newuser.username=username;
	_newuser.passowrd_hashed=picosha2::hash256_hex_string(password);
	_newuser.data_birth=data_birth;

	//check user name does not already exist
	std::unordered_map<string,user>::const_iterator got = user_memcached.find(username);

	if ( got == user_memcached.end() ) {
		//save to memcache
		user_memcached.insert(make_pair(username, _newuser));
		//save to storage
		user_storage<<username<<","<<_newuser.passowrd_hashed<<","<<first_name<<","<<last_name<<","<<data_birth<<endl;
	}
	else
		cout<<"ERROR: user name already exists"<<endl;


}

bool login(string username, string password)
{
	
	std::unordered_map<string,user>::const_iterator got = user_memcached.find(username);

	  if ( got == user_memcached.end() )
		std::cout << "ERROR: username not found" <<endl;	  
	  else {
		 if(picosha2::hash256_hex_string(password) == got->second.passowrd_hashed)
			{
				return true;	
			}
			else 
			{
				std::cout << "ERROR: password is not correct" <<endl;	  
				return false;
			}
	  }
}

int main(int argc, char *argv[]) {

	if(argc < 2) {
        printf("You must provide the number of requests\n");
        exit(0);
    }
	
	srand (1);
	int num_reqs = 0;
	int reqs = 0;

	num_reqs = atoi(argv[1]);
	
	 user_storage.open("user_storage.txt");

	vector<string> previous_usernames;
	vector<string> previous_passwords;

	  while(reqs < num_reqs){ 
	  
	  if((rand() % 100) < newUser_API_RATIO || reqs==0) {
		  //new user	
		cout << "new user event"<<endl;		
		string username = gen_random_string(15);	
		string password =  gen_random_string(12);	
		cout << "user name: " << username <<endl;	  
		cout << "password: " << password <<endl<<endl;	
		newUser(gen_random_string(20), gen_random_string(20), username, password, gen_random_string(10));
		previous_usernames.push_back(username);
		previous_passwords.push_back(password);
	  } else {
		cout << "login event"<<endl;		  
		
		 {
		int index = rand() % previous_usernames.size();
		cout << "user name: " << previous_usernames[index] <<endl;	
		string password;
		if((rand() % 100) < 95)	{
			password = previous_passwords[index];
		}		
		else {
			password =  gen_random_string(12);	
		}	
		cout << "password: " << password <<endl;	
		
		bool success = login(previous_usernames[index], password);
		cout << "status: " << success <<endl<<endl;

	  }
	}
	
	 reqs++;
  }

    user_storage.close();
	return 0;
}