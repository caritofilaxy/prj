#include<stdio.h>
#include<stdlib.h>

int main(void) {
        char *c = malloc(1);
        int a, *p;
        p = &main;
        printf("%p\n", (void *)p);
        printf("%p\n", (void *)&c);
        printf("%p\n", (void *)&a);

        return 0;
}
