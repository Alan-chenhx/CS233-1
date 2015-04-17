#include "cacheconfig.h"
#include "utils.h"
#include <iostream>

using namespace std;


CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */
   int temp1 = block_size;
   int assign = 1;


   //cout<<"block size is "<< block_size<<endl;

   for(int i =0; i< block_size; i++){
   		if(temp1/2 !=1){
   			assign += 1;
   			//cout<<"temp1 is "<<temp1<<endl;
   			temp1 = temp1/2;
   		}
   		else
   			break;
   }

   if(temp1 ==0){

      _num_block_offset_bits =  0;

	}
	else{
	  _num_block_offset_bits = assign;
	}
   //cout<<"number of offset_bits is "<< _num_block_offset_bits<< endl;

   if(_block_size==0 || associativity ==0 )
	return ;
   
   uint32_t temp = _size / _block_size;

   temp = temp/associativity;

   assign = 1;
   //cout<<"temp is "<<temp <<endl;
   for(int i =0; i<block_size; i++){
   		if(temp/2 != 1){
   			assign +=1;
   			//cout<<"temp is "<<temp <<endl;
   			temp = temp/2;
			//cout<< "temp is " << temp <<endl;
   		}

   		else
   			break;
   }

   if(temp ==0)
   {
   	_num_index_bits = 0;
   }
   else
   //cout<<"assign is " << assign<<endl;
   {
   _num_index_bits = assign;
	}
   //cout<<"number of index bits is"<<_num_index_bits <<endl;

   _num_tag_bits = 32 - _num_index_bits - _num_block_offset_bits; 

  //cout<<"number of tag bits is "<< _num_tag_bits <<endl;
}
