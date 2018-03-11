.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	move $a0, $t0 		# move the argument into $a0
	
# Write body of the iterative
# factorial program here
# Store the factorial result into 
# register $s0
#------------------------------------------
# Function: factorial
# Argument: 
#	$a0 : the number integrer number n
# Returns:
#	$v0 : factorial(n)
# purpose: 
#	To do the factorial in iteration manner
#------------------------------------------
fact:
	# sp(8byte-double word boundary) + fp + ra + a0(argument) + s0(result) = 20-byte
	addi	$sp, $sp, -20		# move $sp 
	sw   	$fp, 20($sp)		# 
	sw   	$ra, 16($sp)
	sw   	$a0, 12($sp)
	sw   	$s0,  8($sp)
	addi 	$fp, $sp, 20
	# preparing
	move $t3, $a0			# t3 will be used to store product
	addi $t2, $a0, -1		# t2 = t1 - 1
	
	# if t2 = 0 end iteration
while:	blez $t2, end_while		# if t2 is less than or equal to 0 -> end
	multu $t3, $t2		# t3(n) = t3(n) * t2(n-1)
	mfhi $t4
	mflo $t5
	or   $t3, $t4, $t5
	addi $t2, $t2, -1		# reduce t2 by 1
	j	while			# jump to while
	
end_while:
	move $s0, $t3			# store product into s0

	
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	# restore all the saved registers
	lw   	$fp, 20($sp)
	lw   	$ra, 16($sp)
	lw   	$a0, 12($sp)
	lw   	$s0,  8($sp)
	addi	$sp, $sp, 20
	
	exit
	
