#include<sys/types.h>
#include<sys/socket.h>
/* struct sockaddr_in */
#include<netinet/in.h>
/* inet_addr funcion */
#include<arpa/inet.h>


int main(void) {

	int sockd;
	struct sockaddr_in xfersrv;
	
	sockd = socket(AF_INET, SOCK_STREAM, 0);
	
	xfersrv.sin_family = AF_INET;
	xfersrv.sin_addr.s_addr = inet_addr("127.0.0.1");
	xfersrv.sin_port = htons(80);

	connect(sockd, (struct sockaddr *)&xfersrv, sizeof(xfersrv));

	return 0;
	}
