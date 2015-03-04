.text

## char
## get_character(int i, int j) {
##     return puzzle[i * num_columns + j];
## }

.globl get_character
get_character:

	##la $t1, num_columns
	##lw $t1, 0($t1)
        ## $t1, num_columns($0)
        ##mul $a0,$a0,$t1
        ##add $a0,$a0,$a1
        ##la $t1, puzzle
	##lw $t1, 0($t1)
	##add $t0, $t1, $a0
        ##j final


	##final: 
	##lbu $v0, 0($t0)

	##jr	$ra

	la $t0, num_columns
	lw $t0, 0($t0) ##get the contents at the brginning of the columns
	la $t1, puzzle ##get the address of the puzzle
	lw $t1, 0($t1) ##get the contents of the beginning of the puzzle
	mul $t0, $a0, $t0 ##multiply i by num_columns
	add $t0, $t0, $a1 ##add j to it
	add $t1, $t1, $t0 ##get the i*num_columns+j th element of the puzzle
	j final ##return the value through $v0


	final:
	lbu $v0, 0($t1)

	jr $ra



## int
## horiz_strncmp(const char* word, int start, int end) {
##     int word_iter = 0;
## 
##     while (start <= end) {
##         if (puzzle[start] != word[word_iter]) {
##             return 0;
##         }
## 
##         if (word[word_iter + 1] == '\0') {
##             return start;
##         }
## 
##         start++;
##         word_iter++;
##     }
##     
##     return 0;
## }

.globl horiz_strncmp
horiz_strncmp:
	li $t0, 0 ##initialized(word_iter) $t0 ==0
	li $v0, 0 ##store the value 0 to the return value $v0
	la $t1, puzzle                  ##load the address of the puzzle 
	lw $t1, 0($t1)                  ##get the first element of the puzzle

str_loop: 
	bgt $a1, $a2, done1   ##check for the condition
	##la $t1, puzzle                  ##load the address of the puzzle 
	##lw $t1, 0($t1)                  ##get the first element of the puzzle
	##la $t2, word	                ## get the address of the word
	##lw $t2, 0($a0)	                ## get the first element of the word 

	add $t3, $t1, $a1               ##the pointer the puzzle[start]
	lb $t3, 0($t3)			##get the actual content in the $t3
	add $t4, $a0, $t0               ##the pointer to the word[word_iter]
	lb $t4, 0($t4)                  ##get the actual word in word[word_iter]
	bne $t3, $t4, done1             ##if they are equal, return immediately 
	add $t0,$t0, 1                  ##add one to word_iter
	add $t4, $a0, $t0               ##get the content at word[word_iter+1] 
	lb  $t4, 0($t4)

	beq $t4, $zero, done2              ##if word[word_iter] == 0, return start
	add $a1, $a1, 1                 ##increment the value of start
	j str_loop                      ##go back to the beginning of the loop
	jr $ra

	done1: 
	##j $v0
	jr $ra

	done2:
	move $v0, $a1
	##j $v0
	jr $ra

