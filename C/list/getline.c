#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

void get_string

int main(void) {
    FILE *fh;
    char string[100];
    int c;
    int i = 0; 

    char name[50];
    char symbol[2];
    double ram;
    int an;
    int p;
    
    fh = open("elements.list", "r");
    while((c = fgetc(fh)) != EOF) {
        *(string+i) = c;
        if (c == ',') {
            name = string;
        }

