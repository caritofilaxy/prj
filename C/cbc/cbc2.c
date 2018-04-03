#include<stdio.h>
#include<stdlib.h>

char *encrypt(char *s, char k) {

        char *t;
        int c = 0;
        int d = 0;

        while (*(s+c) != '\0') {
            c++;
        }

        t = malloc(c);

        *(t+d) = *(s+d) ^ k;
        d++;
        while (d < c) {
          *(t+d) = *(s+d) ^ *(t+d-1);
          d++;
        }

        *(t+d+1) = '\0';

        return t;
}

char *decrypt(char *s, char k) {

        char *t;
        int c = 0;
        int d = 0;

        while (*(s+c) != '\0') {
            c++;
        }

        t = malloc(c);

        *(s+d) = *(s+d) ^ k;
        d++;
        while (d < c) {
          *(t+d) = *(s+d) ^ *(s+d-1);
          d++;
        }

        *(t+d+1) = '\0';

        return t;
}


          
int main(void) {
    
        char *s = "hello";
        char *e;
        char *d;

        char k = '\x4a';

        printf("%s", s);
        
        e = encrypt(s, k);

        printf("%s", e);

        d = decrypt(e, k);

        printf("%s", d);

        return 0;
}
    
