global _start

section .data
codes: db '0123456789ABCDEF'

section .text
_start:

    ; mov example
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; write target file descriptor (1 = stdout)
    mov rsi, codes      ; string address
    mov rdx, 1          ; number of bytes to write
    add rsi, 2          ; rsi += 2
    syscall

    ; lea example
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    lea rsi, [codes + 2]    ; string address (rsi += 2 done already)
    mov rdx, 1              ; number of bytes to write
    syscall

    ; mov with addr offset example
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; write target file descriptor (1 = stdout)
    mov rsi, codes + 2  ; string address
    mov rdx, 1          ; number of bytes to write
    syscall
    
    mov rax, 60     ; 'exit' system call
    xor rdi, rdi    ; rdi = 0
    syscall

