from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
import re
import databaseCon
import emailSender

class Register(Screen):
    def do_go_to_login(self,name,surname,email,password,confirm_pass):
        db = databaseCon.connect()
        if(not databaseCon.print_user(db)):
            check=self.add_user(db,name,surname,email,password,confirm_pass,"admin")
        else:
            check = self.add_user(db, name, surname, email, password, confirm_pass, "new")
        self.resetForm()
        if(check):
            smtp = emailSender.connectToSMTPserver()
            emailSender.emailAddNewUser(db,smtp,name,email)
            self.manager.transition = SlideTransition(direction="left")
            self.manager.current = 'login'
            self.manager.get_screen('login').resetForm()
    
    def resetForm(self):
        self.ids['name'].text = ""
        self.ids['surname'].text = ""
        self.ids['email'].text = ""
        self.ids['password'].text = ""
        self.ids['confirm_pass'].text = ""

    def add_user(self,db,name,surename,email,password,rePassword,roll):
        if(name==""):
            print("Name must not be enter")
        else:
            if(surename==""):
                print("Surename must not be enter")
            else:
                if(self.checkEmail(email)):
                    if(self.checkPassword(password)):
                        if(rePassword==""):
                            print("Re-enter password")
                        else:
                            if(password==rePassword):
                                if(roll=="admin"):
                                    output = databaseCon.make_new_user(db,name,surename,password,roll,email,"yes")
                                else:
                                    output = databaseCon.make_new_user(db,name,surename,password,roll,email,"no")
                                if(not output):
                                    print("Falid")
                                    return False
                                print("Added")
                                return True
                            else:
                                print("Password does not macth")
        return False

    # check if the email is correct
    def checkEmail(self, email):
        mail = email
        if(mail==""):
            print("Enter an email")
            return False
        check = re.search(
            "([a-z]|[A-Z]|[0-9])+\@([a-z]|[A-Z]|[0-9])+((\.(([A-Z]|[a-z]|[0-9])+))|(\.(([A-Z]|[a-z]|[0-9])+)){2})$",
            mail)
        if (check):
            return True
        else:
            print("Invalid email.")
            return False

        # check if the password is correct

    def checkPassword(self, psw):
        password = psw
        if(password==""):
            print("Enter a password")
            return False
        number = re.findall("[0-9]", password)
        if (not (number)):
            print("Your password needs a number.")
            return False
        caps = re.findall("[A-Z]", password)
        if (not (caps)):
            print("Your password needs a uppercase chatter.")
            return False
        lower = re.findall("[a-z]", password)
        if (not (lower)):
            print("Users mangement", "Your password needs a lowercase chatter.")
            return False
        symbols = re.findall("[!,@,#,$,%,^,&,*,.,?]", password)
        if (not (symbols)):
            print( "Your password needs a symbol.")
            return False
        return True
        