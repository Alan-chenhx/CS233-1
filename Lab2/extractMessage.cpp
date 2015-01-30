/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include "extractMessage.h"

using namespace std;

string extractMessage(const bmp & image) {
	string message;
	

	// TODO: write your code here
	// http://en.cppreference.com/w/cpp/string/basic_string#Operations might be of use
	// because image is a const reference, any pixel you get needs to be stored in a const pointer
	// i.e. you need to do
	// const pixel * p = image(x, y);
	// just doing
	// pixel * p = image(x, y);
	// would give a compilation error
	int width = image.width();
	int height = image.height();
	int value;
	int LSB;
	int output[70000];
	int count =0;
	int temp =0;
	for(int x=0; x<width;x++){
		for(int y=0; x<height;x++){
		const pixel *p = image(x,y);
		if( p!= NULL){
			value = p->green;
			LSB = value & 1;
		}
		
		output[temp]=LSB;
		temp++;
	}
}
	for(int i=0;i<70000;i++){
	count = count+1;
			
	if(count==8){
	char out = (char)(output[i-7]+output[i-6]+output[i-5]+output[i-4]+output[i-3]+output[i-2]+output[i-1]+output[i]);
	count =0;
	if(out== 0){
	cout<<"Hello, I found you."<<endl;
	return message;
	}
	else{
	message += out;
	cout<<"Hello, I found you2."<<endl;
	}		
}
}
	


	return message;
}
