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

# debugging memory-mapped I/O
PRINT_INT           = 0xffff0080


planet_info:
	.align 2
	.space 32

.text

main:
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST

x_loop1:	
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST
	lw	$t1,	0($t0)	##get the x-coordinates of the planet
	lw	$t2,	BOT_X	##get the x-coordinates of the robot
	blt	$t1, $t2, do_x1	##if the x_coordinate of the planet is on the left of robot, we go to left	-- 180
	bgt	$t1, $t2, do_x2	##if the x_coordinate of the planet is on the right of robot, we go to right	-- 0
	beq	$t1, $t2, do_z1 ##if the x_coordinate is the same, go to the y_coordinates

y_loop1:
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST
	lw	$t1,	4($t0)	##get the y-coordinates of the planet
	lw	$t2,	BOT_Y	##get the y-coordinates of the robot
	blt	$t1, $t2, do_y1 ## if the y_coordinate of the planet is less than  the y_coordinates of the robot, we go up  -- 270
	bgt	$t1, $t2, do_y2 ## if the y_coordinate of the planet is greater than  the y_coordinates of the robot, we go up  -- 90
	beq	$t1, $t2, do_z1	##if the y_coordinate is the same, go to the x_coordinates

z_loop1:
	la	$t0,	planet_info
	sw	$t0,	PLANETS_REQUEST
	lw	$t1,	0($t0)
	lw	$t2,	BOT_X
	lw	$t3,	0($t0)
	lw	$t4, 	BOT_Y
	bne	$t1,	$t2, 	do_x3
	bne	$t3,	$t4, 	do_y3
	j	x_loop1

do_x1:
	li	$t3, 	180		##go to 180 toward to planet
	sw	$t3, 0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	li	$t3,	4
	sw	$t3,  VELOCITY
	j     	x_loop1


do_x2:
	li	$t3, 	0			##go to the 0 angle toward the plnet, because the planet is on the right
	sw	$t3, 	0xffff0014($zero)	##save the angle to 0xffff0014
	li	$t3, 	1		##choose the absolute mode
	sw	$t3,	0xffff0018	##and store it in the address 0xffff0018
	li	$t3,	4
	sw	$t3, 	VELOCITY
	j	x_loop1

do_z1:
	j	z_loop1


do_y1:
		
	li	$t3, 	270		##go to 180 toward to planet
	sw	$t3, 	0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	li	$t3,	4
	sw	$t3, 	VELOCITY
	j     	z_loop1
	
do_y2:
		
	li	$t3, 90			##go to 180 toward to planet
	sw	$t3, 0xffff0014($zero) 	##save the angle to Oxffff0014
	li	$t3,	1		##choose the absolute mode
	sw	$t3, 	0xffff0018	##and store it in the address 0xffff0018
	li	$t1,	4
	sw	$t3, VELOCITY
	j     	z_loop1


do_x3:
	j	x_loop1


do_y3:
	j 	y_loop1

	
