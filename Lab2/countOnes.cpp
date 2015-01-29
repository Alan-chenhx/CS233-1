/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	//unsigned oddCounter = 01010101010101010101010101010101;
	//unsigned evenCounter = 10101010101010101010101010101010;;
	
	unsigned temp1 = input & (0x55555555);//odd counter
	unsigned temp2 = ((input>>1) & (0x55555555)); //evenCounter
	input  = temp1 +temp2;
	temp1 = input & (0x33333333);//odd counter
	temp2 = ((input>>2) & (0x33333333)); //evenCounter
	input = temp1 + temp2;
	temp1 = input & (0x0f0f0f0f);//odd counter
	temp2 = ((input>>4) & (0x0f0f0f0f)); //evenCounter
	input = temp1 + temp2;
	temp1 = input & (0x00ff00ff);//odd counter
	temp2 = ((input>>8) & (0x00ff00ff)); //evenCounter
	input = temp1 + temp2;
	temp1 = input & (0x0000ffff);//odd counter
	temp2 = ((input>>16) & (0x0000ffff)); //evenCounter
	input = temp1 + temp2;
     	return input;
    
}
