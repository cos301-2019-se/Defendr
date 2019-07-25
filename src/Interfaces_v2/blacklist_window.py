from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
from MDTable import Table
from controller import controller

class Blacklist_Window(Screen):
    xdp =  controller("../")
    def add_table(self,id,list):
        id.add_widget(Table(table_content=list))


    def add_IP(self,ip_addr):
        self.xdp.black_list_IP(ip_addr)
        self.ids['txt_ip_addr'].text = ""

    def remove_IP(self):
        db = databaseCon.connect()
        databaseCon.rem_Blacklisted_IP(db, self.lst_IPs.get(self.lst_IPs.curselection()))
        xdp.remove_Blacklisted_IP(self.lst_IPs.get(self.lst_IPs.curselection()))
