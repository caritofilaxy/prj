#include<stdio.h>

int main(void) {
	char c = 'V';
	putchar(c);
	c |= 0x20;
	putchar(c);
	c &= ~0x20;
	putchar(c);
}
