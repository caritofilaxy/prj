;Copyright (c) 2000 Konstantin Boldyshev <konst@linuxassembly.org>
;
;"hello, world" in assembly language for BeOS
;
;to compile:
;
;nasm -f elf hello.asm
;ld -s -o hello hello.o

section	.text
    global _start			;must be declared for linker (ld)

_syscall:			;system call
	int	0x25
	ret

_start:				;tell linker entry point

	push	dword len	;message length
	push	dword msg	;message to write
	push	dword 1		;file descriptor (stdout)
	mov	eax,0x3		;system call number (sys_write)
	call	_syscall	;call kernel
	add	esp,12		;clean stack (3 * 4)

	push	dword 0		;exit code
	mov	eax,0x3f	;system call number (sys_exit)
	call	_syscall	;call kernel
				;no need to clean stack

section	.data

msg	db	"Hello, world!",0xa	;our dear string
len	equ	$ - msg			;length of our dear string
