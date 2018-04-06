.text
#-------------------------------------------
# Procedure: insertion_sort
# Argument: 
#	$a0: Base address of the array
#       $a1: Number of array element
# Return:
#       None
# Notes: Implement insertion sort, base array 
#        at $a0 will be sorted after the routine
#	 is done.
#-------------------------------------------

insertion_sort:
	# Caller RTE store (TBD)
	# fp ra a0 a1 s0 s1 s3 7 * 4 + 4
	addi	$sp, $sp, -32
	sw	$fp, 32($sp)
	sw	$ra, 28($sp)
	sw	$a0, 24($sp)
	sw	$s0, 20($sp)			# $s0 stores previous element
	sw	$s1, 16($sp)			# $s1 will be used in while
	sw	$s3, 12($sp)			# $s3 iteration counter
	sw	$a1, 8($sp)
	addi	$fp, $sp, 32
	# Implement insertion sort (TBD)
	
	add	$s0, $zero, $zero			# $s0 = 0
	add	$s0, $s0, $a0			# $s0 = $a0 address
	
what_in_s3:
	add	$s3, $zero, $zero			# use $t0 as counter -> i
	lw	$t1, 0($s0)			# $t1 = array[0]
	push($t1)				# push seen elements on stack
	addi	$s0, $s0, 4			# i++ -> address
	addi	$s3, $s3, 1			# increase counter -> i++
	
for:
	beq	$s3, $a1, insertion_sort_end	# if counter == number of elements -> end loop
	
	# get next
	lw	$t1, 0($s0)			# $t1 = array[i]
	# compare current with previous
	lw	$t2, 4($sp)			# $t2 = stack.peak()
	blt	$t1, $t2, while			# if: $t1 < $t2 -> go to the insertion part
						# else:
	addi	$s0, $s0, 4			# increase starting point of the array
	addi	$s3, $s3, 1			# i++
	j	for
while:
	beq	$s1, $a0, before_for		# while loop ends
	
	# already know $t1 < $t2 -> need to swap it first
	add	$s1, $zero, $zero		# $s1 will be use to track back address
	move	$s1, $s0			# $s1 = $s0 address
	pop($t2)				# $t2 = stack.pop()
	# swapping
	move	$t3, $t2			# $t3 = $t2
	move	$t2, $t1			# $t2 = $t1
	sw 	$t1, -4($s1)			# swap $t2, $t1 addressly
	move	$t1, $t3			# $t1 = $t3
	sw	$t3, 0($s1)			# swap 1, 2 by 3 addressly
	addi	$s1, $s1, -4			# move back
something_wrong_here:
	lw	$t2, 4($sp)			# $t2 = stack.peak()
	blt	$t1, $t2, while			# check while condition
	#	putting things back on stack
	push($t2)				# push back array[0]
	j	before_for
	
before_for:
	beq	$s1, $s0, for			# if catch up -> back to for loop
	addi	$s1, $s1, 4			# move $s1 addressly
	lw	$t1, 0($s1)			# $t1 = array[$s1]
	push($t1)
	j	before_for
	

	
insertion_sort_end:
	# Caller RTE restore (TBD)
	lw	$fp, 32($sp)
	lw	$ra, 28($sp)
	lw	$a0, 24($sp)
	lw	$a1, 20($sp)
	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s3, 8($sp)
	addi	$sp, $sp, 32
	# Return to Caller
	jr	$ra



