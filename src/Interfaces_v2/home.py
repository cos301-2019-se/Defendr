from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef

import sys

class Home(Screen):

    def load_website(self,web_url):
        # To shutdown all CEF processes on error.
        sys.excepthook = cef.ExceptHook  
        cef.Initialize()
        cef.CreateBrowserSync(url=web_url,
                              window_title="Hello World!")
        cef.MessageLoop()
        cef.Shutdown()

    def disconnect(self):
        self.manager.transition = SlideTransition(direction="right")
        self.manager.current = 'login'
        self.manager.get_screen('login').resetForm()

    def load_message(self):
        app = App.get_running_app()
        self.ids['lbl_welcome_masseg'].text="Welcome To Defendr, "+str(app.facade.get_name(app.username))+". Your are loged in as an "+str(app.facade.get_roll(app.username)+".")
        if (app.roll == "admin"):
            self.ids['on_off_switch'].opacity = 1.0
        else:
            self.ids['on_off_switch'].opacity = 0.0
        
    def start_xdp(self):
        app = App.get_running_app()
        app.facade.start_xdp()
        
    def stop_xdp(self):
        app = App.get_running_app()
        app.facade.stop_xdp()
