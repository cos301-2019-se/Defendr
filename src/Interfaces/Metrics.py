import webbrowser
import subprocess
import sys
import time

#Ensure a requisite library is installed
def install(package):
	subprocess.call([sys.executable, "-m", "pip", "install", package])
install("prometheus_client")

def start():
	subprocess.Popen('./node_exporter', cwd='Metrics/node_exporter')
	subprocess.Popen('./prometheus', cwd='Metrics/Prometheus')
	subprocess.Popen('./grafana-server', cwd='Metrics/Grafana/bin')

def execute():
	webbrowser.open("http://localhost:3000/d/L7frhkNWk/defendr-system-load?orgId=1", new=2)

def stop():
	subprocess.call(['killall grafana-server'], shell=True)
	#time.sleep(1)
	subprocess.call(['killall prometheus'], shell=True)
	#time.sleep(1)
	subprocess.call(['killall node_exporter'], shell=True)

start() #startup of scrapers
execute() #statrup of browser
stop() #shutdown of scrapers
