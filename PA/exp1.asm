.data
str:	.ascii	"the answer is = "

.text 
	li $v0, 4 	# System call code to print_str
	la $a0, str	# Address of the string to print
	syscall		# print the string
	
	li $v0, 1	# System call code to print_int
	li $a0, 5	# Integer to print
	syscall
	
	li $v0, 10	
	syscall