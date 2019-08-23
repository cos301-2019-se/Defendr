import unittest
from controller import controller
import random
from datetime import date

c = controller("../")



class Test_Unit(unittest.TestCase):
    
    f= open("log_file.txt","a")
    
    IPs = [None] *10

    # Unit test to see if the controller is working and available.    
    def test_load(self):
        result = c.loadXdp()
        self.assertEqual(result,"success","Did not load Xdp") 
        f.write(" - Attempting to load xdp program" + " " + result + " \n" ) 
    # Unit test to see if black list function is available and working.    
    def test_black1(self):
        
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(". - Attempting to blacklist IP " + ip + " "+ result + " \n" ) 
 
    # Unit test to see if black list function is available and working.
    def test_black2(self):
       
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" ) 
    # Unit test to see if black list function is available and working.
    def test_black3(self):
        
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
 
    # Unit test to see if black list function is available and working.
    def test_black4(self):
        
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
 
    # Unit test to see if black list function is available and working.
    def test_black5(self):
       
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
    # Unit test to see if black list function is available and working.
    def test_black6(self):
        
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
 
    # Unit test to see if black list function is available and working.
    def test_black7(self):
       
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
    # Unit test to see if black list function is available and working.
    def test_black8(self):
        
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
 
    # Unit test to see if black list function is available and working.
    def test_black9(self):
        
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )
 
    # Unit test to see if black list function is available and working.
    def test_black10(self):
       
            ip = ".".join(map(str,(random.randint(0,255)for _ in range(4))))           
            result = c.black_list_IP(ip)
            self.assertEqual(result,"success", "Failed to blacklist IP" )
            f.write(" - Attempting to blacklist IP " + ip + " "+ result + " \n" )

                
   
    f.close()          

#if __name__ == '__main__':
   
    #unittest.main()
#suite = unittest.TestLoader().loadTestsFromTestCase(Test_Unit)
#unittest.TextTestRunner(verbosity=2).run(suite)

if __name__ == '__main__':
    log_file = 'log_file.txt'
    with open(log_file, "a") as f:
        runner = unittest.TextTestRunner(f)
        unittest.main(testRunner=runner)
       



