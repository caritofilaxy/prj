#include<stdio.h>
#include<stdlib.h>
#include "dec2bin.h"
#include "size.h"

int main(int argc, char *argv[]) {
	if (argc != 2) {
		printf("Usage: dec2bin <decimal_number>\n");
		return 1;
	}

	int i,d;
	char s[SZ];

	d = atoi(argv[1]);

	init_zero(s);
	fill(s,d);
	reverse(s);
	echo(s);
	
	return 0;
}
