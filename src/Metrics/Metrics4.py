import subprocess
import sys
import webbrowser
#from prometheus_client import ProcessCollector

def install(package):
	subprocess.call([sys.executable, "-m", "pip", "install", package])
install("prometheus_client")

from prometheus_client import start_http_server, Summary
import random
import time

# Create a metric to track time spent and requests made.
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

# Decorate function with metric.
@REQUEST_TIME.time()
def process_request(t):
    """A dummy function that takes some time."""
    time.sleep(t)

if __name__ == '__main__':
    #webbrowser.open("http://localhost:3000/d/L7frhkNWk/defendr-system-load?orgId=1",new=2);
    # Start up the server to expose the metrics.
    start_http_server(8000)
    # Generate some requests.
    while True:
        process_request(random.random())
