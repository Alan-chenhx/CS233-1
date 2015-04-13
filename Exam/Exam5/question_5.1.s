# run with QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *left;
#     node_t *right;
#     int *data;
# };
# void initialize(node_t *root, int value) {
#     if (root == NULL) {
#         return;
#     }
# 
#     if (root->data != NULL) {
#         *(root->data) = value;
#     }
# 
#     if (root->left != NULL) {
#         initialize(root->left, value);
#     }
# 
#     if (root->right != NULL) {
#         initialize(root->right, value);
#     }
# }
.globl initialize
initialize:

	sub	$sp,	$sp,	12
	sw	$ra,	0($sp)
	sw	$s0,	4($sp)	##for root
	sw	$s1,	8($sp)	##for value

	move	$s0,	$a0	##assign $s0 == root	
	move	$s1,	$a1	##assign $s1 == value

	beq	$s0,	$0, 	done_1
	
	lw	$t0,	8($s0)		##let $t0 = root->data
	bne	$t0,	$0,  do_1

continute:
	lw	$t1,	0($s0)	##let $t1 = root->left
	bne	$t1,	$0,	recursive_left

	lw	$t2,	4($s0)	##let $t2 = root->right
	bne	$t2,	$0,	recursive_right

	lw	$ra,	0($sp)
	lw	$s0,	4($sp)
	lw	$s1,	8($sp)
	add	$sp,	$sp,	12
	jr	$ra




recursive_left:
	move	$a0,	$t1	##let $a0 = root->left
	move	$a1,	$s1	##let $a1 = value
	jal	initialize   	

recursive_right:
	move	$a0,	$t2	##let $a0 = root->right
	move	$a1,	$s1	##let $a1 = value
	jal	initialize


do_1:
	sw	$s1,	0($t0)	##  *(root->data) = value;
	j 	continute	



done_1:
	lw	$ra,	0($sp)
	lw	$s0,	4($sp)
	lw	$s1,	8($sp)
	add	$sp,	$sp,	12
	jr	$ra

	
