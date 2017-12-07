#include<stdio.h>
#include<string.h>

int main(void) {
    
    char *p;
    p = (char *)strdup("klaatu verata nikto");

	printf("%s\n", p);

	return 0;
}
