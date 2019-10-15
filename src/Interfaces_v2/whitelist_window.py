from kivy.app import App
from kivy.uix.screenmanager import Screen
from MDTable import Table

class Whitelist_Window(Screen):
    table=""

    def add_table(self,id):
        app = App.get_running_app()
        if (not (self.table == "")):
            id.remove_widget(self.table)
        self.table = Table(table_content=app.facade.list_white_ip(""))
        id.add_widget(self.table)

    def add_IP(self,ip_addr):
        app = App.get_running_app()
        check =app.facade.add_white_ip(ip_addr)
        if (check != "IP is white listed."):
            self.ids['lbl_error'].text = check
        else:
            self.ids['lbl_error'].text = ""
        self.ids['txt_ip_addr'].text = ""

    def remove_IP(self, ip_addr):
        app = App.get_running_app()
        check =app.facade.remove_white_ip(ip_addr)
        if (check != "IP is removed."):
            self.ids['lbl_error'].text = check
        else:
            self.ids['lbl_error'].text = ""
        self.ids['txt_ip_addr'].text = ""
