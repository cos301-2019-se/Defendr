from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
from MDTable import Table
from Facade import FacadeClass
from controller import controller
import databaseCon

class Blacklist_Window(Screen):
    xdp =  controller("../")
    table =""

    def add_table(self,id):
        app = App.get_running_app()
        if (not (self.table == "")):
            id.remove_widget(self.table)
        self.table = Table(table_content=app.facade.list_black_ip(""))
        id.add_widget(self.table)

    def add_IP(self,ip_addr):
        app = App.get_running_app()
        app.facade.add_black_ip(ip_addr)
        self.ids['txt_ip_addr'].text = ""

    def remove_IP(self, ip_addr):
        app = App.get_running_app()
        app.remove_black_ip(ip_addr)
        self.ids['txt_ip_addr'].text = ""
