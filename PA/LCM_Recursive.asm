.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)		# store m in $s0
	print_str(msg2)		
	read_int($s1)		# store n in $s1
	
	move $s3, $zero
	move $v0, $zero		# clear $v0
	move $a0, $s0		# m as first argument $a0
	move $a1, $s1		# n as second argument $a1
	move $a2, $s0		# lcm_m is first m in $a2
	move $a3, $s1		# lcm_n is first n in $a3
	jal  lcm_recursive	# run LCM_Recursive
	move $s3, $v0		# store return val in $s3
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:
	# Store frame 4*(5 + ra + fp) + sp(8) = 36
	addi $sp, $sp, -36
	sw $fp, 36($sp)		# push $fp current
	sw $ra, 32($sp)		# push $ra
	sw $a0, 28($sp)		# push $a0 m
	sw $a1, 24($sp)		# push $a1 n
	sw $a2, 20($sp)		# push $a2 lcm_m
	sw $a3, 16($sp)		# push $a3 lcm_n
	sw $s3, 12($sp)		# push v0 return val
	addi $fp, $sp, 36	# update $fp 
	
	# Body
	
	# (trivial) if lcm_m = lcm_n -> lcm found return lcm_m
	beq $a2, $a3, lcm_found		# if a2 and a3 are the same -> jump to return process with v0
	# esle if lcm_m < lcm_n -> not the lowest common multiple -> increse lcm_n
	subu $t1, $a3, $a2		# subtract a2 from a3: t1 < 0 -> lcm_m larger | t1 > 0 -> lcm_n larger
	bltz $t1, increase_lcm_n	# increase lcm_n by n if lcm_m is larger
	# else just increase lcm_m by m
	bgtz $t1, increase_lcm_m
increase_lcm_m:
	addu $a2, $a2, $a0		# lcm_m = lcm_m + m
	move $s3, $a2
	jal lcm_recursive		# recursive step change argument lcm_n and start new term
	j lcm_end
increase_lcm_n:
	addu $a3, $a3, $a1		# lcm_n = lcm_n + n
	move $s3, $a3
	jal lcm_recursive		# recursive step change argument lcm_n and start new term
	j lcm_end
lcm_found:
	move $v0, $s3
	j lcm_end			
	
	# Restore frame
lcm_end:
	lw $fp, 36($sp)		# pop fp
	lw $ra, 32($sp)		# pop ra
	lw $a0, 28($sp)		# pop m
	lw $a1, 24($sp)		# pop n
	lw $a2, 20($sp)		# pop lcm_m done finding it
	lw $a3, 16($sp)		# pop lcm_n done finding it
	lw $s3, 12($sp)		
	addi $sp, $sp, 36	# stack shink by 36 bit
	jr $ra
	
