import os
import json

class controller:
	pathToSource = "../"
	def __init__(self, pathToSource):
		self.pathToSource = pathToSource
		
	def load_xdp(self):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo mount -t bpf bpf /sys/fs/bpf/").read()
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist --dev enp0s3 --remove --owner $USER").read()
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist --dev enp0s3 --owner $USER").read()
		return;
		
	def black_list_IP(self,ip):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --add --ip " + ip).read()
		return;
		
	def white_list_IP(self,ip):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --del --ip " + ip).read()
		return;
		
	def get_blacklisted_IP_list(self):
		data_String = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --list ").read()
		data_String = data_String.replace("\"80\" : {\t\"UDP\" : 0 }","")
		data_String = data_String.replace(" : 0","")
		data_String = data_String.replace(", }","")
		data_String = data_String.replace("{, ","")
		data_String = data_String.replace("\"","")
		data_String = data_String.replace("{,\n","")
		data_String = data_String.replace("}\n","")
		data_String = data_String.replace("\n","")
		data_String = data_String.replace("{,","")
		data_String = data_String.replace("}","")
		data_String = data_String.replace(" ","")
		if(len(data_String) == 0):
			print("No IP's currently blacklisted")
			return
		if(data_String[len(data_String)-1]==','):
			data_String = data_String[:-1]
		return data_String.split(",")
