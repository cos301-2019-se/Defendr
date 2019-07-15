import unittest
from controller import controller
import random

c = controller("../")

# def test_load():
#     assert c.loadXdp() == "success", "Did not load Xdp"

# def test_black():
#     assert c.blacklistIP("198.18.50.3") == "success", "Failed to blacklist IP"

# def test_white():
#     assert c.whiteListIP("198.18.50.3") == "success", "Failed to blacklist IP"

# if __name__ == '__main__':
#     test_black()
#     test_load()
#     test_white()
#     unittest.main()

class Test_Unit(unittest.TestCase):
    
    def test_load(self):
        self.assertEqual(c.loadXdp(),"success","Did not load Xdp")  

    def test_black(self):
        counter = 1
        for i in range(1,50):
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            #sIP = "198.18.50." 
            #sIP = sIP + str(counter)
            self.assertEqual(c.blacklistIP(ip),"success", "Failed to blacklist IP") 
            #print(c.getBlacklistedIpList())
            counter = counter +1
    

if __name__ == '__main__':
    #print("Ran " + str(counter) + "tests for Blacklist IP function")
    unittest.main()