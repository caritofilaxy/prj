#include<stdio.h>
#include<string.h>
#include "proto.h"

void swap_array(void) {
    char s1[50] = "this is a good day today";
    char s2[50] = "it time to kick ass and chew bubble-gum";
        
    printf("---=== swapping array ===---\n");

    printf("s1: %s\n", s1);
    printf("s2: %s\n", s2);

    swap(s1, s2, sizeof(s1));
    
    printf("s1: %s\n", s1);
    printf("s2: %s\n", s2);
}
