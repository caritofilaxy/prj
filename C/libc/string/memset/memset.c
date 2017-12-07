#include<stdio.h>
#include<string.h>

int main(void) {
    char *p;
    int i;
    
    memset(p, 'x', 5);
	
    for(i=0; i<5; i++)
        printf("%c\n", *(p+i));

	return 0;
}
