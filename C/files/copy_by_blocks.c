#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#define BUF 1024

int main(void) {
	
	int i, n, in, out;
	char block[BUF];


	in = open("cnus.txt", O_RDONLY);
	out = open("del1", O_CREAT| O_WRONLY, S_IRUSR|S_IWUSR);

	while((n=read(in,block,sizeof(block))) > 0) {
			if (n != BUF) {
				printf("[*] BUF is not full: %d: ", n);
				for (i=0; i<=n; i++) 
					printf("%c", block[i]);
			}
			write(out,block,n);
	}
	return 0;
}

