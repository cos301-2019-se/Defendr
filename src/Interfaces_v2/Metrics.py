from prometheus_client import start_http_server
from prometheus_client import Histogram
from prometheus_client import Info
from prometheus_client import Summary

import webbrowser
import subprocess
import sys
import time
from controller import controller

# Ensure all requisite libraries are installed.
def install(package):
	subprocess.call([sys.executable, "-m", "pip", "install", package])

def start():
	h.observe(4.7)
	#s.observe(4.7)
	start_http_server(8000)
	subprocess.Popen('./node_exporter', cwd='Metrics/node_exporter')
	time.sleep(2)
	subprocess.Popen('./prometheus', cwd='Metrics/Prometheus')
	time.sleep(2)
	subprocess.Popen('./grafana-server', cwd='Metrics/Grafana/bin')

def execute():
	webbrowser.open("http://localhost:3000/d/L7frhkNWk/defendr-system-load?orgId=1", new=2)

def stop():
	subprocess.call(['killall grafana-server'], shell=True)
	#time.sleep(1)
	subprocess.call(['killall prometheus'], shell=True)
	#time.sleep(1)
	subprocess.call(['killall node_exporter'], shell=True)

# Instance of data types.
h = Histogram('request_latency_seconds', 'Histogram depicting the latency in seconds per request')
i = Info('Defendr', 'DoS protection and Network load-balancer')
i.info({'version' : '1.0', 'buildhost' : 'defendr@darknites'})

#c = controller("../")
#c.load_xdp()
#c.get_blacklisted_IP_list()