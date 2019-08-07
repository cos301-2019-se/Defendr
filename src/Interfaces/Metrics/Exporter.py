from prometheus_client import start_http_server
from prometheus_client import Histogram
from prometheus_client import Info
from prometheus_client import Summary

h = Histogram('request_latency_seconds', 'Histogram depicting the latency in seconds per request')
i = Info('Defendr', 'DoS protection and Network load-balancer')
i.info({'version' : '1.0', 'buildhost' : 'defendr@darknites'})
#s = Summary('request_latency_seconds', 'Request latency in seconds')

def loop():
	i = 1
	while(True):
		i = i+1
		print(i)

def start():
	h.observe(4.7)
	#s.observe(4.7)
	start_http_server(8000)

	
start()
loop()