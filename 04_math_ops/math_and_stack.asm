; Math operations and stack
; compile with
;	nasm -f elf64 -o math_and_stack.o math_and_stack.asm
;	ld -o math_and_stack math_and_stack.o

section .data
    
; This section is used to reserve space (variables)
section .bss

section .text
	; section start required for the linker (ld)
	global _start

_start:

    ; add rax, 5    ; rax += 5
    ; sub rbx, rax  ; rbx -= rax
