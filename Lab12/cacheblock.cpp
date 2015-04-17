#include "cacheblock.h"
#include <iostream>
#include <cstdint>
#include <vector>

using namespace std;


uint32_t Cache::Block::get_address() const {
  // TODO
	

int _num_block_offset_size = _cache_config.get_num_block_offset_bits();

int _num_index_size = _cache_config.get_num_index_bits();

//int _num_tag_size = _cache_config.get_num_tag_bits();


uint32_t index = _index; 
uint32_t tag   = get_tag();
cout<<"tag is "<< tag<< endl;


tag = tag << _num_index_size; 
cout<<"tag is "<< tag<< endl;
cout<<"index is "<<index<< endl;


tag += index;

cout<<"tag is "<< tag<< endl;

//int shift = 32 - _num_index_size- _num_block_offset_size;

//cout<<"tag is "<< tag<< endl;

tag  = tag << _num_block_offset_size; 

cout<<"tag is "<< tag<< endl;

return tag;
}
