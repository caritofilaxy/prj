# .section .data
# value:
#    .byte 42, 255
#    .int 42, 65535
#    .long 42, 4294967295

# .section .bss
#    .comm arr_size, 8
#    .lcomm biffer, 10000

.section .text
.globl _start
_start:
    nop


    mov $0, %eax
    mov $1, %ebx
    int $0x80
