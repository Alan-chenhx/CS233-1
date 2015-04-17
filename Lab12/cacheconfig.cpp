#include "cacheconfig.h"
#include "utils.h"

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 

   int temp1 = block_size;
   int assign = 1;

   for(int i =0; i< block_size; i++){
   		if(temp1/2 !=1){
   			temp1 = temp1/2;
   			assign += 1;
   		}
   		else
   			break;
   }

   _num_block_offset_bits =  assign;


   int temp = _size / _block_size ;

   temp = temp/associativity;
   assign = 1;

   for(int i =0; i<temp; i++){
   		if(temp/2!=1){
   			temp = temp/2;
   			assign +=1;
   		}

   		else
   			break;
   }


   _num_index_bits = assign;


   _num_tag_bits = 32 - _num_index_bits - _num_block_offset_bits; 

}
