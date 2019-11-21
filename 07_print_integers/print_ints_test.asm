; Subroutine to print integers
; compile with
;	nasm -f elf64 -o print_ints_test.o print_ints_test.asm
;	ld -o print_ints_test print_ints_test.o

; you can include files with
; %include "myfile"

; some helpful constants
STDIN  equ 0
STDOUT equ 1
STDERR equ 2

SYS_READ  equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

section .data
    
; This section is used to reserve space (variables)
section .bss

    ; 100 bytes to store an integer as text
    digit_buf   resb 100
    ; store the current index of the integer
    digit_index resb 8

section .text
	; section start required for the linker (ld)
	global _start

; exit macro
; syntax:
; %macro <name> <num args>
; arguments are referenced with %1, %2, %3, etc...
%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

; include the source for the print int subroutine
%include "_print_int.asm"

_start:
    
    ; the rdx register combines with the rax register
    ; to make a single 128 bit register during division,
    ; so rdx needs to be zero when you call div if you
    ; don't want to use it
    ;
    ; additionally, the rdx register holds the remainder
    ; of integer division
    mov rax, 123
    call _print_int
	
    ; call our macro
    exit


