#include<stdio.h>


int main(void) {
        short s = 45;
        double d = *(double *)&s;
        
        return 0;
}
