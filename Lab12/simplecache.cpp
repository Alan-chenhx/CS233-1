#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
	std::vector< SimpleCacheBlock > &cache1 = _cache[index]; 
	int temp ;
	for (int i = 0; i < cache1.size(); i++) {
		if(cache1[i].valid() == true && cache1[i].tag() == tag){
			temp = (int)(cache1[i].get_byte(block_offset)); 
      			return temp;
	}
    }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
	std::vector< SimpleCacheBlock > &cache2 = _cache[index]; 

	for(int i=0; i<cache2.size();i++){
		if(cache2[i].valid() == false){
			cache2[i].replace(tag, data);
			return;
		}
	}
	cache2[0].replace(tag, data);
	return;

}
