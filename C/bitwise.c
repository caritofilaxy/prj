#include<stdio.h>

typedef unsigned short ushort;

int main(void) {
/*
    ushort i=13;
   
    // bitwise shift
    printf("Size of i: %ld\n", sizeof(i));
    printf("i = %d, (00001101)\n",i);
    printf("i <<= 2\n");

    i <<= 2;
    
    printf("i = %d, (00110100)\n",i);
   
    printf("i >>= 3\n");
    i >>=3; 

    printf("i = %2d, (00000110)\n",i);

    // bitwise complement
    i = 13;
    printf("i = %d, (00001101)\n",i);
    i = ~i;
    printf("i = %d, (11110010)\n",i);
*/

/*
    ushort i=0x0000;
    
    //setting bit
    ushort j=0x10; // 00010000 mask
    i |= j; //    i = 00010000

    // test bit
    //i >>= 1; // i = 00001000
    if (i & j) 
        printf("Bit set\n");
        
    // clear bit
    i &= ~j;
    printf("i = 0x%x\n", i);
*/

    unsigned short a=15,b;
    b = (~a) + 1;
    printf("%d\n", b);

    signed short c=15,d;
    d = (~c)+1;
    printf("%d\n", d);

	return 0;
}
