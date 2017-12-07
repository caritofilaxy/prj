#include<stdio.h>
#include<string.h>


int main(void) {
    char *s1 = "klaatu verata nikto";
    char *s2 = "klaatu verata nikto";
	if (strcmp(s1,s2) == 0)
        printf("strings are equal\n");

	return 0;
}
