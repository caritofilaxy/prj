#include<stdio.h>
#include<stdlib.h>

int main(void) {
        char *c = malloc(1);

        printf("%p\n", &main);
        printf("%p\n", &c);

        return 0;
}
