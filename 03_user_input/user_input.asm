; User input
; compile with
;	nasm -f elf64 -o user_input.o user_input.asm
;	ld -o user_input user_input.o

section .data
	query_1 db "Enter your name >"
	query_2 db "Hello, "

; This section is used to reserve space (variables)
section .bss
	; resb - reserve bytes
	; 16 - length
	name resb 16

section .text
	; section start required for the linker (ld)
	global _start

_start:

	call _print_text_1

	; read in a string
	mov rax, 0 		; read input system call
	mov rdi, 0 		; 0 - stdin
	mov rsi, name 		; text to print
	mov rdx, 16		; text length
	syscall
	; ----------------

	call _print_text_2

	; print out the user input
	mov rax, 1 		; print syscall
	mov rdi, 1 		; 1 - stdout
	mov rsi, name 		; text to print
	mov rdx, 17		; text length
	syscall
	; ------------------------

	; 60 - sys_exit
	; 0  - error code
	mov rax, 60
	mov rdi, 0
	syscall


_print_text_1:
	mov rax, 1 		; print syscall
	mov rdi, 1 		; 1 - stdout
	mov rsi, query_1	; text to print
	mov rdx, 17		; text length
	syscall
	ret

_print_text_2:
	mov rax, 1 		; print syscall
	mov rdi, 1 		; 1 - stdout
	mov rsi, query_2	; text to print
	mov rdx, 7		; text length
	syscall
	ret

