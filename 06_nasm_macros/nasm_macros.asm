; demonstrate use of nasm macros
; compile with
;	nasm -f elf64 -o nasm_macros.o nasm_macros.asm
;	ld -o nasm_macros nasm_macros.o

section .data
    
	; used by _print_rax_digit
	rax_dig_val db 0,10
    
    ; test string
    text db "Hello World!",10,0
    
; This section is used to reserve space (variables)
section .bss

section .text
	; section start required for the linker (ld)
	global _start

; exit macro
; syntax:
; %macro <name> <num args>
; arguments are referenced with %1, %2, %3, etc...
%macro exit 0
    mov rax, 60
    mov rdi, 0
    syscall
%endmacro

; print digit macro
; takes a single arg - the digit to print
%macro print_digit 1
    mov rax, %1
    
	; convert from digit to ascii in rax_dig_val
	add rax, 48 		; ascii offset (0 = 48 in ascii)
	mov [rax_dig_val], al 	; al is the lowest 8 bits of rax
		
	; print the val
	mov rax, 1
	mov rdi, 1
	mov rsi, rax_dig_val
	mov rdx, 2
	syscall
%endmacro

_start:

    ; call the print digit macro
    print_digit 5

	
	; 60 - sys_exit
	; 0  - error code
	;mov rax, 60
	;mov rdi, 0
	;syscall

    ; call our macro
    exit


