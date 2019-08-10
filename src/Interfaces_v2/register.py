from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
import re
import databaseCon
import emailSender
from Facade import FacadeClass

class Register(Screen):
    def do_go_to_login(self,name,surname,email,password,confirm_pass):
        facade = FacadeClass()
        self.resetForm()
        facade.register(name,surname,email,password,confirm_pass)
    
    def resetForm(self):
        self.ids['name'].text = ""
        self.ids['surname'].text = ""
        self.ids['email'].text = ""
        self.ids['password'].text = ""
        self.ids['confirm_pass'].text = ""