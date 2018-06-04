.section .bss
    .lcomm pid, 4 

.section .text
.globl _start
_start:
    nop

    movl $20, %eax
    int $0x80
    
    movl %eax, pid 
    movl pid, %ebx
    leal pid, %ebx
    movl $pid, %edx

    movl $1, %eax
    movl $0, %ebx
    int $0x80
