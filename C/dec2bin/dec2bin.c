#include<stdio.h>
#include<stdlib.h>

#define SZ 8

void init(char *);
void convert(char *, int);
void reverse(char *);
void print(char *);


int main(int argc, char *argv[]) {

        
        char bytes[SZ];
        int d = atoi(argv[1]); 

        init(bytes);
        convert(bytes, d);
        reverse(bytes);
        print(bytes);

        return 0;
}


void init(char *p) {
    int i;
    for (i=0;i<SZ;i++)
        *(p+i) = '\0';
}

void convert(char *p, int m) {
    
    int i;
       
    for (i=0 ;m != 0; i++) {
        if ( m % 2 == 0)
            *(p+i) = '0';
        else
            *(p+i) = '1';
    
        m /= 2;
    }
}

void reverse(char *p) {
    char tmp[SZ];
    int i,k;

    for(i=0,k=SZ-1;i<SZ;i++,k--)
        *(tmp+i) = *(p+k);

    for(i=0;i<SZ;i++)
        *(p+i) = *(tmp+i);
}

void print(char *p) {
    int i;

    for (i=0;i<SZ;i++)
        putchar(*(p+i));

    putchar(10);
}

  
