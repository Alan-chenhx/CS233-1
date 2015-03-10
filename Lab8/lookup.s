## const char *
## lookup_word_in_trie(trie_t *trie, const char *word) {
##     if (trie == NULL) {
##         return NULL;
##     }
## 
##     if (trie->word) {
##         return trie->word;
##     }
## 
##     int c = *word - 'A';
##     if (c < 0 || c >= 26) {
##         return NULL;
##     }
## 
##     trie_t *next_trie = trie->next[c];
##     word ++;
##     return lookup_word_in_trie(next_trie, word);
## }

.globl lookup_word_in_trie
lookup_word_in_trie:

	li	$v0, 0
	beq 	$a0,$0, skip_1
	lw	$t0, 0($a0)	##get the address of the tried->word
	##lw	$t0, 0($t0)	get the actual value in tried->word
	bne	$t0, $0, return_1 
	
	lb	$t1, 0($a1)	##get the actual data that word point to
	sub	$t2, $t1, 'A'	## c

	blt	$t2, 0, skip_1
	bge	$t2, 26, skip_1


	mul	$t2, $t2, 4 ## mul by four get the offset
	add	$t2, $t2, $a0 ##get the total offset 
	lw	$a0, 4($t2) ##get the actual data of trie -> next[c]
	add	$a1, $a1, 1
	j	lookup_word_in_trie
	


	skip_1:
	jr	$ra

	return_1:
	move 	$v0, $t0
	jr	$ra

	
