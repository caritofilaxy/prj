#include<stdio.h>
#include<stdlib.h>

	struct process {
		unsigned int pid;
		char *cmd;
		struct process *next;
		;
	struct myst *p1, *p2;
	struct myst *p1, *p2;
	struct myst *p1, *p2;
	};


int main(void) {

	
	struct process *p1, *p2;
	p1 = malloc(sizeof(*p1));

	p1->pid = 27;
	p1->cmd = "/bin/bash";
	p1->next = NULL;

	p2 = p1; 

	printf("%s\n", p2->cmd);

        return 0;
}
