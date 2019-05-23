import os
import json

class controller:
	pathToSource = "../"
	def __init__(self, pathToSource):
		self.pathToSource = pathToSource
		
	def loadXdp(self):
		myCmd = os.popen("cd " + self.pathToSource + " && sudo mount -t bpf bpf /sys/fs/bpf/").read()
		myCmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist --dev enp0s3 --remove --owner $USER").read()
		myCmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist --dev enp0s3 --owner $USER").read()
		#print(myCmd)
		os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --del --ip " + "198.18.50.3").read()
		return "success";
		
	def blacklistIP(self,ip):
		testIP = ip
		myCmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --add --ip " + ip).read()
		testData = self.getBlacklistedIpList()
		if testIP in testData:
			return "success"
		else:
			return "Failure"
		
	def whiteListIP(self,ip):
		myCmd = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --del --ip " + ip).read()
		return;
		
	def getBlacklistedIpList(self):
		dataString = os.popen("cd " + self.pathToSource + " && sudo ./xdp_ddos01_blacklist_cmdline --list ").read()
		dataString = dataString.replace("\"80\" : {\t\"UDP\" : 0 }","")
		dataString = dataString.replace(" : 0","")
		dataString = dataString.replace(", }","")
		dataString = dataString.replace("{, ","")
		dataString = dataString.replace("\"","")
		dataString = dataString.replace("{,\n","")
		dataString = dataString.replace("}\n","")
		dataString = dataString.replace("\n","")
		dataString = dataString.replace("{,","")
		dataString = dataString.replace("}","")
		dataString = dataString.replace(" ","")
		if(len(dataString) == 0):
			print("No IP's currently blacklisted")
			return
		if(dataString[len(dataString)-1]==','):
			dataString = dataString[:-1]
		return dataString.split(",")

