.data

# movement memory-mapped I/O
VELOCITY            = 0xffff0010
ANGLE               = 0xffff0014
ANGLE_CONTROL       = 0xffff0018

# coordinates memory-mapped I/O
BOT_X               = 0xffff0020
BOT_Y               = 0xffff0024

# planet memory-mapped I/O
PLANETS_REQUEST     = 0xffff1014

# scanning memory-mapped I/O
SCAN_REQUEST        = 0xffff1010
SCAN_SECTOR         = 0xffff101c

# gravity memory-mapped I/O
FIELD_STRENGTH      = 0xffff1100

# bot info memory-mapped I/O
SCORES_REQUEST      = 0xffff1018
ENERGY              = 0xffff1104

# debugging memory-mapped I/O
PRINT_INT           = 0xffff0080

# interrupt constants
SCAN_MASK           = 0x2000
SCAN_ACKNOWLEDGE    = 0xffff1204
ENERGY_MASK         = 0x4000
ENERGY_ACKNOWLEDGE  = 0xffff1208  

# puzzle interface locations 
SPIMBOT_PUZZLE_REQUEST 		= 0xffff1000 
SPIMBOT_SOLVE_REQUEST 		= 0xffff1004 
SPIMBOT_LEXICON_REQUEST 	= 0xffff1008 

# I/O used in competitive scenario 
INTERFERENCE_MASK 	= 0x8000 
INTERFERENCE_ACK 	= 0xffff1304
SPACESHIP_FIELD_CNT  	= 0xffff110c 



Sector_info:
	.align 2
	.space 256



planet_info:
	.align 2
	.space 32

#to tell wether the scan complete or not 
scan_flag:
	.space	4


.text

main:
	# your code goes here
	# for the interrupt-related portions, you'll want to
	# refer closely to example.s - it's probably easiest
	# to copy-paste the relevant portions and then modify them
	# keep in mind that example.s has bugs, as discussed in section
	li	$t4, SCAN_MASK		# scan interrupt enable bit
	or	$t4, $t4, ENERGY_MASK	# energy interrupt bit
	or	$t4, $t4, INTERFERENCE_MASK ##competitive interrupt bit
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)

	li      $t1, 0			#iterator 0->63
	li      $t2, 0                 	#t2 holds max number of dust
        li      $t3, 0                  #t3 holds sector # of max
	sw	$0, scan_flag


start_scan:
        sw      $t1, SCAN_SECTOR
        la      $t0, Sector_info	        #get address of sector info
        sw      $t0, SCAN_REQUEST


wait_for_scan:
	lw	$t5,	scan_flag
	beq	$t5,	1,	go_through
	j	wait_for_scan 


go_through:
	mul     $t4, $t1, 4
        add     $t4, $t4, $t0
        lw      $t5, 0($t4)		#get number of dust particles

	ble     $t5, $t2, after		#check to see if there is a new max
        move    $t2, $t5                #update highest number
        move    $t3, $t1                #update which sector

after:  
	add     $t1, $t1, 1		#update iterator
	sw	$t5,	PRINT_INT
	sw	$0, 	scan_flag
        bne     $t1, 64, start_scan     #keep scanning if not 64	
	
       
	li	$t1,	8
	div	$t3,	$t1
	mfhi	$t4	##to get the value $t4 = sector_number %8
	mflo	$t5	##to get the value $t5 = sector_number /8
	
	li	$t6, 	18
	li	$t7,	300
	div	$t7,	$t1  
	mflo	$t8    		##get the number 300 /8
	mul	$t4,	$t8,	$t4  ##get the x_coordinate of the sector
	add	$t4,	$t4,	18	##get to the center of the sector
	
	mul	$t5,	$t5,	$t8  ##get the y_coordinate of the sector
	add	$t5,	$t5,	18	##get to the center of the sector



x_loop1:	

	lw	$t2,	BOT_X	##get the x-coordinates of the robot
	blt	$t4, $t2, do_x1	##if the x_coordinate of the planet is on the left of robot, we go to left	-- 180
	bgt	$t4, $t2, do_x2	##if the x_coordinate of the planet is on the right of robot, we go to right	-- 0
	beq	$t4, $t2, do_z1 ##if the x_coordinate is the same, go to the y_coordinates

y_loop1:

	lw	$t2,	BOT_Y	##get the y-coordinates of the robot
	blt	$t5, $t2, do_y1 ## if the y_coordinate of the planet is less than  the y_coordinates of the robot, we go up  -- 270
	bgt	$t5, $t2, do_y2 ## if the y_coordinate of the planet is greater than  the y_coordinates of the robot, we go up  -- 90
	beq	$t5, $t2, z_loop1	##if the y_coordinate is the same, go to the x_coordinates

z_loop1:

	j	move_dust


do_z1:
	j	y_loop1

do_x1:
	li	$t3, 	180		##go to 180 toward to planet
	sw	$t3, 	0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	li	$t3,	10
	sw	$t3,  VELOCITY
	j     	x_loop1


do_x2:
	li	$t3, 	0			##go to the 0 angle toward the plnet, because the planet is on the right
	sw	$t3, 	0xffff0014($zero)	##save the angle to 0xffff0014
	li	$t3, 	1		##choose the absolute mode
	sw	$t3,	0xffff0018	##and store it in the address 0xffff0018
	li	$t3,	10
	sw	$t3, 	VELOCITY
	j	x_loop1


do_y1:
		
	li	$t3, 	270		##go to 270 toward to planet
	sw	$t3, 	0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	li	$t3,	10
	sw	$t3, 	VELOCITY
	j     	y_loop1
	
do_y2:
		
	li	$t3, 90			##go to 90 toward to planet
	sw	$t3, 0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	li	$t1,	10
	sw	$t3, VELOCITY
	j     	y_loop1


move_dust:
	
	li	$v0,	10
	sw	$v0,	FIELD_STRENGTH  
	li	$v0,	5
	sw	$v0,	VELOCITY 

x_loop11:	
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST
	lw	$t1,	0($t0)	##get the x-coordinates of the planet
	lw	$t2,	BOT_X	##get the x-coordinates of the robot
	blt	$t1, $t2, do_x11	##if the x_coordinate of the planet is on the left of robot, we go to left	-- 180
	bgt	$t1, $t2, do_x21	##if the x_coordinate of the planet is on the right of robot, we go to right	-- 0
	beq	$t1, $t2, z_loop11 ##if the x_coordinate is the same, go to the y_coordinates

y_loop11:
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST
	lw	$t1,	4($t0)	##get the y-coordinates of the planet
	lw	$t2,	BOT_Y	##get the y-coordinates of the robot
	blt	$t1, $t2, do_y11 ## if the y_coordinate of the planet is less than  the y_coordinates of the robot, we go up  -- 270
	bgt	$t1, $t2, do_y21 ## if the y_coordinate of the planet is greater than  the y_coordinates of the robot, we go up  -- 90
	beq	$t1, $t2, z_loop11	##if the y_coordinate is the same, go to the x_coordinates

z_loop11:
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST
	lw	$t1,	0($t0)
	lw	$t2,	BOT_X
	lw	$t3,	0($t0)
	lw	$t4, 	BOT_Y
	bne	$t1,	$t2, 	do_x31
	bne	$t3,	$t4, 	do_y31

	li	$v0,	0
	sw	$v0,	FIELD_STRENGTH  
	li	$v0,	10
	sw	$v0,	VELOCITY 

	j	x_loop1

do_x11:
	li	$t3, 	180		##go to 180 toward to planet
	sw	$t3, 0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	#li	$t3,	10
	#sw	$t3,  VELOCITY
	j     	x_loop11


do_x21:
	li	$t3, 	0			##go to the 0 angle toward the plnet, because the planet is on the right
	sw	$t3, 	0xffff0014($zero)	##save the angle to 0xffff0014
	li	$t3, 	1		##choose the absolute mode
	sw	$t3,	0xffff0018	##and store it in the address 0xffff0018
	#li	$t3,	10
	#sw	$t3, 	VELOCITY
	j	x_loop11



do_y11:
		
	li	$t3, 	270		##go to 270 toward to planet
	sw	$t3, 	0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	#li	$t3,	10
	#sw	$t3, 	VELOCITY
	j     	z_loop11
	
do_y21:
		
	li	$t3, 90			##go to 90 toward to planet
	sw	$t3, 0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	#li	$t1,	4
	#sw	$t3, VELOCITY
	j     	z_loop11


do_x31:
	j	x_loop11


do_y31:
	j 	y_loop11


infinite: 
	j      infinite




.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 20	# space for four registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at                               
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers                  
	sw	$a1, 4($k0)		# by storing them to a global variable     
	sw	$v0, 8($k0)
	sw	$t0, 12($k0)
	sw	$t1, 16($k0)

	mfc0	$k0, $13		# Get Cause register                       
	srl	$a0, $k0, 2                
	and	$a0, $a0, 0xf		# ExcCode field                            
	bne	$a0, 0, non_intrpt         

interrupt_dispatch:			# Interrupt:                             
	mfc0	$k0, $13		# Get Cause register, again                 
	beq	$k0, 0, done		# handled all outstanding interrupts     

	and	$a0, $k0, SCAN_MASK	# is there a SCAN interrupt?                
	bne	$a0, 0, SCAN_interrupt   

	and	$a0, $k0, ENERGY_MASK	# is there a ENERGY interrupt?
	bne	$a0, 0, ENERGY_interrupt

	and	$a0, $k0, INTERFERENCE_MASK #is there a competitive interrupt?
	bne	$a0, 0, COMPETITIVE_interrupt

	# add dispatch for other interrupt types here.

	li	$v0, PRINT_INT	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

SCAN_interrupt:
	
	sw	$a1, 	SCAN_ACKNOWLEDGE	# acknowledge interrupt
	#lw	$t1,	0(scan_flag)	#check the flag of the scan_flag
	#beq	$t1,	1,	complete_scan #if the flag is raise, we know the scan is complete	
	li	$t1,	1
	sw	$t1,	scan_flag
	j	interrupt_dispatch	# see if other interrupts are waiting


COMPETITIVE_interrupt:
	sw	$a1,   INTERFERENCE_ACK     # acknowledge interrupt


	j	interrupt_dispatch	# see if other interrupts are waiting




ENERGY_interrupt:
	sw	$a1, ENERGY_ACKNOWLEDGE	# acknowledge interrupt

	j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
	li	$v0, PRINT_INT
	la	$a0, non_intrpt_str
	syscall				# print out an error message
	# fall through to done

done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
	lw	$v0, 8($k0)
	lw	$t0, 12($k0)  
	lw	$t1, 16($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret



