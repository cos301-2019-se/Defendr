from kivy.app import App
from kivy.uix.screenmanager import Screen
from MDTable import Table

class Logs_Window(Screen):
    table =""
    skipNr =0
    limit =100

    def add_table(self,id):
        ip =self.ids["log_search_text"].text
        app = App.get_running_app()
        if(not(self.table=="")):
            id.remove_widget(self.table)
        self.table=Table(table_content=app.facade.get_logs( ip,"ip_source","timestamp",-1,self.skipNr,self.limit))
        id.add_widget(self.table)

    def next_pages(self,id):
        self.skipNr = self.skipNr+self.limit
        self.add_table(id)

    def prev_pages(self,id):
        if(self.skipNr>0):
            self.skipNr = self.skipNr-self.limit
            self.add_table(id)