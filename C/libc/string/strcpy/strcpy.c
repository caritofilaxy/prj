#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(void) {

    char *p1 = "klaatu verata nikto";
    char *p2;

    p2 = malloc(strlen(p1));
    strcpy(p2, p1);

	printf("%s\n", p2);

	return 0;
}
