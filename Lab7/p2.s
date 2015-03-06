.text

## int
## vert_strncmp(const char* word, int start_i, int j) {
##     int word_iter = 0;
## 
##     for (int i = start_i; i < num_rows; i++, word_iter++) {
##         if (get_character(i, j) != word[word_iter]) {
##             return 0;
##         }
## 
##         if (word[word_iter + 1] == '\0') {
##             // return ending address within array
##             return i * num_columns + j;
##         }
##     }
## 
##     return 0;
## }

.globl vert_strncmp
vert_strncmp:

		sub 		$sp, $sp, 24	##preserve stack pointer for later use 
		sw 		$ra, 0($sp)  	##preserve for ra (return)
		sw 		$s0, 4($sp)  	##preserve for $a0  word
		sw 		$s1, 8($sp)  	##preserve for $a1  start_i
		sw 		$s3, 12($sp) 	##preserve for word_iter
		sw 		$s4, 16($sp) 	##preserve for num_rows
		sw 		$s2, 20($sp) 	##preserve for num_columns

		move 		$s0, $a0  	##word
		move 		$s1, $a1 	##start_i



		li 		$s3, 0   	#word_iter
		la 		$s4, num_rows 	#get the address of num_rows
		lw 		$s4, 0($s4)   	#get the num_rows

		move		$a0, $s1 	##set i = start_i set i in the $a0
		move 		$a1, $a2 	## set j in the $a1

loop_s:
		bge 	$a0, $s4, done_1 	##check the for loop condition 
		jal 	get_character   	##call the function
		add 	$t1, $s3, $s0  		##get the address of the word[word_iter]  it is &
		lb 	$t1, 0($t1)  		##get the character of the word[word_iter]
		bne 	$v0, $t1, done_1  	##compare the condition
		add 	$s3, $s3, 1  		##increment the word_iter counter
		add 	$t2, $s3, $s0  		##get the address of the word[word_iter+1]  it is &
		lb 	$t2, 0($t2)		##get the actual content at the beginning of the word[word_iter+1] 
		beq 	$t2, $0, done_2		##check the condition  word[word_iter + 1] == '\0'
		add     $a0, $a0, 1		##increment the i by one 
		j 	loop_s			##jump back to the loop 

		jr 	$ra


done_1:
		li 	$v0, 0   ##set the stack pointer originally 
        	lw      $ra, 0($sp)
        	lw      $s0, 4($sp)
        	lw      $s1, 8($sp)
        	lw      $s3, 16($sp)
        	lw      $s4, 20($sp)
        	lw      $s4, 24($sp)
        	add     $sp, $sp, 24
        	jr      $ra

done_2: 
##li $v0,0  ##set the stack pointer originally  
		mul     $v0, $a0, $s2
		add     $v0, $v0, $a1
		lw      $ra, 0($sp)
        	lw      $s0, 4($sp)
        	lw      $s1, 8($sp)
        	lw      $s3, 16($sp)
        	lw      $s4, 20($sp)
        	lw      $s4, 24($sp)
        	add     $sp, $sp, 24
		jr      $ra




## // assumes the word is at least 4 characters
## int
## horiz_strncmp_fast(const char* word) {
##     // treat first 4 chars as an int
##     unsigned x = *(unsigned*)word;
##     unsigned cmp_w[4];
##     // compute different offsets to search
##     cmp_w[0] = x;
##     cmp_w[1] = (x & 0x00ffffff); 
##     cmp_w[2] = (x & 0x0000ffff);
##     cmp_w[3] = (x & 0x000000ff);
## 
##     for (int i = 0; i < num_rows; i++) {
##         // treat the row of chars as a row of ints
##         unsigned* array = (unsigned*)(puzzle + i * num_columns);
##         for (int j = 0; j < num_columns / 4; j++) {
##             unsigned cur_word = array[j];
##             int start = i * num_columns + j * 4;
##             int end = (i + 1) * num_columns - 1;
## 
##             // check each offset of the word
##             for (int k = 0; k < 4; k++) {
##                 // check with the shift of current word
##                 if (cur_word == cmp_w[k]) {
##                     // finish check with regular horiz_strncmp
##                     int ret = horiz_strncmp(word, start + k, end);
##                     if (ret != 0) {
##                         return ret;
##                     }
##                 }
##                 cur_word >>= 8;
##             }
##         }
##     }
##     
##     return 0;
## }

.globl horiz_strncmp_fast
horiz_strncmp_fast:
			sub 		$sp, $sp, 40
			sw 		$ra, 0($sp)  ##preserve for ra (return address)
			sw 		$s0, 4($sp)  ##preserve for $a0 (word)
    			sw 		$s1, 8($sp)  ##preserve for $cmp_w[0]
			sw 		$s2, 12($sp) ##preserve for cmp_w[1]
			sw 		$s3, 16($sp) ##preserve for cmp_w[2]
			sw 		$s4, 20($sp) ##preserve for cmp_w[3]
			sw 		$s5, 24($sp) ##preserve for i
			sw 		$s6, 24($sp) ##preserve for j
			sw 		$s7, 28($sp) ##preserve for k
			##sw $s1, 8($sp)	##preserve for 

			li 		$s5, 0 ##initilized i to 0
			li 		$s6, 0 ##initilized j to 0
			li 		$s7, 0 ##initilized k to 0

			move 	$t1, $a0            	##let $t1 be x in this case	
			move 	$s1, $t1            	##store x into cmp_w[0]
			and 	$s2, $t1, 0x00ffffff   	##store x & 0x00ffffff into cmp_w[1]
			and 	$s3, $t1, 0x0000ffff	##store x & 0x0000ffff into cmp_w[2]
			and 	$s4, $t1, 0x000000ff  	##store x & 0x000000ff into cmp_w[3]
	

			##li $t4, 0          ##store the value 0 in $t4, initilized for i
for_loop1:	
		lw 	$t2, num_rows  	 	##store the num_rows in $t2
		lw 	$t3, num_columns 	##store the num_columns in $t3
		bge 	$s5, $t2, done_one
		lw 	$t4, puzzle
		##mul     $t5, $s5, 4
		mul 	$t5, $t3, $s5 		##get the value of i*num_columns
		add 	$t4, $t4, $t5 		##get the value of puzzle + i* num_columns-- array
		div 	$t5, $t3, 4  		##get the value num_columns/4 and store it in $t5
for_loop2:	
		bge 	$s6, $t5, done_two 	##check the condition for the middle loop
		mul 	$t0, $s6, 4       	##increment $t0 by four 
		add 	$t0, $t0, $t4  		##get the address of array[j]   array + j in address
		lw  	$t0, 0($t0)   		##get the content of array[j] ---- cur_word
		mul 	$t4, $t3, $s5  		##get the value of i*num_columns and store it in $t4
		mul 	$t5, $s6, 4 		##get the value of j*4 and store it in $t5  
		add 	$t4, $t4, $t5  		##get the sum of i*num_columns + j*4 and store it in $t4 --- start
		add 	$t5, $s5, 1 		##add 1 to i and store it in $t5
		mul 	$t5, $t5, $t3  		##int end = (i + 1) * num_columns 
		sub 	$t5, $t5, 1   		##int end = (i + 1) * num_columns - 1 -- end
for_loop3:
		bge 	$s7, 4, done_three  	##check the condition for the inner for_loop3
		mul 	$t7, $s7, 4   		##get the number of blocks need to add to the cmp_w, each is 4 byte
		add 	$t7, $s1, $t7  		## add it to the cmp_w, to get the address of that memory address
		lw 	$t7, 0($t7)   		##load the actual 4 byte content in that position
		bne 	$t7, $t0, done_four  	##check the condition for the if statement
		add 	$a1, $t4, $s7  		## get the value for start + k, and store it in $a1
		move 	$a2, $t5  		## store end to $a2
		jal 	horiz_strncmp
		beq 	$v0, 0, done_four  	##the return value from the calling function is already in $v0

		lw      $ra, 0($sp)
    		lw      $s0, 4($sp)
    		lw      $s1, 8($sp)
    		lw      $s2, 12($sp)
    		lw      $s3, 16($sp)
    		lw      $s4, 20($sp)
    		lw      $s4, 24($sp)
    		lw      $s5, 28($sp)
    		lw      $s6, 32($sp)
    		lw	$s7, 36($sp)

    		add     $sp, $sp, 40
		jr 		$ra

done_one:
		
		li 	$v0, 0 ##initilized return value to 0
		lw      $ra, 0($sp)
 	       	lw      $s0, 4($sp)
        	lw      $s1, 8($sp)
        	lw      $s2, 12($sp)
        	lw      $s3, 16($sp)
        	lw      $s4, 20($sp)
        	lw      $s4, 24($sp)
        	lw      $s5, 28($sp)
        	lw      $s6, 32($sp)
        	lw	$s7, 36($sp)

        	add     $sp, 	$sp, 40
		jr 	$ra

done_two:
		add 	$s5, $s5, 1  ##increment i by one
		j 	for_loop1

done_three:
		add 	$s6, $s6, 1  ##increment j by one
		j 	for_loop2

done_four:
		srl 	$t0, $t0, 8   ## cur_word right shift by 8 bits
		add 	$s7, $s7, 1  ##increment k by one
		j 	for_loop3


