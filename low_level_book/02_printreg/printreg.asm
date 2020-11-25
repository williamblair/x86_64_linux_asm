global _start

section .data
codes: db '0123456789ABCDEF'

section .text
_start:
    mov rax, 0x1122334455667788 ; will print this out to stdout

    mov rdi, 1
    mov rdx, 1
    mov rcx, 64

    ; each 4 bits should be output as one hexadecimal digit
    ; use shift and bitwise AND to isolate them
    ; the result is the offset in the 'codes' array
.loop:
    push rax
    sub rcx, 4

    ; cl is a register, smallest part of rcx
    ; rax -- eax -- ax -- ah + al
    ; rcx -- ecx -- cx -- ch + cl
    sar rax, cl
    and rax, 0xf            ; mask 4 bits

    lea rsi, [codes + rax]  ; add the corresponding entry from 'codes' to get the ascii value
    mov rax, 1              ; only printing out 1 character (write 1 byte)

    ; syscall leaves rcx and r11 changed
    push rcx
    syscall
    pop rcx
    
    pop rax
    ; test can be used for the fastest 'is it a zero?' check
    ; see docs for 'test' command
    test rcx, rcx
    jnz .loop

.end:
    mov rax, 60     ; 'exit' system call
    xor rdi, rdi
    syscall

