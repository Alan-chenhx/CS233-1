## void
## add_word_to_trie(trie_t *trie, const char *word, int index) {
##     char c = word[index];
##     if (c == 0) {
##         trie->word = word;
##         return;
##     }
## 
##     if (trie->next[c - 'A'] == NULL) {
##         trie->next[c - 'A'] = alloc_trie();
##     }
##     add_word_to_trie(trie->next[c - 'A'], word, index + 1);
## }

.globl add_word_to_trie
add_word_to_trie:
	sub	$sp, $sp, 24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp) ##preserve for c
	sw	$s1, 8($sp) ##preserve for trie
	sw	$s2, 12($sp) ##preserve for word
	sw	$s3, 16($sp) ##preserve for index


	move	$s1, $a0  	## trie
	move	$s2, $a1	## word
	move 	$s3, $a2	## index


	add		$t0, $a1, $a2   ##get the address of the word[index]
	lb 		$s0, 0($t0)     ##get the char in that address
	beq		$s0, $0, skip_1 ## $s0 is the char c
	

	sub		$t1, $s0, 'A'   ##to get the c - 'A' 
	mul		$t1, $t1, 4     ##treat it as an integer type, mul by four
	add 		$t1, $t1, 4
	add		$t1, $a0, $t1	##get the address of the &trie+4+ (c-'A')*4 
	sw		$t1, 20($sp)
	lw		$t1, 0($t1)     ##get the value of trie->next[c - 'A']
					##move	$s1, $t1	##store the argument value to $s1, so that we can use later
					##sw		$a0, 20($sp)
	beq		$t1, $0, skip_2 ##check the condition
	move		$a0, $t1
					##move 	$a0, $s1

j_shape:
	move		$a1, $s2	##copy the value word back to $a1
	add     	$s3, $s3, 1
	move 		$a2, $s3  	##index ++   $a0 and $a1 are set already
	lw		$ra, 0($sp)
	lw		$s0, 4($sp) ##preserve for c
	lw		$s1, 8($sp) ##preserve for trie
	lw		$s2, 12($sp) ##preserve for word
	lw		$s3, 16($sp) ##preserve for index
	add		$sp, $sp, 24
	j 		add_word_to_trie



skip_1:
	#lw		$t1, 0($a0) ##get the address of the 0($a0)   trie->word
	#move		$t1, $a1   ##copy the contents to the address 0($a0)    trie->word
	sw 		$a1, 0($a0)
	#sw		$t1, 0($a0)
	lw		$ra, 0($sp)
	lw		$s0, 4($sp) ##preserve for c
	lw		$s1, 8($sp) ##preserve for trie
	lw		$s2, 12($sp) ##preserve for word
	lw		$s3, 16($sp) ##preserve for index
	add		$sp, $sp, 24
	jr		$ra

skip_2:	
	jal		alloc_trie
	lw		$t1, 20($sp)
	sw		$v0, 0($t1)
	##move		$s1, $v0
	move		$a0, $v0	##copy the value return from the function to $a0
	j		j_shape

		
		
		
