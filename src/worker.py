import os
import json

def connected_backends_count_metrics():
    text = os.popen("./defendr_xdp_cmdline --stats").read()
    print(text)
	#count = text[text.find("services")+10:text.find("],")+1].find(" ")
	#if int(count) <= 0:
		#connected_backends_count.labels("connected_backends_count").set(0)
	#else:
		#connected_backends_count.labels("connected_backends_count").set(count)
    print(json.loads(text))

connected_backends_count_metrics()