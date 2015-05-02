#include <xmmintrin.h>
#include "mandelbrot.h"

// mandelbrot() takes a set of SIZE (x,y) coordinates - these are actually
// complex numbers (x + yi), but we can also view them as points on a plane.
// It then runs 200 iterations of f, using the (x,y) point, and checks
// the magnitude of the result.  If the magnitude is over 2.0, it assumes
// that the function will diverge to infinity.

// vectorize the below code using SIMD intrinsics
/*
int *
mandelbrot_vector(float x[SIZE], float y[SIZE]) {
	static int ret[SIZE];
	float x1, y1, x2, y2;

	for (int i = 0 ; i < SIZE ; i ++) {
		x1 = y1 = 0.0;

		// Run M_ITER iterations
		for (int j = 0 ; j < M_ITER ; j ++) {
			// Calculate the real part of (x1 + y1 * i)^2 + (x + y * i)
			x2 = (x1 * x1) - (y1 * y1) + x[i];

			// Calculate the imaginary part of (x1 + y1 * i)^2 + (x + y * i)
			y2 = 2 * (x1 * y1) + y[i];

			// Use the new complex number as input for the next iteration
			x1 = x2;
			y1 = y2;
		}

		// caculate the magnitude of the result
		// We could take the square root, but instead we just
		// compare squares
		ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);
	}

	return ret;
}
*/

int *
mandelbrot_vector(float x[SIZE], float y[SIZE]) {
	static int ret[SIZE];
	float temp[4], temp2[4];
	float x1, y1, x2, y2;
	__m128 acc, X_t, Y_t, X2_t, Y2_t, X_array, Y_array, two_array, MAGs;
	acc = _mm_set1_ps(0.0);
	
	float temp3[4]; 
	MAGs = _mm_set1_ps(M_MAG);
	MAGs = _mm_mul_ps(MAGs, MAGs);

		
	for(int i=0; i<4; i++)
		temp3[i] = 2.0;

		two_array = _mm_loadu_ps(temp3);


	for (int i = 0 ; i < SIZE ; i +=4) {
		x1 = y1 = 0.0;

		for(int k=0; k<4; k++){
			temp2[k] =0.0;
		}
	
		X_t = _mm_loadu_ps(temp2);
		Y_t = _mm_loadu_ps(temp2);

		X2_t =_mm_loadu_ps(temp2);

		Y2_t = _mm_loadu_ps(temp2);	
		X_array = _mm_loadu_ps(&x[i]);
		Y_array = _mm_loadu_ps(&y[i]);
		//M_array = _mm_load_ps(&M_MAG);
		

		// Run M_ITER iterations
		for (int j = 0 ; j < M_ITER ; j ++) {		
			// Calculate the real part of (x1 + y1 * i)^2 + (x + y * i)
			//x2 = (x1 * x1) - (y1 * y1) + x[i];

			X2_t = _mm_mul_ps(X_t, X_t);
			
			X2_t = _mm_sub_ps(X2_t, _mm_mul_ps(Y_t, Y_t));
			X2_t = _mm_add_ps(X2_t, X_array);

	
			Y2_t =  _mm_mul_ps(two_array, _mm_mul_ps(X_t, Y_t));
			Y2_t = _mm_add_ps(Y2_t, Y_array);
			
			// Calculate the imaginary part of (x1 + y1 * i)^2 + (x + y * i)
			//y2 = 2 * (x1 * y1) + y[i];

			// Use the new complex number as input for the next iteration
			//_mm_storeu_ps(X_t, X2_t);
			//_mm_storeu_ps(Y_t, Y2_t);
			X_t = X2_t;
			Y_t = Y2_t;
		}
		// caculate the magnitude of the result
		// We could take the square root, but instead we just
		// compare squares
		X2_t = _mm_mul_ps(X2_t, X2_t);
		Y2_t = _mm_mul_ps(Y2_t, Y2_t);
		acc  = _mm_add_ps(X2_t, Y2_t);

		//__m128 _mm_cmplt_ps(__m128 a, __m128 b)

		//ret[i] = ((x2 * x2) + (y2 * y2)) < (M_MAG * M_MAG);

	       acc = _mm_cmplt_ps(acc, MAGs);
		_mm_storeu_ps(temp, acc);
		ret[i] = temp[0];
		ret[i+1] = temp[1];
		ret[i+2] = temp[2];
		ret[i+3] = temp[3];
	}


	return ret;
}
