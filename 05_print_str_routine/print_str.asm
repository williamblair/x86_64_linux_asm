; Subroutine to print strings of any length
; compile with
;	nasm -f elf64 -o print_str.o print_str.asm
;	ld -o print_str print_str.o

section .data
    
    ; test string
    text db "Hello World!",10,0
    
; This section is used to reserve space (variables)
section .bss

section .text
	; section start required for the linker (ld)
	global _start

_start:

    ; call the _print_string subroutine for hello world
    mov rax, text ; subroutine argument
    call _print_string

	
	; 60 - sys_exit
	; 0  - error code
	mov rax, 60
	mov rdi, 0
	syscall

; _print_string subroutine
; args:
;   rax - pointer to string
_print_string:
    
    push rax    ; save the pointer to the beginning of the string
    mov  rbx, 0 ; counter of how many characters there are

_print_loop:
    ; increment pointer/counter
    inc rax
    inc rbx
    ; store the current character in cl
    mov cl, [rax]
    ; if we haven't reached the end of the string ('\0'), start the loop again
    cmp cl, 0
    jne _print_loop

; end _print_loop - print the string now that we know how many chars there are
    mov rax, 1
    mov rdi, 1
    mov rdx, rbx
    pop rsi
    syscall

    ret

; end of _print_string subroutine


