; jump, call, compares
; compile with
;	nasm -f elf64 -o jmp_call_cmp.o jmp_call_cmp.asm
;	ld -o jmp_call_cmp jmp_call_cmp.o

section .data
	; db - define bytes
	; 10 - the newline character
	text_a db "A > B", 10

	text_b db "A < B", 10

section .text

_r_eight_is_greater:
	mov rax, 1 	; sys_write
	mov rdi, 1 	; stdout
	mov rsi, text_a	; string pointer
	mov rdx, 6	; string length
	syscall
	ret

_r_nine_is_greater:
	mov rax, 1 	; sys_write
	mov rdi, 1 	; stdout
	mov rsi, text_b	; string pointer
	mov rdx, 6	; string length
	syscall
	ret

	; section start required for the linker (ld)
	global _start

_start:

	; flag registers:
	;	cf - carry
	;	pf - parity
	;	zf - zero
	;	sf - sign
	;	of - overflow
	; 	af - adjust
	;	if - interrupt enabled

	; pointer registers:
	;	rip - 64 bit index pointer - next address to be executed
	;	rsp - 64 bit stack pointer - top of stack
	;	rbp - 64 bit stack base pointer - bottom of stack
	;
	; 64, 32, and 16 bit versions of these are
	;	rip, eip, ip
	;	rsp, esp, sp
	;	rbp, ebp, bp
	
	; mov a, b
	;	a = b
	; mov a, [b]
	;	a = *b (get the value b points to)

	; cmp a, b
	; 	sets appropriate conditions for jumps based on difference
	;	e.g.
	;		mov a, 5
	;		mov b, 10
	;		cmp a, b
	;		jl _aIsLessThanb ; true

	; call <label>
	; same as jmp except return to original location using ret


	mov r8, 5 		; r8 = 5
	mov r9, 10		; r9 = 10
	cmp r8, r9		; test r8 and r9
_goto_r8_greater:
	call _r_eight_is_greater	; if r8 > r9 goto _r8_is_greater
	jmp _endif		; skip the next r9_greater stuff
_goto_r9_greater:
	call _r_nine_is_greater	; else (r8 <= r9) goto _r9_is_greater
_endif:

	; 60 - sys_exit
	; 0  - error code
	mov rax, 60
	mov rdi, 0
	syscall

