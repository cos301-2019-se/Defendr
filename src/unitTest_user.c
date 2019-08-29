#include <regex.h>
#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <locale.h>

#include <sys/resource.h>
#include <getopt.h>
#include <time.h>

#include <arpa/inet.h>

#include "libbpf.h"

#include "bpf_util.h"

#include "defendr_xdp_common.h"
//static const char *file_blacklist = "/sys/fs/bpf/ddos_blacklist";


int main(){
	FILE *fp,*file;
	printf("%s\n","Starting test...");
	printf("%s\n","Running functions...");
	file = fopen("temp.txt", "w");
	pclose(file);
	fp = popen("sudo ./xdp_ddos01_blacklist --dev enp0s3 --owner $USER >> temp.txt", "r");
	pclose(fp);
	printf("%s\n","Checking results...");
	file = fopen("tcpdumpTest.txt", "w");
	pclose(file);
	fp = popen("sudo tcpdump -i enp0s3 -n -c 10 >> tcpdumpTest.txt", "r");	
	pclose(fp);
	
	int numErr = 0;
	char tmp[256]={0x0};

	int fd_blacklist;
	__u32 key, *prev_key = NULL;

	fd_blacklist  = open_bpf_map(file_blacklist);
	while (bpf_map_get_next_key(fd_blacklist, prev_key, &key) == 0) {

		//value = get_key32_value64_percpu(fd_blacklist, key);
		char ip_txt[INET_ADDRSTRLEN] = {0};

		/* Convert IPv4 addresses from binary to text form */
		inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt));
		file = fopen("tcpdumpTest.txt", "r");
	   	 while(file && fgets(tmp, sizeof(tmp), file)){
	        	 if (strstr(tmp,  ip_txt))
				numErr++;
   		 }
  		fclose(file);
		prev_key = &key;
	}

	printf("%s\n","Done");
	printf("%s	%d\n","Number of breaches",numErr);
	printf("%s\n","====================");
	if(numErr == 0) printf("%s\n","TEST PASSED");
	else printf("%s\n","TEST FAILED");
	printf("%s\n","====================");

	return 0;
}
