; lib.inc
; useful helper functions

section .text

; exit: quits the program, returning 0
; inputs: none
; outputs: none
exit:
    mov rax, 60     ; 'exit' system call
    xor rdi, rdi    ; rdi = 0
    syscall

; stringLength: calculates the length of a null-terminated string
; inputs:
;   rdi - the string to calculate the length of
; outputs:
;   rax - the calculated string length
stringLength:
    xor rax, rax            ; rax = 0

.stringLength_loop:
    cmp byte[rdi+rax],0     ; test if current char == 0 (null terminated)
    je .stringLength_end

    inc rax                 ; rax += 1 
    jmp .stringLength_loop  ; goto .stringLength_loop

.stringLength_end:
    ret                     ; reached after the je call under .loop

; printString: writes a null-terminated string to stdout
; inputs:
;   rdi - the string to print
; outputs: none
; overwrites:
;   rax, rsi, rdx
printString:
    call stringLength   ; rdi already contains the string
    mov rdx, rax        ; rdx = rax (the calculated strlen)
    mov rsi, rdi        ; rsi = rdi (the string to print)
    mov rax, 1                      ; system call number (write)
    mov rdi, 1                      ; write target file descriptor (1 = stdout)
    syscall
    ret

; printChar: writes a single character to stdout
; inputs:
;   dil (8-bits of rdi) - the character to print
; outputs: none
; overwrites:
;   rax, dil, rsi, rdx
section .data
    printChar_charBuf: db '0'
section .text
printChar:
    mov byte[printChar_charBuf], dil    ; *buf = dil
    mov rax, 1                          ; system call number (write)
    mov rdi, 1                          ; write target file descriptor (1 = stdout)
    mov rsi, printChar_charBuf          ; string address
    mov rdx, 1                          ; number of bytes to write
    syscall
    ret

; printHex: prints a 64bit value in hexadecimal
; inputs:
;   rdi - the value to print
; outputs: none

section .data
    printHex_hexPrefix:   db '0x'
    printHex_codes:       db '0123456789ABCDEF'
section .text

printHex:
    mov rax, rdi            ; first arg = the number to print in hex
    push rax                ; save rax
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    mov rsi, printHex_hexPrefix      ; string address
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
    lea rsi, [printHex_codes + rax]  ; codes offset for the hex representation

    push rcx                ; syscall breaks rcx
    mov rax, 1
    syscall
    pop rcx

    pop rax                 ; restore the value to shift
    test rcx, rcx           ; is rcx == 0?
    jnz iterate             ; goto iterate if rcx != 0

    ret

; printNewline: writes \n to stdout
; inputs: none
; outputs: none
; overwrites:
;   rax, rdi, rsi, rdx
section .data
    newlineChar: db 10
section .text
printNewline:
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    mov rsi, newlineChar    ; string address
    mov rdx, 1              ; number of bytes to write
    syscall
    ret                     ; restore the next instruction pointer (rip)

; printUint: print an 8 byte unsigned integer
; inputs:
;   rax - the number to print
; outputs: none
; overwrites:
;   rdi, rcx, rdx
printUint:
    sub rsp, 8          ; "reserve" 8 bytes on the stack
    mov rcx, 7          ; index into our reserved stack space to put the current digit
    mov rdi, 10         ; the amount to divide by (div doesn't accept immediates)
    mov rdx, 0          ; appears to need to be cleared before division
.printUint_loop:
    div rdi                 ; rdx = rax MOD rdi, rax /= rdi;
    add dl, 48              ; convert from number to ascii character (dl = byte of rdx)
    mov byte[rsp+rcx], dl   ; rsp[rcx] = (uchar)rdx
    mov rdx, 0              ; clear rdx
    dec rcx                 ; rcx -= 1
    test rax, rax           ; if rax != 0
    jnz .printUint_loop     ;   then goto .printUint_loop
    
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    lea rsi, [rsp+rcx]      ; string address
    mov rdx, 8              ; number of bytes to write
    sub rdx, rcx            ;   = 8 - (rcx counter)
    syscall
    
    add rsp, 8          ; "restore" the 8 bytes we reserved earlier

    call printNewline
    ret

; printInt: print an 8 byte integer
; inputs:
;   rax - the number to print
; outputs: none
; overwrites:
;   rdi, rcx, rdx
printInt:
    cmp rax, 0                  ; if input >= 0, skip the neg sign print
    jge .printInt_endNegcheck
    push rax                    ; save the input value
       mov dil, '-'
       call printChar    
    pop rax
    imul rax, -1        ; make the number unsigned
.printInt_endNegcheck:
    sub rsp, 8          ; "reserve" 8 bytes on the stack
    mov qword[rsp], 0   ; clear memory
    mov rcx, 7          ; index into our reserved stack space to put the current digit
    mov rdi, 10         ; the amount to divide by (div doesn't accept immediates)
    mov rdx, 0          ; appears to need to be cleared before division
.printInt_loop:
    div rdi                 ; rdx = rax MOD rdi, rax /= rdi;
    add dl, 48              ; convert from number to ascii character (dl = byte of rdx)
    mov byte[rsp+rcx], dl   ; rsp[rcx] = (uchar)rdx
    mov rdx, 0              ; clear rdx
    dec rcx                 ; rcx -= 1
    test rax, rax           ; if rax != 0
    jnz .printInt_loop      ;   then goto .printUint_loop
    
    mov rax, 1              ; system call number (write)
    mov rdi, 1              ; write target file descriptor (1 = stdout)
    lea rsi, [rsp+rcx]      ; string address
    mov rdx, 8              ; number of bytes to write
    sub rdx, rcx            ;   = 8 - (rcx counter)
    syscall
    
    add rsp, 8          ; "restore" the 8 bytes we reserved earlier

    call printNewline
    ret

global _start

section .data
    testString: db "hello, world!",0
section .text
_start:

;    mov rdi, testString    ; rdi = testString 
;    call printString
;    call printNewline
;
;    mov dil, 'a'
;    call printChar
;    call printNewline

    mov rax, 87654321 
    call printUint

    mov rax, -1234567
    call printInt

    call exit

