// C++ program to generate short url from integer id and
// integer id back from short url.
#include<iostream>
#include<algorithm>
#include<string>
#include<vector>
#include <fstream>
#include "utils.h"
#include <unordered_map>
using namespace std;
 
 
unordered_map<string, string> url_memcached;

#define shortURL_API_RATIO 10

string shortURL(string longURL)
{
     long unsigned ID = shortURLtoID(longURL);
	 string shortURL = HOSTNAME + idToShortURL(ID);
	 

	 //TO DO: save to the memcached or DB
	 //save (ID, longURL, shortURL)
	 
	 url_memcached.insert(make_pair(shortURL, longURL));
	 
	 	 return shortURL;

}

string getLongURL(string shortURL)
{
	 //TO DO: get from the memcached or DB
	 //get (shortURL)
	 
	std::unordered_map<string,string>::const_iterator got = url_memcached.find(shortURL);

  if ( got == url_memcached.end() )
    std::cout << "ERROR: not found";
  else
    return got->second;
}
 
// Driver program to test above function
int main(int argc, char *argv[])
{
	if(argc < 2) {
        printf("You must provide the number of lines\n");
        exit(0);
    }
	
	 srand (1);
	int num_lines = 0;
	int lines = 0;
	
	num_lines = atoi(argv[1]);

   fstream urlfile;
   vector<string> previous_url;
  
   urlfile.open("keylist.list",ios::in); 
   if (urlfile.is_open()){  
      string tp;
      while(getline(urlfile, tp) && lines < num_lines){ 
	    if((rand() % 100) < shortURL_API_RATIO || lines==0){
		   cout << "new shortURL event"<<endl;		  
           string _shorturl = shortURL( tp );
		   cout<< _shorturl <<endl<<endl;
		   previous_url.push_back(_shorturl);
		} 
		else {
			int index = rand() % previous_url.size();
			cout << "new getLongURL event"<<endl;	
			string _longurl = getLongURL(previous_url[index]);
			cout<< _longurl <<endl<<endl;			
		}
		 lines++;
      }
      urlfile.close(); 
   }

	return 0;
}