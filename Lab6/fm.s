# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr2.s

.data
# your test data goes here

.text
main:

	#addi	$6, $0, 100	# $6  =   100 (0x64)
	#addi	$7, $6, 155	# $7  =   255 (0xff)
	#add	$8, $6, $6	# $8  =   200 (0xc8)
	#sub	$9, $7, $8	# $9  =    55 (0x37)
	#sub	$10, $8, $7	# $10 =   -55 (0xffffffc9)
	#add	$11, $8, $6	# $11 =   300 (0x12c)
	#and	$12, $11, $7	# $12 =    44 (0x2c)
	#or	$13, $10, $7	# $13 =    -1 (0xffffffff)
	#xori	$14, $7, 0x5555 # $14 = 21930 (0x55aa)
	#sub	$15, $7, $13	# $15 =   256 (0x100)
	#add	$16, $6, $13	# $16 =    99 (0x63)
	#nor	$17, $15, $7	# $17 =  -512 (0xfffffe00)
	#add	$18, $17, $15	# $18 =  -256 (0xffffff00)
	#addi    $20, $0, 100    # $20 =    100 (0x64)
	#add     $20, $20, $18   # $20 =   -156(0xffffff64)

la	$2, array	# $2  = 0x10010000	testing lui
				      
	lw	$3, 12($2)	# $3  = 0xcafebabe	
	slt	$8, $3, $0	# $8  = 1	  	testing slt
	slt	$9, $2, $0	# $9  = 0
	slt	$10, $0, $2	# $10 = 1
	slt	$11, $2, $3	# $11 = 0

	bne	$9, $0, end
	beq	$11, $8, target

	lbu	$4, 12($2)	# $4 = be		test load byte unsigned
	lbu	$5, 13($2)	# $5 = ba
	lbu	$6, 14($2)	# $6 = fe
	lbu	$7, 15($2)	# $7 = ca

	sw	$0, 0($2)	#			test stores
	lw	$12, 0($2)	# $12 = 0
	sb	$4, 2($2)	
	lw	$13, 0($2)	# $13 = 0x00be0000

	addm	$18, $2, $2	# $18 = 0x10bf0000

	lw	$14, 16($2)	# $14 = target = 0x0000005c
	jr	$14  		#  PC = 0x0000005c	test indirect branches

skipped:
	addi	$15, $zero, 1	# skipped so $15 remains 0
	j	skipped	    	# skipped

end:	lui	$17, 0xf00f	# $17 = 0xf00f0000
	j	end

target:
	addi	$16, $zero, 2	# $16 = 2
	bne	$16, $0, end	# unconditional jump



	# your test code goes here
