#include "cachesimulator.h"
#include <iostream>
using namespace std;

using std::uint32_t;
using std::vector;


Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */



   const CacheConfig& _cache_config = _cache->get_config();

   uint32_t index = extract_index(address, _cache_config);

   //cout<<"index is "<<index<<endl;

   vector<Cache::Block*> cache1 = _cache->get_blocks_in_set(index);

   //cout<<"cache1 is "<<cache1[0]<<endl;

   uint32_t tag = extract_tag(address, _cache_config);

	//cout<<"tag is "<< tag<<endl;
	
	for(int i=0; i< cache1.size(); i++){
		//if(cache1[i]->is_valid())
		//	cout<< "hi"<<endl;

		//if(cache1[i]->get_tag()== tag)  //have problem here
		//	cout<<"Hello"<<endl;
	// cout<<"tag2 is "<< cache1[i]->get_tag()<<endl;

		if(cache1[i]->is_valid() && cache1[i]->get_tag()== tag ){
			_hits++;
			 // cout << "Hello World "<<endl;
			return cache1[i];
		}
	}
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */


   const CacheConfig& _cache_config = _cache->get_config();
   uint32_t index2 = extract_index(address, _cache_config);
   vector<Cache::Block*> cache2 = _cache->get_blocks_in_set(index2);

   uint32_t least_recently_used = cache2[0]->get_last_used_time();
   Cache::Block * lru = cache2[0]; 
   uint32_t tag = extract_tag(address, _cache_config);
  for(int i =0; i< cache2.size(); i++){
	if(cache2[i]->is_valid() == false){
		
		cache2[i]->set_tag(tag);
		cache2[i]->read_data_from_memory(_memory);
		cache2[i]->mark_as_valid();
		cache2[i]->mark_as_clean();
		return cache2[i];
	}

	int temp = cache2[i]->get_last_used_time();
	if(temp < least_recently_used){
		least_recently_used = temp;
		lru = cache2[i];
	}
}
	if(lru->is_dirty()==true)
		lru->write_data_to_memory(_memory); 

	return lru;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */

   Cache::Block*  recent_block = find_block(address);
// cout<<"the address is"<< address<<endl;
// cout<<"the recentblock is "<< recent_block<<endl;
   if(recent_block == NULL){
	recent_block = bring_block_into_cache(address);
}
   _use_clock++;
   uint32_t temp = _use_clock.get_count();

   recent_block->set_last_used_time(temp);
    
  const CacheConfig& _cache_config2 = _cache->get_config();
   //uint32_t index2 = extract_index(address, _cache_config2);
  //uint32_t block_offset = _cache_config2.get_num_block_offset_bits();
   //extract_block_offset(uint32_t address, const CacheConfig& cache_config);
   uint32_t block_offset = extract_block_offset(address, _cache_config2);
   uint32_t output = recent_block->read_word_at_offset(block_offset);

   // cout<<"the output is "<<output<<endl;

   return output;
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */

  Cache::Block* found = find_block(address);

  if(!found){
	if(_policy.is_write_allocate()){
		found = bring_block_into_cache(address);
	}
	else{
		_memory->write_word(address,word);
		return;
	}
}

	uint32_t temp = found->get_last_used_time();
   	found ->set_last_used_time(temp);
	
	const CacheConfig& _cache_config2 = _cache->get_config();
	//uint32_t block_offset = _cache_config2.get_num_block_offset_bits();
	//write_word_at_offset(uint32_t data, uint32_t block_offset) 
	uint32_t block_offset = extract_block_offset(address, _cache_config2);
	found -> write_word_at_offset(word, block_offset);

	if(_policy.is_write_back()){
		found->mark_as_dirty();
	}
	else{
		//write_access(uint32_t address, uint32_t word) const;
		//write_data_to_memory(Memory *memory) 
		found->write_data_to_memory(_memory);
}
	
	return ;


}
