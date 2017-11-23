#include<stdio.h>
#include<string.h>

struct player_st {
    char name[50];
    char color[15];
    int level;
};
 
typedef struct player_st player;

void swap(void *vp1, void *vp2, int bsize) {
    char buffer[bsize];
    memcpy(buffer,vp1, bsize);
    memcpy(vp1, vp2, bsize);
    memcpy(vp2, buffer, bsize);
}

int main(void) {

    int a = 4;
    int b = 2;
    printf("%i %i\n", a, b);
    swap(&a,&b,sizeof(int));
    printf("%i %i\n", a, b);

    double c = 3.14;
    double d = 2.71;
    printf("%.2f %.2f\n", c, d);
    swap(&c, &d, sizeof(double));
    printf("%.2f %.2f\n", c, d);

    player player1 {
        char name[] = "kermit";
        char color[] = "green";
        int level = 12;
    }   

    player player2 {
        char name[] = "gonzo";
        char color[] = "red";
        int level = 12;
    }   

    printf("player1 props:\nname: %s, color: %s, level: %i\n", player1.name,
                                                               player1.color,
                                                               player1.level);
    printf("player2 props:\nname: %s, color: %s, level: %i\n", player2.name,
                                                               player2.color,
                                                               player2.level);
    swap(&(player player1), &(player player2), sizeof(player));
    printf("player1 props:\nname: %s, color: %s, level: %i\n", player1.name,
                                                               player1.color,
                                                               player1.level);
    printf("player2 props:\nname: %s, color: %s, level: %i\n", player2.name,
                                                               player2.color,
                                                               player2.level);
}
