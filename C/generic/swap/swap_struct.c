#include<stdio.h>
#include<string.h>
#include "proto.h"

typedef struct {
    char name[50];
    char color[15];
    int level;
} player;
 
void swap_struct(void) {

    player player1; 
    player player2;

    strcpy(player1.name, "Gonzo");
    strcpy(player1.color, "Red");
    player1.level = 7;

    strcpy(player2.name, "Kermoit");
    strcpy(player2.color, "Green");
    player2.level = 80;

    printf("---=== swapping struct ===---\n");

    printf("player1 - name: %s, color: %s, level: %i\n", player1.name,
                                                               player1.color,
                                                               player1.level);
    printf("player2 - name: %s, color: %s, level: %i\n", player2.name,
                                                               player2.color,
                                                               player2.level);
    swap(&player1, &player2, sizeof(player));

    printf("player1 - name: %s, color: %s, level: %i\n", player1.name,
                                                               player1.color,
                                                               player1.level);
    printf("player2 - name: %s, color: %s, level: %i\n", player2.name,
                                                               player2.color,
                                                               player2.level);
}
