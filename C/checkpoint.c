#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>

/****** structures definition *****/
struct server {
	struct server *next;
	char *name;
	char **msg;
};
/**********************************/


/****** declarations *************/
void print_menu();
void print_list(struct server *);
void add_srv(struct server **);
void del_srv(struct server *);

int main(void) {

	struct server *head = NULL;
	int choice;
		

while	(1) {
	print_menu();
	scanf("%i\n", &choice);
	
	switch (choice) {
		case '1':
			print_list(head);
			break;
		case '2':
			add_srv(&head);
			break;
		case '3':
			del_srv(head);
			break;
		case '4':
			goto wedone;
			break;
		default :
			printf("Wrong choice");
			print_menu();
		}
	
}

wedone:
	return 0;
}

/****** generic friends ******/
char *read_line() {
    int ch, i=0, n=20;
		char *str;

    while (isspace(ch = getchar())) {
            ;
    }

    while (ch != '\n' && ch != EOF) {
        if (i<n) {
            *(str+i) = ch;
						i++;
				}	
			  ch = getchar();
    }

    *(str+i)='\0';

		return str;
}

/**********************************/	

/********* operations *************/
void print_menu() {	
	printf("1. List servers\n");
	printf("2. Add server\n");
	printf("3. Del server\n");
	printf("4. Exit\n");
}

void print_list(struct server *p) {
	if ( p == NULL)
		printf("No servers found\n");
	else 
		for(;p != NULL; p = p->next)
			printf("-%s\n", p->name);
}

void add_srv(struct server **p) {
	struct server *tmp;
	tmp = malloc(sizeof(struct server));
	tmp->name = read_line();
	tmp->next = *p;
	*p = tmp;
}
	

void del_srv(struct server *p) {
	struct server *tmp;
	tmp = p;
	p = p->next;
	free(tmp);
}
