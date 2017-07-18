#include<stdio.h>
#include<stdlib.h>

#define BUFSZ 10

int main(void) {

	int guess = 3235;
	
	int c, i=0;
	c = getchar();
	char str[BUFSZ];
	while(c != 10 && i<BUFSZ) {
		str[i++] = c;
		c = getchar();
	}
	
	if (i != 4)
		printf("wrong size\n");

	if (atoi(str) == guess)
		printf("%d matched\n", guess);
	
	return 0xdead;
}
