# run with QtSpim -file main.s question_4.s

# void doublify(char *array1, char *array2) {
#     int i = 0;
#     char c = 0;
# 
#     do {
#         c = array1[i];
#         array2[2 * i] = array2[2 * i + 1] = c;
#         i++;
#     } while (c != 0);
# }
.globl doublify
doublify:

	li	$t0,	0	## int i = 0
	li	$t1,	0	## char c = 0
	
do_while:
	add	$t2,	$a0,	$t0 ##get the address of array1[i]
	lb	$t1,	0($t2)	    ##get the actural character at the array1[i] = c
	mul	$t3,	$t0,	2   ##get 2*i
	add	$t5,	$t3,	1   ##get 2*i+1

	add	$t4,	$a1,	$t3 ##get the address of array2[2*i]
	add	$t6,	$a1,	$t5 ##get the address of array2[2*i+1]

	sb	$t1,	0($t4)	##store word to array2[2*i]
	sb	$t1,	0($t6)	##store word to array2[2*i+1]
	add	$t0,	$t0,	1 ##increment the i ++
	beq	$t1,	0,	done_loop
	j	do_while

done_loop:
		jr   $ra
	
