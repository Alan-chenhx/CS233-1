#include "cachesimulator.h"

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

   vector<Cache::Block*> cache1 = _cache->get_blocks_in_set(index);

	for(int i=0; i< cache1.size(); i++){
		if(cache1[i]->get_address() == address){
			_hits++;
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

   uint32_t least_recently_used = 0;
   Cache::Block * (&lru) = cache2[0]; 

  for(int i =0; i< cache2.size(); i++){
	if(cache2[i]->is_valid() == false){
		
		cache2[i]->set_tag(address);
		cache2[i]->read_data_from_memory(_memory);
		cache2[i]->mark_as_valid();
		cache2[i]->mark_as_clean();
		return cache2[i];
	}

	
	int temp = cache2[i]->get_last_used_time();
	if(temp > least_recently_used){
		least_recently_used = temp;
		lru = cache2[i];
	}
	}
	if(lru->is_dirty()==true)
		lru->write_data_to_memory(_memory); 

	return NULL  ;
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
   const CacheConfig& _cache_config2 = _cache->get_config();
   //uint32_t index2 = extract_index(address, _cache_config2);

   if(recent_block == NULL){
	recent_block = bring_block_into_cache(address);
}
   uint32_t temp = recent_block->get_last_used_time();
   recent_block->set_last_used_time(temp);
    
   uint32_t block_offset = _cache_config2.get_num_block_offset_bits();
   uint32_t output = recent_block->read_word_at_offset(block_offset);


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
}
