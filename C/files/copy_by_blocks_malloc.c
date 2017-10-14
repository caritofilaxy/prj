#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#define BUF 1024

int main(void) {
	
	int i, n, in, out;
	char *p;

	p = malloc(BUF);

	in = open("cnus.txt", O_RDONLY);
	out = open("del3", O_CREAT| O_WRONLY, S_IRUSR|S_IWUSR);

	while((n=read(in,p,BUF)) > 0) {
			write(out,p,n);
	}

	free(p);

	return 0;
}

