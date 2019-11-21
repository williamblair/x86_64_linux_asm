; this program from
;   https://cs.lmu.edu/~ray/notes/nasmtutorial/
; Calling 
; compile with
;	nasm -f elf64 -o c_from_asm.o c_from_asm.asm
;	gcc c_from_asm.o -o c_from_asm

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
    
    message db "Hello, World!",0,10
    
; This section is used to reserve space (variables)
section .bss

section .text

; instead of _start for ld, gcc uses 'main'
;   ; section start required for the linker (ld)
;    global _start

    global main

; exit macro
; syntax:
; %macro <name> <num args>
; arguments are referenced with %1, %2, %3, etc...
%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

; like header include for puts
extern puts

;_start:
main:
   
    ; argument to puts
    mov     rdi, message
    call    puts
    
    ret     ; return from main back into c library wrapper 
	
    ; call our macro
    exit


