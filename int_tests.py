import unittest
from controller import controller
import databaseCon
import sys

import random

c = controller("../")

class Test_Unit(unittest.TestCase):

	# Test case to see if a manually blacklisted IP gets logged on external db. 
	def test_Integration_XDPController_Blacklist_Interface_Database_Logs(self):
		c.black_list_IP("10.9.8.5")
		db = databaseCon.connect()
		self.assertEqual(databaseCon.find_Blacklisted_IP(db, "10.9.8.5"), "10.9.8.5", "Failed to Blacklist IP")
		
	#Test case to see if a manually blacklisted IP reflects in XDP Map
	def test_Integration_XDPController_Blacklist_Interface(self):
		c.black_list_IP("10.9.8.4")
		y = ""
		doc = c.get_blacklisted_IP_list()
		for x in doc:
			if x == "10.9.8.4":
				y = x
		self.assertEqual(y, "10.9.8.4", "Failed to Blacklist IP")
		
	# Test case to see if a blacklisted ip that is manually removed from the db reflects in XDP Map.
	def test_Integration_XDPController_RemoveBlacklist_Interface(self):
		c.remove_Blacklisted_IP("10.9.8.4")
		y = "10.9.8.4"
		doc = c.get_blacklisted_IP_list()
		for x in doc:
			if x != "10.9.8.4":
				y = ""
		self.assertEqual(y, "", "Failed to remove Blacklisted IP")
		
	# Test case to see if a blacklisted ip that is manually removed from the db reflects in External db. 
	def test_Integration_XDPController_Remove_Blacklist_Interface_Database_Logs(self):
		c.remove_Blacklisted_IP("10.9.8.6")
		db = databaseCon.connect()
		self.assertEqual(databaseCon.rem_Blacklisted_IP(db, "10.9.8.6"), "Success", "Failed to remove Blacklisted IP")


if __name__ == '__main__':
    # print("Ran " + str(counter) + "tests for Blacklist IP function")
    unittest.main()
