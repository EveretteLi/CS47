#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     	# System call code for print_str  
	la	$a0, $arg   	# Address of the string to print
	syscall            	# Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     	# System call code for print_int
	li	$a0, $arg  	# Integer to print
	syscall            	# Print the integer
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
	# Macro : read_int
	# Usage: read_int(<address of int>)
	.macro read_int($reg)
	li	$v0, 5		# Load system call read_int
	syscall			# get the integer from user
	move	$reg, $v0	# move input to $reg register
	.end_macro
	
	# Macro : print_reg_int($reg)
	# Usage: print_reg_int(<address of register>)
	.macro print_reg_int($reg)
	move 	$a0, $reg	# move $reg to $a0 get ready for system call
	li	$v0, 1		# system call for print_int
	syscall			# print the integer at $a0
	.end_macro

	# Macro : swap_hi_lo
	# Usage: swap_hi_lo (<address of register>, <address of register>) 
	.macro swap_hi_lo($temp1, $temp2)
	mfhi $temp1		# move hi value into temp1
	mflo $temp2		# move lo value into temp2
	mthi $temp2		# move lo value into hi
	mtlo $temp1		# move hi value into lo
	.end_macro
	
	# Macro : print_hi_lo
	# Usage: print_hi_lo($strHi, $strEqual, $strComma, $strLo)
	.macro print_hi_lo($strHi, $strEqual, $strComma, $strLo)
	mfhi $t1		# t1 carrys hi
	mflo $t0		# t0 carrys lo
	print_str($strHi)	# print "Hi"
	print_str($strEqual)	# print "="
	print_reg_int($t1)	# print value in hi register
	print_str($strComma)	# print ","
	print_str($strLo)	# print "Lo"
	print_str($strEqual)	# print "="
	print_reg_int($t0)	# print value in lo register
	.end_macro
	
	# Macro : lwi takes two parts of a word and put them together
	# Usage: lwi($reg, $up, $lo)
	.macro lwi($reg, $up, $lo)
	lui $reg, $up		# first load upper part into reg
	ori $reg, $lo		# then load lower part of the reg
	.end_macro
	
	
	
	
	
	
