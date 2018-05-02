.include "./cs47_proj_macro.asm"
# debug use
.data
	message1: .asciiz " _______________________\n"
	newLine: .asciiz "\n"

.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
	addi 	$sp, $sp, -40
	sw	$fp, 40($sp)
	sw	$ra, 36($sp)
	sw	$s0, 32($sp)
	sw	$s1, 28($sp)
	sw	$s2, 24($sp)
	sw	$s3, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp 40


	li	$t0, 43		#add
	li	$t1, 45		#sub
	li	$t2, 42		#mul
	li	$t3, 47		#div
	
	# read operation code then branch
	beq	$a2, $t0, addition
	beq	$a2, $t1, subtraction
	beq	$a2, $t2, multiplication
	beq	$a2, $t3, division
	j	end_function	# not any above -> end function
	addition:
	jal	add_logical
	j	end_function
	
	subtraction:
	jal	sub_logical
	j	end_function
	
	multiplication:
	jal	mul_signed
	j	end_function
	
	division:
	jal	div_signed
	j	end_function
	
	end_function:
	lw	$fp, 40($sp)
	lw	$ra, 36($sp)
	lw	$s0, 32($sp)
	lw	$s1, 28($sp)
	lw	$s2, 24($sp)
	lw	$s3, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	add 	$sp, $sp, 40
# TBD: Complete it
	jr 	$ra


#####################################################################
# Implement add_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
# Return:
#	$v0: ($a0+$a1)
#	$v1: overflow if any 
# Notes: add_logical add a0 and a1 together and return the sum in v0
#####################################################################
add_logical:
	addi	$sp, $sp, -24
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 24
	
	li	$t0, 0		# t0 = 0 hold a2
	li	$t1, 0		# t1 = 0 hold a1
	li	$t2, 0		# position pointer: insert bit answer in final answer(0-31)s1
	li	$t4, 0		# carry holder
	li	$t5, 0		# bit answer holder s2
	li	$t6, 0		# carry in for full adder s3
	add	$s0, $zero, $zero# is for saving the final outcome s0
	addLoop:
	beq	$t2, 32, end_addLoop
	extract_0th_bit($t0, $a0)	# t0 = a2.first_bit
	extract_0th_bit($t1, $a1)	# t1 = a1.first_bit
	full_adder($t0, $t1, $t5, $t4, $t6, $t8) # full adder: t5: bit answer, t8: carry out
	insert_to_nth_bit($s0, $t2, $t5, $t6) 	 # insert s2 at s1 posi of s0
	move	$t6, $t8 	# set carry in to be carry out of this turn
	addi	$t2, $t2, 1	# s1++
	j	addLoop
	
	end_addLoop:
	move	$v0, $s0	# move v0 = s0
	move	$v1, $t8	# move v1 = t8, which holds the overflow(last carry out)
	
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	add	$sp, $sp, 24
	jr	$ra
# End add_logical


#####################################################################
# Implement sub_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
# Return:
#	$v0: ($a0-$a1)
#	$v1: overflow if any 
# Notes: sub_logical add a0 and a1 together and return the result in v0
#####################################################################
sub_logical:
	addi	$sp, $sp, -20
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 20
	
	neg	$a1, $a1	# negate $a1
	jal	add_logical
	
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	add	$sp, $sp, 20
	jr	$ra
# End sub_logical

#####################################################################
# Implement mul_unsigned
# Argument:
# 	$a0: multiplicand
#	$a1: multiplier
# Return:
#	$v0: Lo result
#	$v1: Hi result 
# Notes: get product in 64 bit of a unsigned multiplication of a0 a1
#####################################################################
mul_unsigned:
	addi	$sp, $sp, -48
	sw	$s6, 48($sp)
	sw	$a1, 44($sp)
	sw	$a0, 40($sp)
	sw	$s5, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi $fp, $sp, 48
	
	move	$s6, $a1 # s6 = a1
	li	$s0, 0 # s0 for hi part of product
	li	$s1, 0 # s1 for lo part of product
	li	$s2, 0 # s2 for hi of MCND
	jal	twos_complement_if_neg	# unsigned mul -> |MCND|
	move	$s3, $v0 # s3 for lo of MCND
	move	$a0, $s6
	jal	twos_complement_if_neg	# unsigned mul -> |MPLR|
	move	$s5, $v0 # holder for MPLR cuz $a1 changes
	stop_s5:
	li	$s4, 0   # s4 as loop counter
	
	unsign_mul_loop:
	beq	$s4, 32, end_unsign_mul_loop
	beqz	$s5, end_unsign_mul_loop	# if MPLR run out -> exit
	# check for LSB of MCND
	extract_0th_bit($t0, $s5)
	beqz	$t0, shift_MCND_by_1
	# add product and MCND in 64 bit
	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	move	$a3, $s3
	jal	bit64_adder
	move	$s0, $v0
	move	$s1, $v1
	shift_MCND_by_1:
	# shift MCND left by 1
	move	$a0, $s2
	move	$a1, $s3
	jal	MCND_64bit_shift_left_by_1
	move	$s2, $v0
	move	$s3, $v1
	
	addi	$s4, $s4, 1
	j	unsign_mul_loop

	end_unsign_mul_loop:
	move	$v0, $s1
	move	$v1, $s0
	
	lw	$s6, 48($sp)
	lw	$a1, 44($sp)
	lw	$a0, 40($sp)
	lw	$s5, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi 	$sp, $sp, 48
	jr	$ra
# End_mul_unsigned

#####################################################################
# Implement mul_signed
# Argument:
# 	$a0: multiplicand
#	$a1: multiplier
# Return:
#	$v0: Lo result
#	$v1: Hi result 
# Notes: get product in 64 bit of a signed multiplication of a0 a1
#####################################################################
mul_signed:
	addi	$sp, $sp, -32
	sw	$s6, 32($sp)
	sw	$a1, 28($sp)
	sw	$a0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi 	$fp, $sp, 32
	
	# get the MSD for both a0, a1
	move	$t1, $a0
	move	$t2, $a1
	li	$t3, 31
	extract_nth_bit($t0, $t1, $t3)
	extract_nth_bit($t4, $t2, $t3)
	# see if they are same sign or not 
	# same -> positive, dif -> two's complement needed
	xor	$s6, $t0, $t4	# s6 save the result
	jal	mul_unsigned
	move	$s0, $v0	# Lo
	move	$s1, $v1	# Hi
	
	beqz	$s6, end_mul_signed
	move	$a0, $s0
	move	$a1, $s1
	jal	twos_complement_64bit
	move	$s0, $v0
	move	$s1, $v1
	
	end_mul_signed:
	move	$v0, $s0
	move	$v1, $s1
	
	lw	$s6, 32($sp)
	lw	$a1, 28($sp)
	lw	$a0, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi 	$sp, $sp, 32
	jr	$ra
# End_mul_signed

#####################################################################
# Implement div_unsigned
# Argument:
# 	$a0: dividend
#	$a1: divisor
# Return:
#	$v0: quotient
#	$v1: remainder 
# Notes: do unsigned division on a0 a1
#####################################################################
div_unsigned:

	addi	$sp, $sp, -40
	sw	$s4, 40($sp)
	sw	$s3, 36($sp)
	sw	$s2, 32($sp)
	sw	$s1, 28($sp)
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 40
	
	move	$s1, $a1	# s1 = a1 for divisor
	jal	twos_complement_if_neg
	move	$s0, $v0	# s0 = v0(|a0|) for dividend
	move	$a0, $s1
	jal	twos_complement_if_neg
	move	$s1, $v0	# s1 = v0(|a1|) for divisor
	li	$s2, 0		# s2 for quotient
	li	$s3, 0		# s3 for remainder
	li	$s4, 0		# s4 for loop counter
	
	# quotient = dividend
	move	$s2, $s0
	
	division_loop:
	beq	$s4, 32, end_division
	sll	$s3, $s3, 1	# remainder shift left by 1
	li	$t1, 31		# t1 = 31
	move	$t2, $s2	# t2 = s2
	# get the MSD from dividend insert it at LSD of remainder
	extract_nth_bit($t0, $t2, $t1)
	insert_to_nth_bit($s3, $zero, $t0, $t3)
	sll	$s2, $s2, 1	# shift dividend left by 1
	
	# t3 = remainder - divisor
	move	$a0, $s3
	move	$a1, $s1
	jal	sub_logical
	move	$t3, $v0
	
	bltz	$t3, not_large_enough
	# remainder = t3, remainder larger than divisor -> no longer remainder
	move	$s3, $t3
	# insert one to the quotation at the MSD(when finished)
	li	$t0, 1		# t0 = 1
	insert_to_nth_bit($s2, $zero, $t0, $t2)
	
	not_large_enough:
	addi	$s4, $s4, 1
	j	division_loop
	
	end_division:
	move	$v0, $s2 	# v0 = quotient
	move	$v1, $s3	# v1 = remainder
	
	lw	$s4, 40($sp)
	lw	$s3, 36($sp)
	lw	$s2, 32($sp)
	lw	$s1, 28($sp)
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 40
	jr	$ra
# End_div_unsigned

#####################################################################
# Implement div_signed
# Argument:
# 	$a0: dividend
#	$a1: divisor
# Return:
#	$v0: quotient
#	$v1: remainder 
# Notes: do unsigned division on a0 a1
#####################################################################
div_signed:
	addi	$sp, $sp, -40
	sw	$s4, 40($sp)
	sw	$s3, 36($sp)
	sw	$s2, 32($sp)
	sw	$s1, 28($sp)
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 40
	
	move	$t1, $a0
	move	$t2, $a1
	li	$t3, 31
	extract_nth_bit($s3, $t1, $t3)
	extract_nth_bit($s4, $t2, $t3)
	# see if they are same sign or not 
	# same -> positive, dif -> two's complement needed
	xor	$s0, $s3, $s4	# s0 save the result
	
	jal	div_unsigned
	move	$s1, $v0	# quotient
	move	$s2, $v1	# remainder
	
	beqz	$s0, check_remainder_sign
	move	$a0, $s1
	jal	twos_complement
	move	$s1, $v0	# 2'c the quo then s1 = v0
	
	check_remainder_sign:
	beqz	$s3, end_div_signed
	move	$a0, $s2
	jal	twos_complement
	move	$s2, $v0	# 2'c the rem then s2 = v0
	
	end_div_signed:
	move	$v0, $s1 	# v0 = quotient
	move	$v1, $s2	# v1 = remainder
	
	lw	$s4, 40($sp)
	lw	$s3, 36($sp)
	lw	$s2, 32($sp)
	lw	$s1, 28($sp)
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 40
	jr	$ra
# End_div_signed
	

#####################################################################
# Implement twos_complement
# Argument:
# 	$a0: number for 2's complement
# Return:
#	$v0: number in 2's complement
# Notes: 
#####################################################################
twos_complement:
	addi	$sp, $sp, -16
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 16
	
	not	$a0, $a0
	li	$a1, 1
	jal	add_logical
	
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp 16
	jr	$ra
# End twos_complement

#####################################################################
# Implement twos_complement_if_neg
# Argument:
# 	$a0: number for 2's complement
# Return:
#	$v0: number in 2's complement
# Notes: 
#####################################################################
twos_complement_if_neg:
	addi	$sp, $sp, -16
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 16
	
	li	$t1, 31
	move	$t2, $a0
	extract_nth_bit($t0, $t2, $t1)
	beqz	$t0, positive
	jal	twos_complement
	stop_v0:
	j	tcin_done
	
	positive:
	move	$v0, $a0
	
	tcin_done:
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp 16
	jr	$ra
# End twos_complement_if_neg

#####################################################################
# Implement twos_complement_64bit
# Argument:
# 	$a0: Lo number for 2's complement
#	$a1: Hi numnber for 2's complement
# Return:
#	$v0: Lo number in 2's complement
#	$v1: Hi number in 2's complement
# Notes: 
#####################################################################
twos_complement_64bit:
	addi	$sp, $sp, -28
	sw	$s1, 28($sp)
	sw	$s0, 24($sp)
	sw	$a1, 20($sp)
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp 28
	
	not	$a0, $a0	# invert a0
	not	$a1, $a1	# invert a1
	move	$s0, $a1	# s0 = a1
	li	$a1, 1
	jal	add_logical
first_add:
	move	$a0, $v1	# set a0 to the overflow bit
	move	$a1, $s0	# a1 = s0
	move	$s1, $v0	# save Lo part of 64bit 2'complement in s1
	jal	add_logical
second_add:
	move	$v1, $v0	# move Hi part of 64bit 2'complement in v1
	move	$v0, $s1
	
	lw	$s1, 28($sp)
	lw	$s0, 24($sp)
	lw	$a1, 20($sp)
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra
# End_twos_complement_64bit

#####################################################################
# Implement bit_replicator
# Argument:
# 	$a0: the bit value 0x0 or 0x1
# Return:
#	$v0: all 0 or all 1 for 32bit 
# Notes: convert the single bit input into the 32 bit output
#####################################################################
bit_replicator:
	addi	$sp, $sp -16
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 16
	
	extract_0th_bit($t0, $a0)
	beqz	$t0, end_br 	# if t0 = 0 t0 already the answer
	
	srl	$t0, $t0, 1	# know t1 should be all 0s
	move	$a0, $t0	# a0 = t0
	jal	twos_complement # $v0 is now all 1s
	
	end_br:
	move	$v0, $t0
	
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 16
	jr	$ra
# End_bit_replicator

#####################################################################
# Implement bit64_adder
# Argument:
# 	$a0: first hi
#	$a1: first lo
#	$a2: second hi
#	$a3: second lo
# Return:
#	$v0: hi
#	$v1: lo
# Notes: a 64 bit adder
#####################################################################
bit64_adder:
	addi	$sp, $sp, -36
	sw	$s5, 36($sp)
	sw	$s4, 32($sp)
	sw	$s3, 28($sp)
	sw	$s2, 24($sp)
	sw	$s1, 20($sp)
	sw	$s0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 36
	
	move	$s0, $a0	# s0 for Lo
	move	$s1, $a1	# s1 for Hi
	move	$s2, $a2	# s2 for Lo result
	move	$s3, $a3	# s3 for Hi result
	
	# add Los first 
	move	$a0, $s2
	move	$a1, $s0
	jal	add_logical
	move	$s2, $v0	# s2 = Lo result
	move	$t0, $v1	# carry out
	
	# first add Hi with carry out
	move 	$a0, $s3
	move	$a1, $t0
	jal	add_logical
	move	$s3, $v0	# get the temp result
	
	# know add hi part
	move 	$a0, $s3
	move	$a1, $s1
	jal	add_logical
	move	$s3, $v0	# s3 = Hi result
	
	# end
	move	$v0, $s2
	move	$v1, $s3
	
	lw	$s5, 36($sp)
	lw	$s4, 32($sp)
	lw	$s3, 28($sp)
	lw	$s2, 24($sp)
	lw	$s1, 20($sp)
	lw	$s0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 36
	jr 	$ra
# End_bit64_adder

#####################################################################
# Implement MCND_64bit_shift_left_by_1
# Argument:
# 	$a0: high part 32bits
#	$a1: low part 32bits
# Return:
#	$v0: hi part
#	$v1: lo part
# Notes: convert the single bit input into the 32 bit output
#####################################################################
MCND_64bit_shift_left_by_1:
	addi	$sp, $sp, -24
	sw	$s0, 24($sp)
	sw	$a1, 20($sp) 
	sw	$a0, 16($sp)
	sw	$ra, 12($sp)
	sw	$fp, 8($sp)
	addi	$fp, $sp, 24

	# get MSB of low part
	move	$s0, $a1# set s0 = low part
	li	$t1, 31	# shift by 31 to get the last bit
	extract_nth_bit($t0, $s0, $t1)
	sll	$a0, $a0, 1 # shift high part by one(make room)
	# shift high register by 1 then insert MSB from low
	insert_to_nth_bit($a0, $zero, $t0, $t1)
	sll	$a1, $a1, 1 # shift low register by 1
	
	move	$v0, $a0
	move	$v1, $a1
	
	lw	$s0, 24($sp)
	lw	$a1, 20($sp) 
	lw	$a0, 16($sp)
	lw	$ra, 12($sp)
	lw	$fp, 8($sp)
	addi	$sp, $sp, 24
	jr	$ra
# End_MCND_64bit_shift_left_by_1







































