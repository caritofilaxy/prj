#include<stdio.h>

int p=0, argc_addr=0;
/* char arg[100]; */

int main(int argc, char **argv) {
	
	__asm__ __volatile__ ("movl %eax, p\n\t"
				"movl %esp, %ebx\n\t"
				"addl $4, %ebx\n\t"
				"movl %ebx, argc_addr"
				);
	printf("argc: %i at 0x%x\n", p, argc_addr);

	return 0;
}


/*

ecx - 0xbffff6c0
		|- 0x00000003
		|- 0xbffff754 (**argv) ---- 0xbffff87b (argv[1])
		|- 0xbffff764 (**envp)	    0xbffff89b (argv[2])
				|	    0xbffff8a1 (argv[3])
				|
				|- 0xbffff8a7 (term)
				|- 0xbffff8b2 (shell
					...)
*/
