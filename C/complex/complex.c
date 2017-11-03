#include <stdio.h>
#include <stdlib.h>

typedef struct {
	int real_part;
	int imag_part;
} complex;

void setArraySize(int *N) {
	printf("Please enter size of 2D array: ");
	scanf("%d", N);
	if(*N <= 0) {
		*N = 5;
	}
}

void allocateArray(complex *** arr, int size) {
	// allocate memory for 2D array
	*arr = (complex **) malloc(sizeof (complex *) * size);
	for(int i = 0; i < size; i++) {
		(*arr)[i] = (complex *) malloc(sizeof (complex) * size);
	}
}

int main(void) {
	complex **Arr;
	int N;
	setArraySize(&N);

	allocateArray(&Arr, N);

	// fill and print values
	for(int i = 0; i < N; i++) {
		for(int j = 0; j < N; j++) {
			Arr[i][j].real_part = i;
			Arr[i][j].imag_part = j;
			printf("Arr[%d][%d]= %d,%d ", i, j, Arr[i][j].real_part,
			       Arr[i][j].imag_part);
		}
		printf("\n");
	}

	//clean it up
	for(int i = 0; i < N; i++) {
		free(Arr[i]);
	}
	free(Arr);

	return 0;
}
