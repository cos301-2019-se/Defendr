from kivy.uix.screenmanager import Screen
from Facade import FacadeClass

class Register(Screen):
    def do_go_to_login(self,name,surname,email,password,confirm_pass):
        facade = FacadeClass()
        output=facade.register(name,surname,email,password,confirm_pass)
        if(output=="Add"):
            self.resetForm()
        else:
            self.ids['lbl_error'].text = output
            self.ids['btn_info'].visible = True

    def resetForm(self):
        self.ids['name'].text = ""
        self.ids['surname'].text = ""
        self.ids['email'].text = ""
        self.ids['password'].text = ""
        self.ids['confirm_pass'].text = ""
        self.ids['lbl_error'].text = ""
        self.ids['btn_info'].visible = False