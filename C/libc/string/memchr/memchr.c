#include<stdio.h>

int main(void) {
    char *s1 = "klaatu verata nikto";

    char *c2;

    c2 = memchr((void *)s1, 31, sizeof(char));
    printf("%c\n", *c2);


    
	return 0;
}
