#include<stdio.h>
#include<unistd.h>

#define CHUNK 65536

int main(int argc, char **argv) {

	if (argc != 2) {
		printf("xor_e2 {filename}\n");
		return -1;
	}
	
	FILE *fd;
	unsigned char d[CHUNK];
	
	fd = fopen(argv[1], "r+");
	
	unsigned int i, xz_read;


	while((xz_read = fread(&d, sizeof(char), CHUNK, fd)) == CHUNK) {
		for (i=0; i<CHUNK; i++)
			d[i] ^= 0xe2;

		fseek(fd, SEEK_CUR-CHUNK-1, SEEK_CUR);
		fwrite(&d, sizeof(char), CHUNK, fd);
	}

	/* fread discards incomplete object so last iteration done separately */
	
	fread(&d, sizeof(char), xz_read, fd);
	for (i=0; i<xz_read; i++)
		d[i] ^= 0xe2;
		fseek(fd, SEEK_CUR-xz_read-1, SEEK_CUR);
	fwrite(&d, sizeof(char), xz_read, fd);

	fclose(fd);

	return 0;
}
