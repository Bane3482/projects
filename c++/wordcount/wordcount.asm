section .text
global _start

BUFFER_SIZE: equ 4096
OUT: equ 1
ERR: equ 2
ERROR: equ 1
WRITE: equ 1
EXIT: equ 60

_start:
    sub rsp, BUFFER_SIZE
    xor ebx, ebx
    xor r15, r15
    xor r14, r14
    mov rsi, rsp
    xor edi, edi
    mov rdx, BUFFER_SIZE
.read:
    xor eax, eax
    syscall

    test rax, rax
    jz .quit
    js .error

    xor ecx, ecx

.count_words:
    mov r15, r14
    xor r14, r14
    mov r13, [rsp +  rcx]
    cmp r13b, 0x9
    jb .check
    cmp r13b, 0xd
    jbe .skip
    cmp r13b, 0x20
    je .skip

.check:
    mov r14, r15
    xor r14, 1
    add rbx, r14
    mov r14, 1

.skip:
    inc rcx
    cmp rcx, rax
    jb .count_words

    jmp .read

.quit:
    mov rax, rbx
    lea rcx, [write_buffer + write_buffer_size - 1]
    mov byte [rcx], 0x0a
    mov rbx, 10

.print:
    xor edx, edx
    div rbx
    add dl, '0'
    dec rcx
    mov byte [rcx], dl
    test rax, rax
    jnz .print

    mov rax, WRITE
    mov rdi, OUT
    mov rsi, rcx
    lea rdx, [write_buffer + write_buffer_size]
    sub rdx, rcx
    syscall

    mov rax, EXIT
    xor edi, edi
    syscall

.error:
    mov rax, WRITE
    mov rdi, ERR
    mov rsi, err_msg
    mov rdx, err_msg_len
    syscall
    mov rax, EXIT
    mov rdi, ERROR
    syscall

section .rodata
    err_msg: db `Read error found\n`
    err_msg_len: equ $ - err_msg

section .bss
    write_buffer_size : equ 21
    write_buffer: resb write_buffer_size
