#include<stdio.h>
#include<string.h>

int main(void) {
	char *s1 = "klaatu verata nikto";
	char *s2 = "klaatu verata nikto";
    if (memcmp(s1, s2, strlen(s1)) == 0)
        printf("strings are equal\n");

    int t1 = 536870912;
    int t2 = 536870912;
    if (memcmp(&t1,&t2,sizeof(int)) == 0)
        printf("ints are equal\n");


	return 0;
}
