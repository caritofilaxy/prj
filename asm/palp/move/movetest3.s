# indexed mem locations
# base_address(offset_address, index, size)
# moving 65536 to %edx

.section .bss
out:
    

.section .data
values:
    .int 2, 64, 1024, 65536, 512, 4096

.section .text
.globl _start
_start:
    nop
    movl $3, %edi
    movl values(, %edi, 4), %edx
    movl $1, %eax
    movl $0, %ebx
    int $0x80
