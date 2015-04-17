#include "cacheblock.h"
#include <iostream>

using namespace std;


uint32_t Cache::Block::get_address() const {
  // TODO
	
uint32_t index = _index; 
uint32_t tag   = get_tag();
cout<<"tag is "<< tag<< endl;


tag = tag >> index; 
cout<<"tag is "<< tag<< endl;
cout<<"index is "<<index<< endl;


tag += index;

cout<<"tag is "<< tag<< endl;

uint32_t shift = 32 - tag;

cout<<"tag is "<< tag<< endl;

tag  = tag << shift ; 

cout<<"tag is "<< tag<< endl;

return tag;
}
