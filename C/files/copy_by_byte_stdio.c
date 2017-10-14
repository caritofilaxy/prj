#include <stdio.h>
#include <stdlib.h>


int main(void) {
	
	FILE *in, *out;
	int c;

	in = fopen("cnus.txt","r");
	out = fopen("del4", "w");

	while((c = fgetc(in)) != EOF)
		fputc(c,out);

	return 0;
}

