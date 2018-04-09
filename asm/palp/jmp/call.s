.section .text
.globl _start
_start:
    nop
    movl $8, %ecx
# 64 placed to ecx
    movl $16, %edx
# 128 placed to edx
    pushl %ecx
# value from ecx placed on stack
    pushl %edx
# value from edx placed on stack
    call sum
# address of next instruction placed on stack and jump to sum mark
    movl $1, %eax
    int $0x80

sum:
    pushl %ebp
    movl %esp, %ebp
# 4 bytes of return address + 4 bytes ebp 
    movl 8(%ebp), %eax
    movl 12(%ebp), %ebx
    addl %eax, %ebx
    movl %ebp, %esp
    popl %ebp
    ret

