/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include "extractMessage.h"
#include <math.h>
#include <array>
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
	int output[width*height];
	int count =0;

	for(int y=0; y<height;y++){
		for(int x=0; x<width;x++){
		const pixel *p = image(x,y);
		value = p->green;
		LSB = value & 1;
		output[count] = LSB;
		count++;
	}
}

		char out;
		count =0;
		for(int i=0; i<(width*height); i++){
		count++; 
		if(count==8){
		out = (char)((char)(output[i]) + ((char)output[i-1]<<1) + ((char)output[i-2]<<2) + ((char)output[i-3]<<3) + ((char)output[i-4]<<4) + ((char)output[i-5]<<5) + ((char)output[i-6] <<6) + ((char)output[i-7] <<7));
		if(out == 0){
		return message;
		}
		else{ 
		message += out;
		count = 0;
			}
		}
	}


/*	for(int i=0;i<(width*height);i++){
	count = count+1;	
	if(count==8){
	char out = (char)((output[i-7]>>7)+ (output[i-6]>>6) + (output[i-5]>>5) + (output[i-4]>>4) + (output[i-3]>>3) + (output[i-2]>>2) + (output[i-1]>>1) + (output[i]));
	count =0;
	cout<<message<<endl;
	if(out== 0){
	cout<<"Hello, I found you."<<endl;
	return message;
	}
	else{
	message += out;
	cout<<"Hello, I found you2."<<endl;
	}
	
	cout<<message<<endl;		
}
}
*/
	//cout<<message<<endl;
	return message;
}
