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
	addi	$sp, $sp, -24
	sw 	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw 	$s1, 8($sp)
	sw 	$s2, 12($sp)
	sw 	$s3, 16($sp)
	sw 	$s4, 20($sp)

	# Implement insertion sort (TBD)
	move 	$s0, $a0
	move 	$s1, $a1
	li 	$s2, 1 # i
	
	first_loop:
	# for(i = 1; i < length;i++)
	beq 	$s2, $s1, insertion_sort_end
	
	# *value = a[i];
	la 	$t0 ($s0)
	li 	$t1, 4
	mul 	$t2, $s2, $t1 # 4 * i
	add  	$t3, $t0, $t2 # get address from A[i]
	lw 	$s3, ($t3) # value = A[i]
	
	addi 	$s4, $s2, -1 #j = i-1
	
	second_loop:
	# for (j = i-1; j >= 0 && A[j-1] > A[j]; j--)
	addi 	$t0, $s4, 1 # j + 1 > 0 == j >=0
	beq 	$t0, $zero, end_second
	move 	$a0, $s3
	
	la $t0, ($s0)
	li $t1, 4
	mul $t2, $s4, $t1 # 4 * j
	add $t3, $t0, $t2 # get address from A[j]
	lw $a1, ($t3) # A[j] as argument
	
	# A[j-1] > A[j]
	blt $a1, $s3, end_second 
	addi $t1, $s4, 1
	beq $t1, $zero, end_second # j >= 0
	
	la $t0, ($s0)
	li $t1, 4
	mul $t2, $s4, $t1 # 4 * j
	add $t3, $t0, $t2 # get address from A[j]
	lw $t4, ($t3) # $t4 = A[j] for later
	
	move $t0, $s0
	li $t1, 4
	addi $t2, $s4, 1 # j + 1
	mul $t3, $t2, $t1 # 4 * (j + 1)
	add $t1, $t3, $t0 # get address from A
	sw $t4, ($t1) # A[j+1] = A[j]; A[j] == $t4
		
	addi $s4, $s4, -1 # j--
	j second_loop # end for(j)
	
	end_second:
	move $t0, $s0
	li $t1, 4
	addi $t2, $s4, 1 # j + 1
	mul $t4, $t2, $t1 # 4 * (j + 1)
	add $t1, $t4, $t0
	sw $s3, ($t1) # A[j+1] = value;
	
	addi $s2, $s2, 1 # i++
	j first_loop # for(i)
	
	insertion_sort_end:
	# Caller RTE restore (TBD)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24
	# Return to Caller
	jr $ra