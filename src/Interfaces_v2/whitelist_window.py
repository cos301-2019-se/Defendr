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

    def add_table(self,id,list):
        app = App.get_running_app()
        id.add_widget(Table(table_content=app.facade.list_with_ip("")))

    def add_IP(self,ip_addr):
        app = App.get_running_app()
        app.facade.add_with_ip(ip_addr)
        self.ids['txt_ip_addr'].text = ""

    def remove_IP(self, ip_addr):
        app = App.get_running_app()
        app.facade.remove_with_ip(ip_addr)
        self.ids['txt_ip_addr'].text = ""
