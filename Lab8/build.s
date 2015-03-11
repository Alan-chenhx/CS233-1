## trie_t *
## build_trie(const char **wordlist, int num_words) {
##     trie_t *root = alloc_trie();
## 
##     for (int i = 0 ; i < num_words ; i ++) {
##         // start at first letter of each word
##         add_word_to_trie(root, wordlist[i], 0);
##     }
## 
##     return root;
## }

.globl build_trie
build_trie:
	sub	$sp, $sp, 20
	sw	$ra, 0($sp) ##store the return address
	sw	$s0, 4($sp) ##store the wordlist
	sw	$s1, 8($sp) ##store the num_words
	sw	$s2, 12($sp) ##store the value i
	sw	$s3, 16($sp) ##store the root

	move	$s1, $a1 ##store the value in the stack, so that we can use it later
	move	$s0, $a0 ##store the value in the stack

	jal alloc_trie

	move	$s3, $v0  ##store the return value to $a0
	li	$s2, 0	##set the value of i to one

start_loop:
	bge	$s2, $s1, skip_1	##check the condition 
	move	$a0, $s3    		##sat the argument $a0 to be root
	mul	$t1, $s2, 4  		##mul i by 4, since it is an integer type 
	add	$t1, $t1, $s0		##get the address of wordlist[i]
	move	$a1, $t1   		##set the second argument be wordlist[i]
	li	$a2, 0    		##set the third argument to be 0
	jal 	add_word_to_trie
	add	$s2, $s2, 1
	j	start_loop



skip_1:
	move $v0, $s3	 ##set up the return value
	lw	$ra, 0($sp) ##store the return address
	lw	$s0, 4($sp) ##store the wordlist
	lw	$s1, 8($sp) ##store the num_words
	lw	$s2, 12($sp) ##store the value i
	lw	$s3, 16($sp) ##store the root
	add	$sp, $sp, 20
	jr	$ra
