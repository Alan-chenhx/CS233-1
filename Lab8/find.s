## void
## find_words(const char** dictionary, int dictionary_size) {
##     for (int i = 0; i < num_rows; i++) {
##         for (int j = 0; j < num_columns; j++) {
##             int start = i * num_columns + j;
##             int end = (i + 1) * num_columns - 1;
## 
##             for (int k = 0; k < dictionary_size; k++) {
##                 const char* word = dictionary[k];
##                 int word_end = horiz_strncmp(word, start, end);
##                 if (word_end > 0) {
##                     record_word(word, start, word_end);
##                 }
## 
##                 word_end = vert_strncmp(word, i, j);
##                 if (word_end > 0) {
##                     record_word(word, start, word_end);
##                 }
## 
##             }
##         }
##     }
## }

.globl find_words
find_words:
	sub	$sp,	$sp, 	48
	sw	$ra,	0($sp)
	sw	$s0, 	4($sp) 		##preserve for i
	sw	$s1,	8($sp)		##preserve for j
	sw	$s2,	12($sp)		##preserve for k
	sw	$s3,	16($sp)		##preserve for dictionary
	sw	$s4, 	20($sp)		##preserve for dictionary_size
	sw	$s5, 	24($sp)		##preserve for word
	sw	$s6,	28($sp)		##preserve for start


	li	$s0,	0
	li	$s1,	0
	li	$s2,	0
	move	$s3,	$a0	##dictionary
	move	$s4,	$a1	##dictionary_size

	lw	$t0,	num_rows
	sw	$t0,	32($sp)   	##save num_rows in stack 36  ---- num_rows
	lw	$t0,	num_columns	
	sw	$t0, 	36($sp)		##save num_columns in stack 40  ---- num_columns



outer_loop:
	lw	$t0,	32($sp)		##num_rows
	bge	$s0,	$t0,	return 	##i < num_rows

middle_loop:
	lw	$t1,	36($sp)		##num_columns
	bge	$s1,	$t1,	return_outer_loop	##j < num_columns
	mul	$t2,	$s0,	$t1	##i * num_columns
	add	$s6,	$t2,	$s1	##i * num_columns + j  --- start
	add	$t2,	$s0,	1 	##i+1
	mul	$t2,	$t2,	$t1	##(i+1) * num_columns
	sub	$t2,	$t2,	1 	##(i+1) * num_columns - 1  ---- end
	sw	$t2,	40($sp)		##store  end  to  stack 

inner_loop:
	bge	$s2,	$s4,	return_middle_loop	## k < dictionary_size
	mul	$t3,	$s2,	4 	##k * 4
	la	$t4,	0($s3)		##get the address of dictionary[0]
	add 	$s5,	$t4, 	$t3	##get the dictionary[k] ---- word
	move	$a0,	$s5		##copy word to $a0
	move	$a1,	$s6		##copy start to $a1
	lw	$a2,	40($sp)		##get the end back from memory and store it at $a2	
	jal	horiz_strncmp 		##call the function
	sw	$v0,	44($sp)		##store the return_value to stack --- word_end
	bgt	$v0, 	$0,	skip_one	##check the condition
j_cond1:
	move	$a0,	$s5		##load the word to $a0
	move	$a1,	$s0		##load the i to $a1
	move	$a2,	$s1		##load the j to $a2
	jal	vert_strncmp		##call the function
	bgt	$v0,	$0,	skip_two       ##call the function again 		

j_cond2:
	add 	$s2,	$s2,	1 	##increment the k by one --- k++ 
	j 	inner_loop		##go back to the inner_loop



return:
	
		lw	$ra,	0($sp)
		lw	$s0, 	4($sp) 		##preserve for i
		lw	$s1,	8($sp)		##preserve for j
		lw	$s2,	12($sp)		##preserve for k
		lw	$s3,	16($sp)		##preserve for dictionary
		lw	$s4, 	20($sp)		##preserve for dictionary_size
		lw	$s5, 	24($sp)		##preserve for word
		lw	$s6,	28($sp)		##preserve for start
		add	$sp,	$sp, 	48
		jr	$ra

return_outer_loop:
		add	$s0,	$s0,	1 	##i ++
		j 	outer_loop

return_middle_loop:
		add	$s1,	$s1,	1 	##j ++
		j 	middle_loop


skip_one:
		move	$a0,	$s5		##load the word back from stack
		move	$a1,	$s6		##move start to $a1
		lw	$a2,	44($sp)		##move word_end to $a2
		jal	record_word		##call the function
		j 	j_cond1

skip_two:
		move	$a0,	$s5
		move	$a1,	$s6
		move	$a2,	$v0
		jal	record_word
		j 	j_cond2


