import unittest
from controller import controller
import databaseCon
import sys
import IPList

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
    def test_XDPController_Blacklist_Integration_Interface(self):
        c = controller("../")
        self.assertEqual(IPList.addIP("192.168.43.252"), "Success", "Failed to blacklist IP")

        ipList = c.getBlacklistedIpList()
        for x in ipList:
            self.assertEqual(x, "192.168.43.252", "Success", "Failed to Blacklist IP")


if __name__ == '__main__':
    # print("Ran " + str(counter) + "tests for Blacklist IP function")
    unittest.main()
