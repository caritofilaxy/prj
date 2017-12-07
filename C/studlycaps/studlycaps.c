#include<stdio.h>

int main(void) {

    int a, b;

    for (a=0; b=getchar(), b!=EOF; a!=a)
        putchar(a?tolower(b):toupper(b));


	return 0;
}
