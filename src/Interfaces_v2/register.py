from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys



class Register(Screen):
    def do_go_to_login(self):
        self.manager.transition = SlideTransition(direction="left")
        self.manager.current = 'login'
        self.manager.get_screen('login').resetForm()
    
    def resetForm(self):
        self.ids['name'].text = ""
        self.ids['surname'].text = ""
        self.ids['email'].text = ""
        self.ids['password'].text = ""
        self.ids['confirm_pass'].text = ""
        