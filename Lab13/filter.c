#include <stdio.h>
#include <algorithm>
#include <stdlib.h>
#include "filter.h"

using std::min;
using std::max;
/*
// modify this code by fusing loops together
void filter_fusion(pixel_t **image1, pixel_t **image2)
{
	for (int i = 1 ; i < SIZE-1 ; i++) {
		filter1(image1, image2, i);
	}
	
	for (int i = 2 ; i < SIZE-2 ; i ++) {
		filter2(image1, image2, i);
	}	
		
	for (int i = 1 ; i < SIZE-5 ; i ++) {
		filter3(image2, i);
	}		
}

// modify this code by adding software prefetching
void filter_prefetch(pixel_t **image1, pixel_t **image2)
{
	for (int i = 1 ; i < SIZE-1 ; i++) {
		filter1(image1, image2, i);
	}
	
	for (int i = 2 ; i < SIZE-2 ; i ++) {
		filter2(image1, image2, i);
	}	
		
	for (int i = 1 ; i < SIZE-5 ; i ++) {
		filter3(image2, i);
	}		
}


// modify this code by adding software prefetching and fusing loops together
void filter_all(pixel_t **image1, pixel_t **image2)
{
	for (int i = 1 ; i < SIZE-1 ; i++) {
		filter1(image1, image2, i);
	}
	
	for (int i = 2 ; i < SIZE-2 ; i ++) {
		filter2(image1, image2, i);
	}	
		
	for (int i = 1 ; i < SIZE-5 ; i ++) {
		filter3(image2, i);
	}		
}
*/


// modify this code by fusing loops together
void filter_fusion(pixel_t **image1, pixel_t **image2)
{
/*
	for (int i = 1 ; i < SIZE-1 ; i++) {
	if(i==1){
		filter1(image1, image2, i);
		//filter2(image1, image2, i);
		filter3(image2, i);

	}
	else
	   if(i< SIZE-5){
		filter1(image1, image2, i);
		filter2(image1, image2, i);
		filter3(image2, i);
	}
	else
	   if(i < SIZE-2){
		filter1(image1, image2, i);
		filter2(image1, image2, i);
			
	}
	else
		filter1(image1, image2, i);

	}
*/

	for (int i = 1 ; i < SIZE ; i++) {
		if(i<SIZE-1){
		filter1(image1, image2, i);			
	}

		if(i>1 && i<SIZE-2){
			filter2(image1, image2, i);
		}

		if(i<SIZE && i>5){
			filter3(image2, i-5);
	}

	}

	//for (int i = 1 ; i < SIZE-5 ; i ++) {
	//	filter3(image2, i);
	//}		


/*
	for (int i = 1 ; i < SIZE-1 ; i++) {
		filter1(image1, image2, i);
		for(int k = i; k<min(i+1,SIZE-5); k++){
				filter3(image2, k);
			for(int j =max(2,k); j<min(k+1, SIZE-2); j++){
				filter2(image1, image2, j);

			}
		}
	}

*/
}

// modify this code by adding software prefetching
void filter_prefetch(pixel_t **image1, pixel_t **image2)
{
	int temp = 0;
	for (int i = 1 ; i < SIZE-1 ; i++) {
		filter1(image1, image2, i);
		// __builtin_prefetch (&a[i+j], 1, 1);
    		//__builtin_prefetch (&b[i+j], 0, 1);
    		if(temp<i+10){
    			temp = i;
    	 		__builtin_prefetch ((image1[i+20]), 0);
    	 		__builtin_prefetch ((image2[i+20]), 1);
    		}
	}

	int temp2 = 0;
	for (int i = 2 ; i < SIZE-2 ; i ++) {
		filter2(image1, image2, i);
		if(temp2<i+10){
			temp2 = i;
		 	//__builtin_prefetch (&(*image1[i+40]), 0, 1);
    	 	//__builtin_prefetch (&(*image2[i+40]), 1, 0);
    	 	__builtin_prefetch ((image1[i+20]), 0);
    	 	__builtin_prefetch ((image2[i+20]), 1);
    		}
	}

	int temp3 = 0;
	for (int i = 1 ; i < SIZE-5 ; i ++) {
		filter3(image2, i);
		if(temp3<i+10){
			temp3 = i;
    	 		__builtin_prefetch ((image2[i+20]));
		}
	}
}


// modify this code by adding software prefetching and fusing loops together
void filter_all(pixel_t **image1, pixel_t **image2)
{



	
	for (int i = 1 ; i < SIZE ; i++) {
		if(i<SIZE-1){
		filter1(image1, image2, i);	
		__builtin_prefetch (&(*image1[i+20]), 0);
    	 	__builtin_prefetch (&(*image2[i+20]), 1);		
	}

		if(i>1 && i<SIZE-2){
			filter2(image1, image2, i);
			__builtin_prefetch (&(*image1[i+20]), 0);
    	 		__builtin_prefetch (&(*image2[i+20]), 1);
		}

		if(i<SIZE && i>5){
			filter3(image2, i-5);
			__builtin_prefetch (&(*image2[i+20]));
	}

	}
/*
	for (int i = 1 ; i < SIZE; i++) {

		if(i<SIZE-1){
		filter1(image1, image2, i);
    	 	//__builtin_prefetch (&(*image1[i+20]), 0);
    	 	//__builtin_prefetch (&(*image2[i+20]), 1);

		}

		if(i>1 && i<SIZE-2){
			filter2(image1, image2, i);
			//__builtin_prefetch (&(*image1[i+20]), 0);
    	 	//	__builtin_prefetch (&(*image2[i+20]), 1);
		}


		

		if(i>5 && i<SIZE){
		filter3(image2, i);
    	 	//__builtin_prefetch (&(*image2[i+20]));
		}

	}
*/
/*
	int temp2 = 0;
	for (int i = 1 ; i < SIZE-5 ; i ++) {
		filter3(image2, i);
		if(temp2 <i+10){
			temp2 = i;
    	 	__builtin_prefetch ((image2[i+20]), 1 ,0);
		}
	}		
*/
}

