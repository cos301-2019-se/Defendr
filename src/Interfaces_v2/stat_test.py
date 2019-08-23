from controller import controller

xdp =  controller("../")
data = xdp.get_stats()
print(data)