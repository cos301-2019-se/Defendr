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
    size_hint: .6, .6
    auto_dismiss: False
    title: 'Edit user account'
    GridLayout:
        cols:3
        Label:
            size_hint_x: 0.1
        GridLayout:
            size_hint_x: 0.9
            spacing: '5dp'
            rows: 12
            row_force_default: 1
            row_default_height: '35dp'
            BoxLayout:
                orientation: 'horizontal'
                size_hint_x: 0.7
                MDIconButton:
                    id: btn_info
                    visible: False
                    opacity: 1 if self.visible else 0
                    disabled: not self.visible
                    icon: 'info'
                    size_hint_x: 0.2
                MDLabel:
                    id: lbl_error
                    theme_text_color: 'Primary'
                    size_hint_x: 0.8
                    color: 1,0,0,1
                    text: ''
                    font_size: 14
                    halign: 'left'
                
            BoxLayout:
                orientation: 'horizontal'
                spacing: '15dp'                
                MDLabel:
                    text: "Name:"
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.4
                TextInput:
                    id: edit_user_name
                    multiline:False
                    font_size: 18
                    size_hint_x: 0.6
            BoxLayout:
                orientation: 'horizontal'
                spacing: '15dp'
                MDLabel:
                    text: "Surname:"
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.4
                TextInput:
                    id: edit_user_surname
                    multiline:False
                    font_size: 18
                    size_hint_x: 0.6
            BoxLayout:
                orientation: 'horizontal'
                spacing: '15dp'
                MDLabel:
                    text: "Email:"
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.4
                TextInput:
                    id: edit_user_email
                    multiline:False
                    font_size: 18
                    size_hint_x: 0.6
            BoxLayout:
                orientation: 'horizontal'
                spacing: '15dp'
                MDLabel:
                    text: "Password:"
                    password: True
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.4
                TextInput:
                    id: edit_user_password
                    multiline:False
                    font_size: 18
                    size_hint_x: 0.6
            BoxLayout:
                orientation: 'horizontal'
                spacing: '15dp'
                MDLabel:
                    text: "Confirm Password:"
                    password: True
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.4
                TextInput:
                    id: edit_user_password_confirm
                    multiline:False
                    font_size: 18
                    size_hint_x: 0.6
            BoxLayout:
                orientation: 'horizontal'
                MDLabel:
                    text: "Account type:"
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.3
                MDLabel:
                    size_hint_x: 0.22
                ToggleButton:
                    id: admin_button
                    text: 'Admin'
                    group: 'user_type'
                    size_hint_x: 0.24
                    on_release:
                        edit_email_notification_check.visible = True
                        edit_email_notification_msg.visible = False
                ToggleButton:
                    id: user_button
                    text: 'User'
                    state: 'down'
                    group: 'user_type'
                    size_hint_x: 0.24
                    on_release:
                        edit_email_notification_check.visible = False
                        edit_email_notification_msg.visible = True
            BoxLayout:
                orientation: 'horizontal'
                spacing: '2dp'
                MDLabel:
                    text: "Enable email notifications:"
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.65
                MDLabel:
                    id: edit_email_notification_msg
                    text: "(unavailable)"
                    visible: True
                    opacity: 1 if self.visible else 0
                    font_size: 18
                    halign: 'left'
                    size_hint_x: 0.25
                CheckBox:
                    id : edit_email_notification_check
                    visible: False
                    opacity: 1 if self.visible else 0
                    disabled: not self.visible
                    size_hint_x: 0.1
    
            BoxLayout:
                orientation: 'horizontal'
                spacing: '20dp'
                MDLabel:
                    size_hint_x: 0.4
                Button:
                    font_size: 18
                    text: 'Cancel'
                    size_hint_x: 0.3
                    on_press: root.dismiss()
                Button:
                    font_size: 18
                    text: 'Confirm'
                    size_hint_x: 0.3
                    on_press: root.Confirm()
        Label:
            size_hint_x: 0.2
            
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
    details=[]
    def start(self):
        app = App.get_running_app()
        self.details = app.facade.get_user_detail(app.email)
        if(not(self.details[0]=="notFond")):
            self.ids['edit_user_name'].text = self.details[0]
            self.ids['edit_user_surname'].text = self.details[1]
            self.ids['edit_user_email'].text = self.details[2]
            if(self.details[3]=="admin"):
                self.ids['edit_email_notification_check'].visible = True
                self.ids['edit_email_notification_msg'].visible = False
                self.ids['admin_button'].state='down'
                self.ids['user_button'].state='normal'
                if(self.details[4]=="yes"):
                    self.ids['edit_email_notification_check'].active=True
                else:
                    self.ids['edit_email_notification_check'].active=False
            else:
                self.ids['edit_email_notification_check'].visible = False
                self.ids['edit_email_notification_msg'].visible = True
                self.ids['admin_button'].state='normal'
                self.ids['user_button'].state='down'
        else:
            self.ids['edit_user_email'].text = self.details[2]
            self.ids['lbl_error'].text = "User not fonded."
            self.ids['btn_info'].visible = True


    def Confirm(self):
        app = App.get_running_app()
        output=""
        if(not(self.details[0]==self.ids['edit_user_name'].text)):
            output=app.facade.update_user_detail(self.details[2],"name",self.ids['edit_user_name'].text)
        if (not(self.details[1] == self.ids['edit_user_surname'].text)):
            output=app.facade.update_user_detail(self.details[2], "surname", self.ids['edit_user_surname'].text)
        if (not(self.details[2] == self.ids['edit_user_email'].text)):
            output=app.facade.update_user_detail(self.details[2], "email", self.ids['edit_user_email'].text)
        if(not(self.ids['edit_user_password'].text=="")):
            if( not(self.ids['edit_user_password'].text==self.ids["edit_user_password_confirm"].text)):
                output="Password needs to macth"
            else:
                output=app.facade.update_user_detail(self.details[2], "password", self.ids['edit_user_password'].text)
        if(self.details[3]=="admin" and self.ids['edit_email_notification_check'].visible == False):
            output=app.facade.update_user_detail(self.details[2],"roll","user")
            output=app.facade.update_user_detail(self.details[2],"sendEmail","no")
        if(self.ids['edit_email_notification_check'].visible == True):
            if(self.details[3]=="user"):
                output=app.facade.update_user_detail(self.details[2],"roll","admin")
            if(self.details[4]=="yes" and self.ids['edit_email_notification_check'].active == False):
                output=app.facade.update_user_detail(self.details[2], "sendEmail", "no")
            else:
                if (self.details[4] == "no" and self.ids['edit_email_notification_check'].active):
                    output=app.facade.update_user_detail(self.details[2], "sendEmail", "yes")
        if (output == "Add"):
            self.dismiss()
        else:
            if(output == ""):
                self.ids['lbl_error'].text = "Not chancges has be maded."
            else:
                self.ids['lbl_error'].text = output
            self.ids['btn_info'].visible = True
    pass


class Delete_User_Popup(Popup):
    def confirm_delete(self):
        app = App.get_running_app()
        app.facade.remove_user(app.email)
        self.dismiss()
    pass


class User_Management_Window(Screen):
    table=""

    def add_table(self,id):
        app = App.get_running_app()
        if (not (self.table == "")):
            id.remove_widget(self.table)
        self.table = Table(table_content=app.facade.list_user(""))
        id.add_widget(self.table)

    def add_user(self,id,name,surename,email,password,rePassword, admin):
        app= App.get_running_app()
        output=app.facade.add_user(name, surename,email, password, rePassword, admin, self.ids['email_notification_check'].active)
        if(output=="Add"):
            self.reset_add()
        else:
            self.ids['lbl_error'].text = output
            self.ids['btn_info'].visible = True

    def edit_user(self,user_email_to_modify):
        app = App.get_running_app()
        app.email = user_email_to_modify
        popup = Edit_User_Popup()
        popup.start()
        popup.open()
        self.reset_other()

    def remove_user(self, user_email_to_delete):
        app = App.get_running_app()
        if(app.facade.check_email(user_email_to_delete)):
            app.email=user_email_to_delete
            popup = Delete_User_Popup()
            popup.open()
        self.reset_other()

    def verify_user(self, user_email_to_verify):
        app = App.get_running_app()
        app.facade.verify_user(user_email_to_verify)
        self.reset_other()

    def reset_add(self):
        self.ids['user_name'].text = ""
        self.ids['user_surname'].text = ""
        self.ids['user_email'].text = ""
        self.ids['user_password'].text = ""
        self.ids['user_password_confirm'].text = ""
        self.ids['lbl_error'].text = ""
        self.ids['btn_info'].visible = False

    def reset_other(self):
        self.ids['user_email_to_modify'].text=""
