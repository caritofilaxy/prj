#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(void) {
	
	int n, in, out;
	char c;

	in = open("cnus.txt", O_RDONLY);
	out = open("del2", O_CREAT| O_WRONLY, S_IRUSR|S_IWUSR);

	while((n=read(in,&c,1)) == 1)
		write(out,&c,1);

	return 0;
}

