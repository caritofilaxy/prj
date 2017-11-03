#include<stdio.h>
#include<sys/types.h>
#include<sys/socket.h>

int main(void) {

	int sockfd;
	
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	


    return 0;
}
