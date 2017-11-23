#include<stdio.h>
#include<string.h>
#include "proto.h"

void swap_int(void) {
    printf("---=== swapping int ===---\n");
    int a = 4;
    int b = 2;
    printf("%i %i\n", a, b);
    swap(&a,&b,sizeof(int));
    printf("%i %i\n", a, b);
}
