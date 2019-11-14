; Math operations and stack
; compile with
;	nasm -f elf64 -o math_and_stack.o math_and_stack.asm
;	ld -o math_and_stack math_and_stack.o

section .data
	; used by _print_rax_digit
	rax_dig_val db 0,10
    
; This section is used to reserve space (variables)
section .bss

section .text
	; section start required for the linker (ld)
	global _start

_start:

	; add rax, 5	; rax += 5
	; sub rbx, rax 	; rbx -= rax

	; adc a, b	; a += b + carry_flag
	; sbc a, b 	; a -= b - carry_flag

	; mul reg	; assumes the first arg is rax (every multiply is rax * reg)
	; div reg	; assumes the first arg is rax (every multiply is rax / reg)

	; inc reg	; increment/decrement
	; dec reg	; e.g. reg -= 1

	; add 3 + 2 using rax, and rbx
	mov rax, 3
	mov rbx, 2
	add rax, rbx ; rax += rbx
	call _print_rax_digit

	; having two of these calls is generating a floating point exception...
	; divide 6 and 3 using rax, rbx
	;mov rax, 6
	;mov rbx, 2
	;div rbx
	;call _print_rax_digit

	
	; 60 - sys_exit
	; 0  - error code
	mov rax, 60
	mov rdi, 0
	syscall

; print the number in the rax register to the screen
; rax is overwritten
_print_rax_digit:
	; convert from digit to ascii in rax_dig_val
	add rax, 48 		; ascii offset (0 = 48 in ascii)
	mov [rax_dig_val], al 	; al is the lowest 8 bits of rax
		
	; print the val
	mov rax, 1
	mov rdi, 1
	mov rsi, rax_dig_val
	mov rdx, 2
	syscall
	
	ret

