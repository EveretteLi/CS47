.include "./cs47_macro.asm"

.data
.align 1
var_a: .byte 0x10          # Type: char  (8-bit)
var_b: .half 0x3210        # Type: short (16-bit)
var_c: .byte 0x20          # Type: char  (8-bit)
var_d: .word 0x76543210    # Type: int   (32-bit)

# Compaction Order
#var_a: .byte 0x10          # Type: char  (8-bit)
#var_c: .byte 0x20          # Type: char  (8-bit)
#var_b: .half 0x3210        # Type: short (16-bit)
#var_d: .word 0x76543210    # Type: int   (32-bit)

.text
.globl main
main:
	# these are all pseudo instruction
	# MIPS natively supports only relative
	# address translation (e.g. lb $s0, 0x2345($gp))
	lb	$s0, var_a # R[s0] = M[var_a](7:0)	
	lh	$s1, var_b # R[s1] = M[var_b](15:0)
	lb      $s2, var_c # R[s2] = M[var_c](7:0)
	lw      $s3, var_d # R[s3] = M[var_d](31:0)
	
	# PUSH
	sw	$s0, 0x0($sp)	# Store the data stack pointing at
	addi	$sp, $sp, -4	# move the pointer downword
	sw	$s1, 0x0($sp)	# Store the data stack pointing at
	addi	$sp, $sp, -4	# move the pointer downword
	sw	$s2, 0x0($sp)	# Store the data stack pointing at
	addi	$sp, $sp, -4	# move the pointer downword
	sw	$s3, 0x0($sp)	# Store the data stack pointing at
	addi	$sp, $sp, -4	# move the pointer downword
	# POP
	addi	$sp, $sp, +4	# firs increase the stack pointer(now pointing at storage)
	lw	$t0, 0x0($sp)	# load word into register from the storage
	addi	$sp, $sp, +4	# firs increase the stack pointer(now pointing at storage)
	lw	$t1, 0x0($sp)	# load word into register from the storage
	addi	$sp, $sp, +4	# firs increase the stack pointer(now pointing at storage)
	lw	$t2, 0x0($sp)	# load word into register from the storage
	addi	$sp, $sp, +4	# firs increase the stack pointer(now pointing at storage)
	lw	$t3, 0x0($sp)	# load word into register from the storage
        
	# System exit
	exit
