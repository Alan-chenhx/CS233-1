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

		sub 		$sp, $sp, 28	##preserve stack pointer for later use 
		sw 		$ra, 0($sp)  	##preserve for ra (return)
		sw 		$s0, 4($sp)  	##preserve for $a0  word
		sw 		$s1, 8($sp)  	##preserve for $a1  i
		sw 		$s2, 12($sp) 	##preserve for $a2  j
		sw 		$s3, 16($sp) 	##preserve for word_iter
		sw 		$s4, 20($sp) 	##preserve for num_rows
		sw 		$s5, 24($sp)    ##preserve for num_columns

		li 		$s3, 0  	##initialized word_liter to 0
		lw 		$s4, num_rows 	##load the number of rows in $s4
		lw 		$s5, num_columns ##load the number of columns in $s5
		
		move 		$s1, $a1   	##set int i = start_i
		move 		$s2, $a2	##return 
		li 		$v0, 0 		##initialized the return value to 0
		move		$s0, $a0        ##copy the register $a0 (word) to the register $s0 ---  word		

	loop_1: 
		bge		$s1, $s4, done_1
		move 		$a0, $s1  	##copy the value i to the register $a0
		move 		$a1, $s2 	##copy the value j to the register $a1
		jal		get_character	##call the function get_character
		add		$t0, $s0, $s3   ##get the address of the word[word_iter]
		lb		$t0, 0($t0)     ##get the actual character in  the word[word_iter]
		beq 		$v0, $t0, done_2 ##if they are equal, we do the second if condition
		li		$v0, 0		##if get_character(i, j) != word[word_iter] return 0 


		lw      $ra, 0($sp)
        	lw      $s0, 4($sp)
        	lw      $s1, 8($sp)
        	lw      $s2, 12($sp)
        	lw      $s3, 16($sp)
        	lw      $s4, 20($sp)
		lw	$s5, 24($sp)
        	add     $sp, $sp, 28
		jr $ra 


	done_1:
		lw      $ra, 0($sp)
        	lw      $s0, 4($sp)
        	lw      $s1, 8($sp)
        	lw      $s2, 12($sp)
        	lw      $s3, 16($sp)
        	lw      $s4, 20($sp)
		lw	$s5, 24($sp)
        	add     $sp, $sp, 28
		jr	$ra
	
	done_2:
		add 	$s3, $s3, 1  	##increment word_iter by one
		add	$t1, $s3, $s0   ##get the address of word[word_iter + 1]
		lb	$t1, 0($t1)	##get the word at the position word[word_iter +1 ]
		bne	$t1, $0, done_3  ##if they are not equal do done_3
		mul	$v0, $s1, $s5   ##multily the i * num_columns
		add	$v0, $v0, $s2   ##get the number i*num_columns + j and store it in the register $v0

		lw      $ra, 0($sp)
        	lw      $s0, 4($sp)
        	lw      $s1, 8($sp)
        	lw      $s2, 12($sp)
        	lw      $s3, 16($sp)
        	lw      $s4, 20($sp)
		lw	$s5, 24($sp)
        	add     $sp, $sp, 28
		jr	$ra		##return 


	done_3:
		add	$s1, $s1, 1	##increment i by one
		j	loop_1




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
##             unsigned cur_word = array[j];   ##j need to multiply by four 
##             int start = i * num_columns + j * 4;
##             int end = (i + 1) * num_columns - 1;
## 
##             // check each offset of the word
##             for (int k = 0; k < 4; k++) {		##multiply k by 4
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

		
			sub 		$sp, $sp, 60
			sw 		$ra, 0($sp)  ##preserve for ra (return address)
			sw 		$s0, 4($sp)  ##preserve for $a0 (word)
    			sw 		$s1, 8($sp)  ##preserve for start
			sw 		$s2, 12($sp) ##preserve for end
			sw 		$s3, 16($sp) ##preserve for num_rows
			sw 		$s4, 20($sp) ##preserve for num_columns
			sw 		$s5, 24($sp) ##preserve for i
			sw 		$s6, 28($sp) ##preserve for j
			sw 		$s7, 32($sp) ##preserve for k
			sw		$t0, 36($sp) ##preserve for cur_word
			sw		$t6, 56($sp) ##preserve for array
			
			
			
			##lw		$a0, 0($a0)		
			move 		$s0, $a0		##store the in $s0 
		
			lw		$t5, 0($a0)		##$t1 == x, store the char* word to x				

			move		$t1, $t5		## assgin cmp_w[0] == x
			sw		$t1, 40($sp)
			and		$t1, $t5, 0x00ffffff 	## assign cmp_w[1] == x & 0x00ffffff
			sw		$t1, 44($sp)
			and		$t1, $t5, 0x0000ffff	## assign cmp_w[2] == x & 0x0000ffff
			sw		$t1, 48($sp) 
			and		$t1, $t5, 0x000000ff	## assign cmp_w[3] == x & 0x000000ff   --- $t5 can be reused
			sw		$t1, 52($sp)



			
			lw		$s3, num_rows		## get the number of rows and store it in $t0
			lw		$s4, num_columns	## get the number of columns and store it in $t1
			
			li 		$s5, 0			##initilized i to 0
			li		$s6, 0			##initilized j to 0
			li		$s7, 0			##initilized k to 0

	loop_first:
			bge		$s5, $s3, done_one	##reutrn 0 if this is true
			lw		$t5, puzzle		##get the address of puzzle
			mul		$t6, $s5, $s4		##get the address i * num_columns
			add		$t6, $t6, $t5		##get the address i * num_columns + puzzle   ----- array
			move		$s6, $0			##initialized j to 0


			

	loop_second:			
			div		$t5, $s4, 4		##divided the num_columns by four   reuse register 2
			bge		$s6, $t5, done_two	##check the loop2 condition
			mul		$t5, $s6, 4		##since it is unsinged which treat it as an inter, need to multiply $s6 by four
			add		$t0, $t6, $t5		## unsigned cur_word = array[j];  ----- cur_word
			lw		$t0, 0($t0)		##load the actual value in $t0
			mul		$t7, $s4, $s5		##get the value of i * num_columns
			mul		$t8, $s6, 4		##get the value of j *4  ---- $s6 can be reused
			add		$t7, $t7, $t8		##get the sum of $t5 and $t6  -- -- start   $t8 can be reused  --- start
			add		$t8, $s5, 1		##get i + 1
			mul		$t8, $t8, $s4  		##get (i + 1) * num_columns
			sub		$t8, $t8, 1		##get (i + 1) * num_columns -1                     --------------- end
			move		$s7, $0			##initilized k to 0

			
	loop_third:
			bge		$s7, 4, done_three	##check the condition of the most inner for loop
			mul		$t5, $s7, 4		##multiply k by four since it is unsigned, treat it as integer array
			add		$t9, $sp, 40		## get the address of the 40($sp)
			add		$t5, $t9, $t5		## get the address of the cmp_w[k] whatverer k is.
			lw		$t5, 0($t5)		##get the actual content in cmp_w[k]
			bne		$t0, $t5, done_four	##check of condition of the if statement
			move		$a0, $s0		##save argument valiable to a0
			add		$a1, $t7, $s7		##get the start+k and store it in a1
			move		$a2, $t8		##get the end and store it in a2
			jal		horiz_strncmp		##call the function
			beq		$v0, 0, done_four	##check the condition
		

			lw 		$ra, 0($sp)  ##preserve for ra (return address)
			lw 		$s0, 4($sp)  ##preserve for $a0 (word)
    			lw 		$s1, 8($sp)  ##preserve for start
			lw 		$s2, 12($sp) ##preserve for end
			lw 		$s3, 16($sp) ##preserve for num_rows
			lw 		$s4, 20($sp) ##preserve for num_columns
			lw 		$s5, 24($sp) ##preserve for i
			lw 		$s6, 28($sp) ##preserve for j
			lw 		$s7, 32($sp) ##preserve for k
			lw		$t0, 36($sp) ##preserve for cur_word
			lw		$t1, 40($sp) ##preserve for cmp_w[0]
			lw		$t2, 44($sp) ##preserve for cmp_w[1]
			lw		$t3, 48($sp) ##preserve for cmp_w[2]
			lw		$t4, 52($sp) ##preserve for cmp_w[3]
			sw		$t6, 56($sp) ##preserve for array
			add 		$sp, $sp, 60
			
			jr 		$ra




		done_one:
			li 		$v0, 0 	##initilized $v0 to 0

			lw 		$ra, 0($sp)  ##preserve for ra (return address)
			lw 		$s0, 4($sp)  ##preserve for $a0 (word)
    			lw 		$s1, 8($sp)  ##preserve for start
			lw 		$s2, 12($sp) ##preserve for end
			lw 		$s3, 16($sp) ##preserve for num_rows
			lw 		$s4, 20($sp) ##preserve for num_columns
			lw 		$s5, 24($sp) ##preserve for i
			lw 		$s6, 28($sp) ##preserve for j
			lw 		$s7, 32($sp) ##preserve for k
			lw		$t0, 36($sp) ##preserve for cur_word
			lw		$t1, 40($sp) ##preserve for cmp_w[0]
			lw		$t2, 44($sp) ##preserve for cmp_w[1]
			lw		$t3, 48($sp) ##preserve for cmp_w[2]
			lw		$t4, 52($sp) ##preserve for cmp_w[3]
			sw		$t6, 56($sp) ##preserve for array
			add 		$sp, $sp, 60
			
			jr 		$ra


		done_two:
			add 		$s5, $s5, 1 	 ##increment the outter for loop if the inner for loop is false
			j		loop_first
			
		done_three:
			add		$s6, $s6, 1 	##increment the middle for loop if the most inner for loop is false 
			j		loop_second
					
		done_four:
			srl		$t0, $t0, 8	##right shift cur_word by 8
			add		$s7, $s7, 1  	##increment the most inner for loop by one
			
			j		loop_third

		##done_5:
		##	srl		$t4, $t4, 8	##right shift cur_word by 8
		##	add		$s7, $s7, 1  	##increment the most inner for loop by one
			
		
		




			
