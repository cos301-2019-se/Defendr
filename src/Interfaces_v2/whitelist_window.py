from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
from MDTable import Table
from controller import controller
import databaseCon
import re

class Whitelist_Window(Screen):
    xdp =  controller("../")
    def add_table(self,id,list):
        db = databaseCon.connect()
        list = databaseCon.find_whiteListed_IP(db,"")
        id.add_widget(Table(table_content=list))

    def add_IP(self,ip_addr):
        db = databaseCon.connect()
        if self.check_IP(ip_addr):
            if not databaseCon.find_whiteListed_IP(db,ip_addr):
                print(ip_addr)
                print(databaseCon.rem_Blacklisted_IP(db,ip_addr))
                databaseCon.add_whiteListed_ip(db,ip_addr)
                #xdp.remove_Blacklisted_IP(ip)
        self.ids['txt_ip_addr'].text = ""

    def remove_IP(self):
        db = databaseCon.connect()
        ip =self.lst_IPs.get(self.lst_IPs.curselection())
        if self.check_IP(ip):
            databaseCon.rem_Whitelisted_IP(db, ip)


    def check_IP(self, IP):
        if(IP==""):
            print("Enter an ip")
            return False
        check = re.search(
            "([0-9])+\.([0-9])+\.([0-9])+\.([0-9])+",
            IP)
        if (check):
            return True
        else:
            print("Invalid ip.")
            return False
