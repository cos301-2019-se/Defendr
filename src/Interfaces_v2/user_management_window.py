from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
from kivy.uix.popup import Popup
from kivy.lang import Builder
from kivy.uix.button import Button

from MDTable import Table

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


class Edit_User_Popup(Popup):
    pass

class Delete_User_Popup(Popup):
    def confirm_delete(self):
        self.dismiss()
    pass


class User_Management_Window(Screen):

    def add_table(self,id,list):
        id.add_widget(Table(table_content=list))

    def edit_user(self,user_email_to_modify):
        popup = Edit_User_Popup()
        popup.open()

    def remove_user(self, user_email_to_delete):
        popup = Delete_User_Popup()
        popup.open()