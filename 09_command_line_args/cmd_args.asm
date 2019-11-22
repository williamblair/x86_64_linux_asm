; this program follows original tutorial episode 9
; Calling 
; compile with
;	nasm -f elf64 -o cmd_args.o cmd_args.asm
;	gcc cmd_args.o -o cmd_args

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

    no_arg_msg db "No arguments",0
    
    ; we'll use this string to hold the number of args
    arg_str db "  num arg",0
    
; This section is used to reserve space (variables)
section .bss

    ; 100 bytes to store an integer as text
    digit_buf   resb 100
    ; store the current index of the integer
    digit_index resb 8

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

; %include "../07_print_integers/_print_int.asm"

;_start:
main:

    ; upon start, when compiled with gcc,
    ; rdi contains argc and rsi contains argv
    mov rax, rdi
    ;mov rdx, rdi    ; rdx will be our 'counter' register to loop over all args
    push rdi ; save rdi val

    add rax, 48       ; convert to ascii
    mov [arg_str], al ; only get the lowest 8 bits

    mov rdi, arg_str ; argument to puts
    call puts

    pop rdx ; restore rdi initial val (argc) in rdi
    cmp rdx, 1
    jg  _print_loop ; if argc > 1, print out rest of args

    mov rdi, no_arg_msg
    call puts
    exit            ; else exit
   
_print_loop:

    mov rdi, [rsi] ; move the current string pointer as arg to puts
    call puts

;    dec rdx ; minus 1 on the loop counter

;    add rsi, 8 ; move to the next string

    ; if rdx > 1, loop again
;    cmp rdx, 1
;    jg _print_loop

    ; apparently 'ret' is wrong and you should make the exit
    ; system call instead:
    ;   https://stackoverflow.com/questions/19760002/nasm-segmentation-fault-on-ret-in-start#19760081
    exit

