#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

char* reverse_string(char* input){
	char* returnValue = malloc(sizeof(input)+1);
	int length = strlen(input);
	int j = strlen(input)-1;

	for (int i = 0; i < length; ++i)
	{
		returnValue[i]+=input[j];
		j--;
	}
	printf("%s\n", returnValue);
	return strdup(returnValue);
}

bool strcmp_reverse(char* first, char* second){
	char* reversed = reverse_string(first);

	if(strcmp(reversed, second)==0){
		free(reversed);
		return true;
	}
	else{
		free(reversed);
		return false;
	}
}

int main(int argc, char* argv[]){
	if(argc!=3){
		printf("Need 2 arguments!\n");
	}
	else{
		if(strcmp_reverse(argv[1],argv[2])){
			printf("Same!\n");
		}
		else{
			printf("Not same!\n");
		}
	}
	return 0;
}
