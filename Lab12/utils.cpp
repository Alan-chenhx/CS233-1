#include "utils.h"
#include <iostream>

using namespace std;



uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	
	
    //cout<<"address is "<< address <<endl;  

    int offset_size = cache_config.get_num_block_offset_bits();

    int index_size = cache_config.get_num_index_bits();

    int tag_size = cache_config.get_num_tag_bits();

    int N = offset_size + index_size;

    //int off_bit = address >> 31;

  //  if(N==0)
//	return address;

    if(tag_size>=32)
    	return address;


   //cout<<"the block_offset is "<< offset_size <<endl;
   //cout<<"the index_size is "<< index_size<< endl;
   //cout<<"the tag_size is "<< tag_size <<endl;

   address = (address>> (N));

   //cout <<"the address1 is "<< address <<endl;
 
   //address = (address >>(N+1));
   //cout<<"the address2 is "<< address <<endl; 	

 
   return address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  
   	int tag_size = cache_config.get_num_tag_bits();
	int offset_size = cache_config.get_num_block_offset_bits();

        //int index_size = cache_config.get_num_tag_bits();


	if(tag_size>=32)
    	return 0;


	address = address << tag_size;


    int total = tag_size + offset_size;


	//cout<<"tag_size is "<< tag_size <<endl;
	//cout<<"offset_size is "<<offset_size<< endl;


    address = address >> total;


   return address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
	int tag_size = cache_config.get_num_tag_bits();
	int index_size = cache_config.get_num_index_bits();


	if(tag_size>=32)
    	return 0;


	int total = tag_size + index_size;

	address = address << total;

	address = (address >> total);

  	return address;
}
