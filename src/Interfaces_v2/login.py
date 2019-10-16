
from kivy.app import App
from kivy.uix.screenmanager import  Screen, SlideTransition


from Facade import FacadeClass
import datetime

class Login(Screen):
    num =3
    timer=datetime.datetime(2018, 6, 1,8,30)
    falid = False

    def connect(self):
        app = App.get_running_app()
        if(app.facade=="start"):
            facade = FacadeClass()
            app.facade = facade

    def do_login(self, loginText, passwordText):
        self.ids['txt_login_email'].text = ""
        self.ids['txt_login_password'].text = ""

        app = App.get_running_app()
        output= app.facade.login(loginText,passwordText)
        if (not self.falid):
            if(output=="user" or output=="admin"):
                self.resetForm()
                app.roll = output

                app.username = loginText
                app.password = passwordText

                self.manager.transition = SlideTransition(direction="left")
                self.manager.current = 'home'

                app.config.read(app.get_application_config())
                app.config.write()
            else:
                if(output=="Error"):
                    a = self.num - 1
                    self.num = a
                    if a == 0:
                        attend="Wait 1 min before trying again."
                        self.falid = True
                        app.facade.send_Email_Hacked(loginText)
                        self.timer = datetime.datetime.now()
                        self.num = 3
                    else:
                        attend=(str(a) + " attempts left.")
                    self.ids['btn_info'].visible=True
                    self.ids['lbl_error'].text="Invalid login details. "+attend
                else:
                    self.ids['btn_info'].visible=True
                    self.ids['lbl_error'].text =output
        else:
            now = datetime.datetime.now()
            min = now.minute - self.timer.minute
            self.ids['lbl_error'].text = "Invalid login details. Wait " + str(min) + " min(s) before trying again."
            if min >= 1:
                self.falid = False

        self.resetForm()

    def resetForm(self):
        self.ids['txt_login_email'].text = ""
        self.ids['txt_login_password'].text = ""
        self.ids['btn_info'].visible = False
