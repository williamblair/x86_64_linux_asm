global _start

section .data
codes: db '0123456789ABCDEF'

section .text
_start:

    mov rax, -1
    mov rdx, 2

testGreatherThan:
    cmp rax, rdx
    jg greaterThan      ; goto greaterThan if rax > rdx

lessThanOrEqual:
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; write target file descriptor (1 = stdout)
    mov rsi, codes      ; string address
    mov rdx, 1          ; number of bytes to write
    add rsi, 0          ; rsi += 0
    syscall
    jmp testEqual

greaterThan:
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; write target file descriptor (1 = stdout)
    mov rsi, codes      ; string address
    mov rdx, 1          ; number of bytes to write
    add rsi, 1          ; rsi += 1
    syscall

testEqual:
    mov rax, -1
    mov rdx, 2
    cmp rax,rdx
    je equal            ; goto equal if rax == rdx

notEqual:
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; write target file descriptor (1 = stdout)
    mov rsi, codes      ; string address
    mov rdx, 1          ; number of bytes to write
    add rsi, 0          ; rsi += 0
    syscall
    jmp done

equal:
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; write target file descriptor (1 = stdout)
    mov rsi, codes      ; string address
    mov rdx, 1          ; number of bytes to write
    add rsi, 1          ; rsi += 1
    syscall

done:
    mov rax, 60     ; 'exit' system call
    xor rdi, rdi    ; rdi = 0
    syscall

