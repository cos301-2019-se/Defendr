import os
os.environ['KIVY_GL_BACKEND'] = 'sdl2'
from kivy.core.window import Window
from kivy.app import App
from kivy.properties import StringProperty
from kivy.uix.screenmanager import ScreenManager, Screen, SlideTransition
from kivy.lang import Builder
from kivy.properties import ObjectProperty, StringProperty
from kivymd.theming import ThemeManager
from navigationdrawer import NavigationDrawer
from cefpython3 import cefpython as cef
from kivy.core.window import Window
import sys

from home import Home
from blacklist_window import Blacklist_Window
from whitelist_window import Whitelist_Window
from logs_window import  Logs_Window
from login import Login
from register import Register
from user_management_window import User_Management_Window


class Navigator(NavigationDrawer):
    image_source = StringProperty('images/shield2.png')
    title = StringProperty('Navigation')

class LoginApp(App):
    theme_cls = ThemeManager()
    #theme_cls.theme_style = 'Dark'
    #theme_cls.primary_palette = 'DeepPurple'
    theme_cls.accent_palette = 'Grey'
    nav_drawer = ObjectProperty()
    username = StringProperty(None)
    password = StringProperty(None)
    manager = ScreenManager()
    roll="user"

    def build(self):
        self.manager.add_widget(Login(name='login'))
        self.manager.add_widget(Register(name='register'))
        self.manager.add_widget(Home(name='home'))
        self.manager.add_widget(Blacklist_Window(name='blacklist_window'))
        self.manager.add_widget(Whitelist_Window(name='whitelist_window'))
        self.manager.add_widget(Logs_Window(name='logs_window'))
        self.manager.add_widget(User_Management_Window(name='user_management_window'))
        self.nav_drawer = Navigator()
        Window.size = (1100, 700)
        Window.minimum_width = 1100
        Window.minimum_height = 700
        return self.manager

    def get_application_config(self):
        if(not self.username):
            return super(LoginApp, self).get_application_config()

        conf_directory = self.user_data_dir + '/' + self.username

        if(not os.path.exists(conf_directory)):
            os.makedirs(conf_directory)

        return super(LoginApp, self).get_application_config(
            '%s/config.cfg' % (conf_directory)
        )

    def nav_to(self, window):
        print(self.roll)
        if(window == 'login'):
            self.manager.transition = SlideTransition(direction="right")
        else:
            self.manager.transition = SlideTransition(direction="left")
        if(self.roll=="admin"):
            self.manager.current = window
        else:
            if(window=="logs_window" or window=="home" or window =="login" or window =="register"):
                self.manager.current = window


    def load_website(self, web_url):
        sys.excepthook = cef.ExceptHook  # To shutdown all CEF processes on error
        cef.Initialize()
        cef.CreateBrowserSync(url=web_url,
                              window_title="Hello World!")
        cef.MessageLoop()
        cef.Shutdown()







if __name__ == '__main__':
    LoginApp().run()
