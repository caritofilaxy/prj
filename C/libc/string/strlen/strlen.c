#include<stdio.h>
#include<string.h>


int main(void) {
    char string[32] = "klaatu verata nikto";
    char *p = string;
    printf("%s\n", p);
    printf("sizeof(string): %i\n", sizeof(string));
    printf("strlen(string): %i\n", strlen(string));
    printf("sizeof(p): %i\n", sizeof(p));

	return 0;
}
