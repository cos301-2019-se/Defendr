from prometheus_client.core import CounterMetricFamily, REGISTRY

class CustomCollector(object):
    countries
    __init__(self,metric):

    
	def collect(self):
		c = CounterMetricFamily('my_test_counter_total', 'Help', labels=['country'])
		c.add_metric(['GB'], 4)
		c.add_metric(['US'], 15)
		c.add_metric(['IE'], 10)
		c.add_metric(['FR'], 7)
		c.add_metric(['ZA'], 9)
		yield c
REGISTRY.register(CustomCollector())