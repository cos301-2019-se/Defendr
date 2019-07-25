from kivy.core.window import Window
from kivy.app import App
from kivy.properties import StringProperty
from kivy.uix.screenmanager import ScreenManager, Screen, SlideTransition
from kivy.lang import Builder
from kivy.properties import ObjectProperty, StringProperty
from kivymd.theming import ThemeManager
from navigationdrawer import NavigationDrawer
from cefpython3 import cefpython as cef
import sys

from home import Home
from blacklist_window import Blacklist_Window
from logs_window import  Logs_Window
from user_management_window import User_Management_Window
from kivy.core.window import Window

class Login(Screen):
    def do_login(self, loginText, passwordText):
        app = App.get_running_app()

        app.username = loginText
        app.password = passwordText

        self.manager.transition = SlideTransition(direction="left")
        self.manager.current = 'home'

        app.config.read(app.get_application_config())
        app.config.write()

    def resetForm(self):
        self.ids['txt_login_email'].text = ""
        self.ids['txt_login_password'].text = ""