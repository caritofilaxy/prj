#include<sys/types.h>
#include<sys/socket.h>
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>
#include<netdb.h>
#include<errno.h>


const char msg[] = "you are looser!\n";

int main(int argc, char **argv) {

	if (argc != 2) {
		fprintf(stderr, "too few args\n");
		return 1;
	}
	
	short port = atoi(argv[1]);
	int sockfd, bindret, lisret, errnum;
	struct sockaddr_in simpleServer;

	sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sockfd == -1) {
		fprintf(stderr, "Can not create socket\n");
		return 2;
	}

	bzero(&simpleServer, sizeof(simpleServer));
	
	simpleServer.sin_family = AF_INET;
	simpleServer.sin_addr.s_addr = htonl(INADDR_ANY);
	simpleServer.sin_port = htons(port);
	
	bindret = bind(sockfd,(struct sockaddr *)&simpleServer, sizeof(simpleServer));
	if (bindret == -1) {
		/* fprintf(stderr, "can not bind address\n"); */
		errnum = errno;
		fprintf(stderr, "errno: %d\n",  errno);
		perror("Printed by perror");
		fprintf(stderr, "strerror : %s\n", strerror(errnum));
		close(sockfd);
		return 3;
	}

	
	lisret = listen(sockfd, 5);
	if (lisret == -1) {
		fprintf(stderr, "can not listen\n");
		return 4;
	}

	for (;;) {
		struct sockaddr_in clientName = { 0 };
		int simpleChildSocket = 0;
		int clientNameLength = sizeof(clientName);

		simpleChildSocket = accept(sockfd, (struct sockaddr *)&clientName, &clientNameLength);
		if (simpleChildSocket == -1) {
			fprintf(stderr, "can not accept connections\n");
			close(sockfd);
			return 5;
		}
		
		write(simpleChildSocket, msg, strlen(msg));
		close(simpleChildSocket);
	
		}

	close(sockfd);
	return 0;
}
