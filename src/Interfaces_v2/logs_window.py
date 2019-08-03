from kivy.app import App
from kivy.uix.screenmanager import Screen, SlideTransition
from cefpython3 import cefpython as cef
import platform
import sys
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.recycleview.views import RecycleDataViewBehavior
from kivy.uix.button import Button
from kivy.properties import BooleanProperty, ListProperty, StringProperty, ObjectProperty
from kivy.uix.recyclegridlayout import RecycleGridLayout
from kivy.uix.behaviors import FocusBehavior
from kivy.uix.recycleview.layout import LayoutSelectionBehavior
from kivy.uix.popup import Popup
import databaseCon
from MDTable import Table

class Logs_Window(Screen):

    def add_table(self,id,list):
        db = databaseCon.connect()
        ip =self.ids["log_search_text"].text
        list = databaseCon.find_packets(db,ip)
        id.add_widget(Table(table_content=list))

