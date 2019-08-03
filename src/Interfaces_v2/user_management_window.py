from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
from kivy.uix.popup import Popup
from kivy.lang import Builder
from kivy.uix.button import Button

from MDTable import Table
import re

Builder.load_string('''

<Edit_User_Popup>:
    id:edit_popup
    size_hint: .4, .4
    auto_dismiss: False
    title: 'Hello world!!'
    Button:
        text: 'Click here to dismiss'
        on_press: edit_popup.dismiss()

<Delete_User_Popup>:
    id:delete_popup
    size_hint: .4, .4
    auto_dismiss: False
    title: 'Warining'
    GridLayout:
        cols:3
        Label
        GridLayout:
            rows:3
            Label
            GridLayout:
                rows: 2
                MDLabel:
                    theme_text_color: 'Primary'
                    text: 'Are you sure you want delete ?'
                    font_size: 14
                    halign: 'center'
                BoxLayout:
                    orientation: 'horizontal'
                    spacing: '5dp'
                    Button:
                        text: 'No'
                        on_press: delete_popup.dismiss()
                    Button:
                        text: 'Yes'
                        on_press: root.confirm_delete()
            Label
        Label

''')

import databaseCon

class Edit_User_Popup(Popup):
    pass

class Delete_User_Popup(Popup):
    def confirm_delete(self):
        self.dismiss()
    pass


class User_Management_Window(Screen):

    def add_table(self,id,list):
        db = databaseCon.connect()
        data = databaseCon.print_user(db)
        id.add_widget(Table(table_content=data))

    def add_user(self,id,name,surename,email,password,rePassword):
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
                                print("Added")
                            else:
                                print("Password does not macth")

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

    def edit_user(self,user_email_to_modify):
        popup = Edit_User_Popup()
        popup.open()

    def remove_user(self, user_email_to_delete):
        popup = Delete_User_Popup()
        popup.open()