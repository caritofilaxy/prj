#include<stdio.h>
#include<string.h>
#include "proto.h"
 
void swap_double(void) {
    printf("---=== swapping double ===---\n");
    double c = 3.14;
    double d = 2.71;
    printf("%.2f %.2f\n", c, d);
    swap(&c, &d, sizeof(double));
    printf("%.2f %.2f\n", c, d);
}
