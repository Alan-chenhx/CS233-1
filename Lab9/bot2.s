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



Sector_info:
	.align 2
	.space 256

.text

main:
	# your code goes here
	# for the interrupt-related portions, you'll want to
	# refer closely to example.s - it's probably easiest
	# to copy-paste the relevant portions and then modify them
	# keep in mind that example.s has bugs, as discussed in section
	li	$t4, SCAN_MASK		# scan interrupt enable bit
	or	$t4, $t4, ENERGY_MASK	# energy interrupt bit
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)

	li		$t0, 	0
	la		$t1,	Sector_info
	#sw 		$t0, 	SCAN_SECTOR($zero)
	#sw  	$t1,	SCAN_REQUEST($zero)
# request timer interrupt

	sw		$t0, SCAN_SECTOR		# read current SCAN_SECTOR


	#add	$t0, $t0, 50		# add 50 to current time
	#sw	$t0, TIMER		# request timer interrupt in 50 cycles

	#li	$a0, 10
	#sw	$a0, VELOCITY		# drive

infinite: 
	j      infinite


.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 16	# space for four registers
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

	# add dispatch for other interrupt types here.

	li	$v0, PRINT_INT	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall 
	j	done

SCAN_interrupt:
	
	sw	$a1, SCAN_ACKNOWLEDGE	# acknowledge interrupt

	move $t2, $zero
	bge $t2, 64, end
Finding:
	la $t1, sector_array
	sw $t2, SCAN_SECTOR($zero)
	sw $t1, SCAN_REQUEST($zero)
	add $t2, $t2, 1
	blt $t2, 64, Finding

end:
	j	interrupt_dispatch	# see if other interrupts are waiting




ENERGY_interrupt:
	sw	$a1, ENERGY_ACKNOWLEDGE	# acknowledge interrupt

	#li	$t0, 90			# ???
	#sw	$t0, ANGLE		# ???
	#sw	$zero, ANGLE_CONTROL	# ???

	lw	$v0, ENERGY		# current time
	add	$v0, $v0, 50000  
	sw	$v0, ENERGY		# request timer in 50000 cycles

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
.set noat
	move	$at, $k1		# Restore $at
.set at 
	eret


