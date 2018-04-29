/* print 7 x 3 = 21 */

#include<stdio.h>

int a = 7;
int b = 3;
int result;


int main(void) {
	__asm__ __volatile__ ("pusha\n\t"
				"movl a, %eax\n\t"
				"movl b, %ebx\n\t"
				"imull %ebx, %eax\n\t"
				"movl %eax, result\n\t"
				"popa");
	printf("%d x %d = %d\n", a, b, result);
	return 0;
}
