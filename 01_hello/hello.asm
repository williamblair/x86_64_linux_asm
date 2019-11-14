# hello world asm
# compile with:
#	nasm -f elf64 -o hello.o
#	ld -o hello hello.o

section .data
	# db - define bytes
	# 10 - the newline character
	text db "Hello, World!", 10

section .text
	# section start required for the linker (ld)
	global _start

_start:
	# rax - the sys call function number
	#   1 - sys_write
	# 	rax - 64 bit register
	#	eax - 32 bits, 1/2 of rax
	#	ax  - 16 bits, 1/2 of eax
	# 	al  - 8 bits,  1/2 of ax 
	mov rax, 1
	# rdi - sys call argument 1
	# rsi - sys call argument 2
	# rdx - sys call argument 3
	# r10 - sys call argument 4
	# r8  - sys call argument 5
	# r9  - sys call argument 6
	mov rdi, 1	# file descriptor. 0: stdin, 1: stdout, 2: stderr
	mov rsi, text	# text buffer (memory address)
	mov rdx, 14	# count (number of characters)
	syscall	


	# 60 - sys_exit
	# 0  - error code
	mov rax, 60
	mov rdi, 0
	syscall

