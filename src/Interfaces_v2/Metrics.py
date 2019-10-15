from prometheus_client import start_http_server
from prometheus_client import Histogram
from prometheus_client import Info
from prometheus_client import Summary
from prometheus_client import Gauge

import subprocess
import sys
import time
import IP2Location
import threading
import os

from databaseCon import database

database = database()
database_connects = database.connect()
now = str(time.time())[0:10]
ips = []
locator = IP2Location.IP2Location()
locator.open("Metrics/IP-COUNTRY.BIN")
countries = dict()
thread = ""
connections_per_country_thread = ""
stopThread = False

#Initial information metrics
h = Histogram('request_latency_seconds', 'Histogram depicting the latency in seconds per request')
i = Info('Defendr', 'DoS protection and Network load-balancer')
i.info({'version' : '1.0', 'buildhost' : 'defendr@darknites'})
connections_per_country = Gauge('connections_per_country', 'Number of unique connections per country', ['country'])
blacklisted_ips_count = Gauge('blacklisted_ips_count', 'Number of currently blacklisted IP addresses', ['blacklisted'])
whitelisted_ips_count = Gauge('whitelisted_ips_count', 'Number of currently whitelisted IP addresses', ['whitelisted'])
connected_backends_count = Gauge('connected_backends_count', 'Number of currently connected backend services', ['connections'])
blacklisted_ips_count.labels("blacklisted_ips_count").set(0)
whitelisted_ips_count.labels("whitelisted_ips_count").set(0)
connected_backends_count.labels("connected_backends_count").set(0)

#Ensure all requisite libraries are installed
def install(package):
	subprocess.call([sys.executable, "-m", "pip", "install", package])

def start():
	h.observe(4.7)
	#s.observe(4.7)
	#commands = ["tar -xf Metrics.tar.gz", "rm Metrics.tar.gz"]
	#for command in commands:
	#	os.popen(command)
	#time.sleep(5)

	start_http_server(8000)

	subprocess.Popen('./node_exporter', cwd='Metrics/node_exporter')
	time.sleep(2)
	subprocess.Popen('./prometheus', cwd='Metrics/Prometheus')
	time.sleep(2)
	subprocess.Popen('./grafana-server', cwd='Metrics/Grafana/bin')
	#subprocess.run("rm Metrics.tar.gz")
	stopThread = False
	connections_per_country_thread = threading.Thread (target=countries_heatmap_metrics, args= (database,database_connects, "15000000", ips, locator, countries, connections_per_country, stopThread))
	connections_per_country_thread.start()

def stop():
	#commands = ["killall grafana-server", "killall prometheus", "killall node_exporter", "tput setaf 1; \"Please do not close this window, the system is performing Metrics system compression\";tput sgr0", "tar -czf Metrics.tar.gz Metrics", "tput setaf 2; \"Metrics compression complete; it is now safe to close this window.\";tput sgr0", "rm -r Metrics"]

	commands = ["killall grafana-server", "killall prometheus", "killall node_exporter"]

	for command in commands:
		subprocess.call([command], shell=True)
	#os.popen("rm -r Metrics")
	stopThread = True
	connections_per_country_thread.stop()

def countries_heatmap_metrics(database,database_connects, now, ips, locator, countries, metric, stopThread):
	registered = []
	database_connects = database.connect()
	ips = database.get_connection_ips(database_connects, now)

	while stopThread == False:
		for x in ips:
			print(x)
			country_code = locator.get_all(x).country_short
			if country_code in countries:
				if x in registered:
					print("IP is registered")
				else:
					countries[country_code] = countries[country_code] + 1
					connections_per_country.labels(country_code).set(countries[country_code])
					registered.append(x)

			else:
				countries.update({str(country_code): 1})
				connections_per_country.labels(country_code).set(countries[country_code])
				registered.append(x)
		blacklisted_ips_count_metrics()
		whitelisted_ips_count_metrics()
		connected_backends_count_metrics()
		time.sleep(10)
		ips = ""
		database_connects = database.connect()
		ips = database.get_connection_ips(database_connects, now)
	print("***Stopping connections_per_country***")

def blacklisted_ips_count_metrics():
	text = os.popen("../defendr_xdp_cmdline --stats").read()
	blacklisted_ips_count.labels("blacklisted_ips_count").set(text[text.find("blacklist:")+10:text.find("whitelist:")-2].count(".")/3)


def whitelisted_ips_count_metrics():
	text = os.popen("../defendr_xdp_cmdline --stats").read()
	whitelisted_ips_count.labels("whitelisted_ips_count").set(text[text.find("whitelist:")+10:len(text)-2].count(".")/3)

def connected_backends_count_metrics():
	text = os.popen("../defendr_xdp_cmdline --stats").read()
	count = text[text.find("services")+10:text.find("],")+1].find(" ")
	if int(count) <= 0:
		connected_backends_count.labels("connected_backends_count").set(0)
	else:
		connected_backends_count.labels("connected_backends_count").set(count)