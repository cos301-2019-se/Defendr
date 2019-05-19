#include <bits/stdc++.h>
#include <iostream>
using namespace std;

int main(){
	string command;
	do{
		cout << "Control@Defendr>";
		getline(cin,command);
		if(command == "setup"){
			 system("sudo mount -t bpf bpf /sys/fs/bpf/");
			 system("sudo ./xdp_ddos01_blacklist --dev enp0s3 --owner $USER");
		}			
	}while(command != "quit");
	return 0;
}
