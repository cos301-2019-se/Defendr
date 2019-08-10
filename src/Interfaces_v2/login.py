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

from Facade import FacadeClass
import time
import datetime

class Login(Screen):
    num =3
    timer=datetime.datetime(2018, 6, 1,8,30)
    falid = False
    def do_login(self, loginText, passwordText):
        # app = App.get_running_app()
        # app.roll = "admin"

        # app.username = loginText
        # app.password = passwordText

        # self.manager.transition = SlideTransition(direction="left")
        # self.manager.current = 'home'

        # app.config.read(app.get_application_config())
        # app.config.write()
        # users = ["Jeandre", "Muhammed","Sisa","Christiaan","Ruslynn","Chris"]
        # passwds = ["jPass1","mPass1","sPass1","cPass1","rPass1","cPass1"]
        # last = ["Botha","Carrim","Khoza","Opperman","Appana","Osbrone"]
        # email = ["u17094446@tuks.co.za","u15019854@tuks.co.za","u15034993@tuks.co.za","u17023239@tuks.co.za","u14016304@tuks.co.za","Chris@gmail.com"]
        facade = FacadeClass()
        self.ids['txt_login_email'].text = ""
        self.ids['txt_login_password'].text = ""
        app = App.get_running_app()
        app.roll = "admin"

        app.username = loginText
        app.password = passwordText
        app.facade = facade

        self.manager.transition = SlideTransition(direction="left")
        self.manager.current = 'home'

        app.config.read(app.get_application_config())
        app.config.write()

        output= facade.login(loginText,passwordText)
        if (not self.falid):
            if(output=="user" or output=="admin"):
                print("succeful")
                self.ids['txt_login_email'].text = ""
                self.ids['txt_login_password'].text = ""
                app = App.get_running_app()
                app.roll = output

                app.username = loginText
                app.password = passwordText
                app.facade = facade

                self.manager.transition = SlideTransition(direction="left")
                self.manager.current = 'home'

                app.config.read(app.get_application_config())
                app.config.write()
            else:
                if(output=="Error"):
                    a = self.num - 1
                    self.num = a
                    if a == 0:
                        self.falid = True
                        facade.sendEmailHacked(loginText)
                        self.timer = datetime.datetime.now()
                        self.num = 3
                    else:
                        print(str(a) + " attends left")
                    print("re-enter info")
                else:
                    print(output)
        else:
            now = datetime.datetime.now()
            min = now.minute - self.timer.minute
            print('Wait for ' + str(min) + ' minunte before tiering again')
            if min >= 1:
                self.falid = False

        self.resetForm()

    def resetForm(self):
        self.ids['txt_login_email'].text = ""
        self.ids['txt_login_password'].text = ""