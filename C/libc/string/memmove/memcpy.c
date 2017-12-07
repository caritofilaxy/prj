#include<stdio.h>
#include<string.h>
#include<stdlib.h>

typedef struct {
    char *name;
    char *sym;
    int an;
    double ram;
    int p;
} element;


int main(void) {
	element *g1;
	element *g2;

    printf("*g1: %p\n", (void *)g1);
    printf("*g2: %p\n", (void *)g2);

    g1 = malloc(sizeof(element));
    g2 = malloc(sizeof(element));
    g2 -= 36;
    printf("g1: %p\n", (void *)g1);
    printf("g2: %p\n", (void *)g2);
    g1->name = strdup("Helium");
    g1->sym = strdup("He");
    g1->an = 2;
    g1->ram = 4.002602;
    g1->p = 1;


    printf("%s, %s, %i, %.2f, %i\n", g1->name, g1->sym, g1->an, g1->ram, g1->p);

    memcpy(g2, g1, sizeof(element));

    printf("%s, %s, %i, %.2f, %i\n", g2->name, g2->sym, g2->an, g2->ram, g2->p);

    return 0;
}
