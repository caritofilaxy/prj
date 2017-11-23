#include<stdio.h>

int flag_off(int *flag) {
    *flag = 0;
}

int main(void) {
    int flag = 1;
    flag_off(&flag);
    printf("%d\n", flag);
}
