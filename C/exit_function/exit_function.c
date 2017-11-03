#include<stdio.h>
#include<stdlib.h>

#define MSG "Hello world"

int shl_by_two(int);

int main(void) {
		
		int src = 3;
		int dst;

		dst = shl_by_two(src);

		printf("%d\n", dst);

        exit(EXIT_SUCCESS);
}

int shl_by_two(int n) {
	return n << 2;
}
