#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

#define clear() printf("\033[H\033\[J")

struct element_tmplt {
    char *name;
    char *symbol;
    double ram;
    int an;
    int p;
    struct element *next;
};

typedef struct element_tmplt element;

void init_list(element *head);
void load_list();
void save_list();
int add_element();
int del_element();
void quit(int *); 

int main(void) {
    
    char c;
    int keep_going=1;
    element *head;

    init_list(head);
    while(keep_going) {
        clear();
        printf("(l)oad list\n");
        printf("(s)ave list\n");
        printf("(a)dd element\n");
        printf("(d)el element\n");
        printf("(q)uit\n");

        c = getchar();
        switch (c) {
            case 'l': 
                load_list();
                break;
            case 's':
                save_list();
                break;
            case 'a':
                add_element();
                break;
            case 'd':
                del_element();
                break;
            case 'q':
                quit(&keep_going);
                break;
            default:
                printf("lsadq\n");
                break;
        }
    }
clear();
}

void init_list(element *head) {
    head = '\0';
}
    

void load_list() {
    open_file;
    FILE *fh,
    fh = open("elements.db", "r");
    while(not eof) {
        read_line;
        set name, symbol, ram, an, p;
        malloc(element);
        set elements fields;
        set new head;
}

void save_list() {
    printf("Saving database...\n");
    sleep(1);
}

int add_element() {
    printf("Adding element...\n");
    sleep(1);
}

int del_element() {
    printf("Deleting element...\n");
    sleep(1);
}

void quit(int *flag) {
    *flag = 0;
}
