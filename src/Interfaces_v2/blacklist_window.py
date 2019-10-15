from kivy.app import App
from kivy.uix.screenmanager import Screen
from MDTable import Table
from controller import controller

class Blacklist_Window(Screen):
    # Loads the xdp program by calling the controller.
    xdp =  controller("../")
    table =""

    # Loads the IP table
    def add_table(self,id):
        app = App.get_running_app()
        if (not (self.table == "")):
            id.remove_widget(self.table)
        self.table = Table(table_content=app.facade.list_black_ip(""))
        id.add_widget(self.table)

    # Add IP to blacklist.
    def add_IP(self,ip_addr):
        app = App.get_running_app()
        check = app.facade.add_black_ip(ip_addr)
        if(check!="IP is black listed."):
            self.ids['lbl_error'].text = check
        else:
            self.ids['lbl_error'].text = ""
        self.ids['txt_ip_addr'].text = ""

    # Removes IP from list.
    def remove_IP(self, ip_addr):
        app = App.get_running_app()
        check=app.facade.remove_black_ip(ip_addr)
        if(check!="IP is removed."):
            self.ids['lbl_error'].text = check
        else:
            self.ids['lbl_error'].text = ""
        self.ids['txt_ip_addr'].text = ""
