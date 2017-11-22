#include<stddef.h>
#include<stdio.h>


int main(void) {
    
struct s {
    char a;
    char b;
    char f;
    int c;
    int e[2];
    float d;
    };

    printf("char a: %ld\n", offsetof(struct s, a));
    printf("char b: %ld\n", offsetof(struct s, b));
    printf("char f: %ld\n", offsetof(struct s, f));
    printf("int c: %ld\n", offsetof(struct s, c));
    printf("float d: %ld\n", offsetof(struct s, d));
    printf("int e[2]: %ld\n", offsetof(struct s, e));




	return 0;
}
