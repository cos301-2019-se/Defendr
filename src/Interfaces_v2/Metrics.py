from prometheus_client import start_http_server
from prometheus_client import Histogram
from prometheus_client import Info
from prometheus_client import Summary
from prometheus_client import Gauge
from prometheus_client.core import GaugeMetricFamily, REGISTRY

import webbrowser
import subprocess
import sys
import time
import os
import time
import IP2Location
import threading

from databaseCon import database

database = database()
database_connects = database.connect()
now = str(time.time())[0:10]
ips = []
locator = IP2Location.IP2Location()
locator.open("Metrics/IP-COUNTRY.BIN")
countries = dict()

h = Histogram('request_latency_seconds', 'Histogram depicting the latency in seconds per request')
i = Info('Defendr', 'DoS protection and Network load-balancer')
i.info({'version' : '1.0', 'buildhost' : 'defendr@darknites'})
connections_per_country = Gauge('connections_per_country', 'Number of unique connections per country',['country'])
connections_per_country.labels('ZA').set(5)
connections_per_country.labels('CN').set(12)
connections_per_country.labels('KE').set(10)

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

def execute():
	webbrowser.open("http://localhost:3000/d/u_DVKhQiz/defendr-software-load?orgId=1", new=2)

def stop():
	#commands = ["killall grafana-server", "killall prometheus", "killall node_exporter", "tput setaf 1; \"Please do not close this window, the system is performing Metrics system compression\";tput sgr0", "tar -czf Metrics.tar.gz Metrics", "tput setaf 2; \"Metrics compression complete; it is now safe to close this window.\";tput sgr0", "rm -r Metrics"]

	commands = ["killall grafana-server", "killall prometheus", "killall node_exporter"]

	for command in commands:
		subprocess.call([command], shell=True)
	#os.popen("rm -r Metrics")
	thread.stop()


#Mock counters
'''
class CustomCollector(object):
	database = ""
	database_connects = ""
	metric_counter = ""
	now = ""
	ips = ""
	locator = ""
	countries = ""

	def __init__(self):
		self.metric_counter = GaugeMetricFamily('connections_per_country', 'Help', labels=['country'])
		self.locator = IP2Location.IP2Location()
		self.locator.open("Metrics/IP-COUNTRY.BIN")
		self.now = str(time.time())[0:10]
		self.database = database()
		self.database_connects = self.database.connect()
		self.countries = dict()
	
	def collect(self):
		self.ips = self.database.get_connection_ips(self.database_connects, self.now)

		for x in self.ips:
			country_code = self.locator.get_all(str(x)).country_short
			print("IP 2: " + x + "\t" + country_code)
			if len(country_code) == 2:
				if country_code in self.countries:
					#increment the country's counter in the dictionary
					self.countries[country_code] = self.countries[country_code] + 1
					#increment the country's gauge
					
				else:
					#create a metric, and initialise it to 1
					self.countries.update({str(country_code): 1})
					self.metric_counter.add_metric([str(country_code)], 1)

		for country_code in self.countries:
			print(country_code + " has " + str(self.countries[country_code]) + " connection(s)")
		

		#self.metric_counter.add_metric(['GB'], 4)
		#self.metric_counter.add_metric(['US'], 15)
		#self.metric_counter.add_metric(['IE'], 10)
		#self.metric_counter.add_metric(['FR'], 7)
		#self.metric_counter.add_metric(['ZA'], 9)
		yield self.metric_counter
	
	def parse():
		return

REGISTRY.register(CustomCollector())
'''

def worker(database,database_connects, now, ips, locator, countries, metric):
	registered = []
	database_connects = database.connect()
	ips = database.get_connection_ips(database_connects, now)
	while True:
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
		time.sleep(10)
		ips = ""
		database_connects = database.connect()
		ips = database.get_connection_ips(database_connects, now)
	

thread = threading.Thread(target=worker, args=(database,database_connects, now, ips, locator, countries, connections_per_country))
thread.start()
