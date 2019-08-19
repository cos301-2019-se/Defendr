from prometheus_client import start_http_server
from prometheus_client import Histogram
from prometheus_client import Info
from prometheus_client import Summary
from prometheus_client.core import CounterMetricFamily, REGISTRY

import webbrowser
import subprocess
import sys
import time
import os

#Ensure all requisite libraries are installed
def install(package):
	subprocess.call([sys.executable, "-m", "pip", "install", package])

def start():
	h.observe(4.7)
	#s.observe(4.7)
	commands = ["tar -xf Metrics.tar.gz", "rm Metrics.tar.gz"]
	for command in commands:
		os.popen(command)
	time.sleep(5)

	start_http_server(8000)

	subprocess.Popen('./node_exporter', cwd='Metrics/node_exporter')
	time.sleep(2)
	subprocess.Popen('./prometheus', cwd='Metrics/Prometheus')
	time.sleep(2)
	subprocess.Popen('./grafana-server', cwd='Metrics/Grafana/bin')
	#subprocess.run("rm Metrics.tar.gz")

def execute():
	webbrowser.open("http://localhost:3000/d/L7frhkNWk/defendr-system-load?orgId=1", new=2)

def stop():
	commands = ["killall grafana-server", "killall prometheus", "killall node_exporter", "tput setaf 1; \"Please do not close this window, the system is performing Metrics system compression\";tput sgr0", "tar -czf Metrics.tar.gz Metrics", "tput setaf 2; \"Metrics compression complete; it is now safe to close this window.\";tput sgr0", "rm -r Metrics"]

	for command in commands:
		subprocess.call([command], shell=True)
	#os.popen("rm -r Metrics")
	

#Instance of data types
h = Histogram('request_latency_seconds', 'Histogram depicting the latency in seconds per request')
i = Info('Defendr', 'DoS protection and Network load-balancer')
i.info({'version' : '1.0', 'buildhost' : 'defendr@darknites'})

#Mock counters
class CustomCollector(object):
	def collect(self):
		c = CounterMetricFamily('my_test_counter_total', 'Help', labels=['country'])
		c.add_metric(['GB'], 4)
		c.add_metric(['US'], 15)
		c.add_metric(['IE'], 10)
		c.add_metric(['FR'], 7)
		c.add_metric(['ZA'], 9)
		yield c
REGISTRY.register(CustomCollector())