#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

/*
struct timeval
  {
    __time_t tv_sec;		
    __suseconds_t tv_usec;
  };
*/

// modify this function to add tiling
/*
void 
transpose_tiled(int** src, int** dest) {
	for (int i = 0 ; i < SIZE ; i ++) { 
		for (int j = 0 ; j < SIZE ; j ++) {
			dest[i][j] = src[j][i];
		} 
	}
	

}	*/
void 
transpose_tiled(int** src, int** dest) {

	clock_t begin, end;
	double used_time;

	begin = clock();

	for (int i = 0 ; i < SIZE ; i ++) { 
		for (int j = 0 ; j < SIZE ; j ++) {
			dest[i][j] = src[j][i];
		} 
	}
	end = clock();
	used_time = (double)(end - begin) / CLOCKS_PER_SEC;
	printf("The running time is %f\n ", used_time);

	begin = clock();
    for(int k=0; k< SIZE; k+=4){
	for(int x=0; x<SIZE; x+=4){
		for (int i = k ; i < min(i+4, SIZE); i ++) { 
			for (int j = x ; j < min(k+4, SIZE); j ++) {
				dest[i][j] = src[j][i];
			} 
		}
	}
}
	end = clock();
	used_time = (double)(end - begin) / CLOCKS_PER_SEC;
	printf("The running time for modified transpose is %f \n", used_time);

}	
