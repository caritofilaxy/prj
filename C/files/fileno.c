#include <stdio.h>
#include <stdlib.h>


int main(void) {
	
	FILE *in, *out;
	int c;

	in = fopen("cnus.txt","r");
	out = fopen("del4", "w");

	printf("in: %d, out: %d\n", fileno(in), fileno(out));

	return 0;
}

