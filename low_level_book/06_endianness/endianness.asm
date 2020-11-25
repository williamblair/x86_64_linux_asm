global _start

section .data
hexPrefix:   db '0x'
newlineChar: db 10
codes:       db '0123456789ABCDEF'

demo1: dq 0x1122334455667788
demo2: db 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88

section .text

printNewline:
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    mov rsi, newlineChar    ; string address
    mov rdx, 1              ; number of bytes to write
    add rsi, 0              ; rsi += 0
    syscall
    ret                     ; restore the next instruction pointer (rip)

printHex:
    mov rax, rdi            ; first arg = the number to print in hex
    push rax                ; save rax
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    mov rsi, hexPrefix      ; string address
    mov rdx, 2              ; number of bytes to write
    syscall
    pop rax                 ; restore rax
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    mov rdx, 1              ; number of bytes to write (1)
    mov rcx, 64             ; amount to shift rax
iterate:
    push rax                ; save the initial rax val
    sub rcx, 4
    sar rax, cl             ; shift to 60, 56, 52, ... 4, 0
                            ; the cl register is the smallest part of rcx
    and rax, 0xf            ; clear all bits but the lowest four
    lea rsi, [codes + rax]  ; codes offset for the hex representation

    push rcx                ; syscall breaks rcx
    mov rax, 1
    syscall
    pop rcx

    pop rax                 ; restore the value to shift
    test rcx, rcx           ; is rcx == 0?
    jnz iterate             ; goto iterate if rcx != 0

    ret

_start:

    mov rdi, [demo1]    ; rdi = *demo1 
    call printHex
    call printNewline

    mov rdi, [demo2]    ; rdi = *demo2
    call printHex
    call printNewline

done:
    mov rax, 60     ; 'exit' system call
    xor rdi, rdi    ; rdi = 0
    syscall

