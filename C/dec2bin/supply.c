#include<stdio.h>
#include "dec2bin.h"
#include "size.h"


void init_zero(char *m) {
	int i;
	for (i=0;i<SZ;i++)
        *(m+i) = '\0';
}

void fill(char *m, int d) {
	int i;
	for (i=0; d != 0; i++ ) {
		if (d%2 == 0)
			*(m+i) = '0';
		else
			*(m+i) = '1';

		d /= 2;
	}
}

void reverse(char *m) {
	int i,k;
	char tmp[SZ];
	init_zero(tmp);

	for(i=SZ-1,k=0;i>=0;i--,k++)
		*(tmp+k) = *(m+i);

	for (i=0;i<SZ;i++)
		*(m+i) = *(tmp+i);
}

void echo(char *m) {
	int i;
	for(i=0;i<SZ;i++)
        putchar(*(m+i));

    putchar(10);
}

