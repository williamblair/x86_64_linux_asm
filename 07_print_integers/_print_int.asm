; print int subroutine
; requires the following in .bss section:
;    ; 100 bytes to store an integer as text
;    digit_buf   resb 100
;    ; store the current index of the integer
;    digit_index resb 8

; args - rax: the integer to print
_print_int:

    mov rcx, digit_buf ; set rcx equal to digit buf pointer
    
    mov rbx, 10        ; newline character
    mov [rcx], rbx     ; add newline character to string buffer
    
    inc rcx            ; move to next index in string buffer
    mov [digit_index], rcx

; store the number in a string (digit buf)
_print_int_loop:

    ; divide the number (in rax) by 10 to get the current 100s/10s/1s position value
    mov rdx, 0 ; set rdx equal to zero to not mess up division (see comment in start)
    mov rbx, 10
    div rbx
    push rax

    ; we want the remainder, which is the current digit we want to print
    ; e.g. 123/10 = 12 remainder 3, so we want to print out three as the last number
    add rdx, 48

    mov rcx, [digit_index] ; get the next string buffer index
    mov [rcx], dl ; store the 8 byte character from rdx into string index

    inc rcx ; increment the string buffer pointer

    mov [digit_index], rcx

    ; restore divided int value; if we've reached zero (number is less than 10)
    ; then we've reached the end of the numbers to print
    pop rax
    cmp rax, 0
    jne _print_int_loop

; print out the string
_print_int_loop2:
    mov rcx, [digit_index] ; store the current character to print in rcx

    ; print out the current character
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, rcx
    mov rdx, 1 ; number of characters (a single digit)
    syscall

    ; decrement the string pointer to move backwards in the string (the string was written backwards)
    mov rcx, [digit_index]
    dec rcx
    mov [digit_index], rcx

    ; if we haven't reached the beginning of the string yet, run the loop again
    cmp rcx, digit_buf
    jge _print_int_loop2

    ; once we reach here, the subroutine is done
    ret

