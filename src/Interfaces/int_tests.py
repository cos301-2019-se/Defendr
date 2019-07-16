import unittest
from controller import controller
import databaseCon
import sys
from IPList import win_IPList

import random

c = controller("../")

class Test_Unit(unittest.TestCase):

    def test_XDPController_Blacklist_Integration_Interface(self):
	#c = controller("../")
	c.blackListIP("192.168.43.252")
        ipList = c.getBlacklistedIpList()
        for x in ipList:
		self.assertEqual(x, "192.168.43.252", "Failed to Blacklist IP")


if __name__ == '__main__':
    # print("Ran " + str(counter) + "tests for Blacklist IP function")
    unittest.main()
