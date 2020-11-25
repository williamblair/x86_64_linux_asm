global _start

section .data
message: db 'hello, world!', 10

section .text
_start:
    mov rax, 1          ; system call number (write)
    mov rdi, 1          ; arg #1: write target file descriptor (1 = stdout)
    mov rsi, message    ; arg #2: where does the string start
    mov rdx, 14         ; arg #3: number of bytes to write
    syscall

    mov rax, 60         ; system call number (exit)
    xor rdi, rdi        ; set rdi = 0
    syscall

