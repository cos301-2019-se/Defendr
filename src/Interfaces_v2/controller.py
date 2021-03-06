import os

# Class XDP Controller(Allows front end to communicate with backend).
class controller:
	pathToSource = "../"
	# Initialise path to source file.
	def __init__(self, pathToSource):
		self.pathToSource = pathToSource
		
	# Load the XDP program.
	def load_xdp(self):
		os.popen("cd " + self.pathToSource + " && sudo mount -t bpf bpf /sys/fs/bpf/")
		os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp --dev enp0s3 --owner $USER --remove")
		os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp --dev enp0s3 --owner $USER")
		os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --log")
		os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --dynamic")
		return;

	# Unload the XDP program.
	def unload_xdp(self):
		os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp --dev enp0s3 --owner $USER --remove")
		return;
		
	# Function to add blacklisted IP's to blacklisted map.	
	def black_list_IP(self,ip):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --blacklist --add --ip " + ip).read()
		return;
		
	# Function to remove blacklisted ip's from blacklist map.
	def remove_Blacklisted_IP(self,ip):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --blacklist --del --ip " + ip).read()
		return;
		
	# Function to return all ip's from blacklist map as a string array.
	def get_blacklisted_IP_list(self):
		data_String = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --blacklist --list ").read()
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

	# Function to add whitelisted IP's to whitelist map.
	def white_list_IP(self, ip):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --whitelist --add --ip " + ip).read()
		return;

	# Function to remove whitelisted ip's from whitelist map.
	def remove_whitelisted_IP(self, ip):
		my_Cmd = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --whitelist --del --ip " + ip).read()
		return;

	# Function to return all ip's from whitelist map as a string array.
	def get_whitelisted_IP_list(self):
		data_String = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --whitelist --list ").read()
		data_String = data_String.replace("\"80\" : {\t\"UDP\" : 0 }", "")
		data_String = data_String.replace(" : 0", "")
		data_String = data_String.replace(", }", "")
		data_String = data_String.replace("{, ", "")
		data_String = data_String.replace("\"", "")
		data_String = data_String.replace("{,\n", "")
		data_String = data_String.replace("}\n", "")
		data_String = data_String.replace("\n", "")
		data_String = data_String.replace("{,", "")
		data_String = data_String.replace("}", "")
		data_String = data_String.replace(" ", "")
		if (len(data_String) == 0):
			print("No IP's currently blacklisted")
			return
		if (data_String[len(data_String) - 1] == ','):
			data_String = data_String[:-1]
		return data_String.split(",")

	# Function to return current system and recourse statistics.
	def get_stats(self):
		data_String = os.popen("cd " + self.pathToSource + " && sudo ./defendr_xdp_cmdline --stats ").read()
		return data_String;
