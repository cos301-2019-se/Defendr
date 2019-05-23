#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# GUI module generated by PAGE version 4.23
#  in conjunction with Tcl version 8.6
#    May 23, 2019 02:45:59 PM SAST  platform: Linux

import sys
import databaseCon

try:
    import Tkinter as tk
except ImportError:
    import tkinter as tk

try:
    import ttk
    py3 = False
except ImportError:
    import tkinter.ttk as ttk
    py3 = True

try:
    from tkinter import messagebox
except:
    # Python 2
    import tkMessageBox as messagebox

import Logging_support
import Home_support
import Login_support
import os.path

def vp_start_gui():
    '''Starting point when module is the main routine.'''
    global val, w, root
    global prog_location
    prog_call = sys.argv[0]
    prog_location = os.path.split(prog_call)[0]
    root = tk.Tk()
    top = win_Logging (root)
    Logging_support.init(root, top)
    root.mainloop()

w = None
def create_win_Logging(root, *args, **kwargs):
    '''Starting point when module is imported by another program.'''
    global w, w_win, rt
    global prog_location
    prog_call = sys.argv[0]
    prog_location = os.path.split(prog_call)[0]
    rt = root
    w = tk.Toplevel (root)
    top = win_Logging (w)
    Logging_support.init(w, top, *args, **kwargs)
    return (w, top)

def destroy_win_Logging():
    global w
    w.destroy()
    w = None

class win_Logging:

    def search(self):
        db = databaseCon.connect()
        doc = databaseCon.findPackets(db, self.txtSearch.get())
        for x in doc:
            print(x)
            self.txtbLogs.insert(tk.END,("{} {}".format(x, '\n')))

    def back(self):
        destroy_win_Logging()
        Home_support.root.deiconify()

    def logout(self):
        msg = messagebox.askyesno("Logout", "Are you sure?");
        if (msg):
            destroy_win_Logging()
            Login_support.root.deiconify()

    def __init__(self, top=None):
        '''This class configures and populates the toplevel window.
           top is the toplevel containing window.'''
        _bgcolor = '#d9d9d9'  # X11 color: 'gray85'
        _fgcolor = '#000000'  # X11 color: 'black'
        _compcolor = '#d9d9d9' # X11 color: 'gray85'
        _ana1color = '#d9d9d9' # X11 color: 'gray85'
        _ana2color = '#ececec' # Closest X11 color: 'gray92'

        top.geometry("600x450+372+125")
        top.title("Logs")
        top.configure(highlightcolor="black")

        self.btnLogout = tk.Button(top)
        self.btnLogout.place(relx=0.85, rely=0.044, height=31, width=72)
        self.btnLogout.configure(text='''Logout''')
        self.btnLogout.configure(cursor="hand1")
        self.btnLogout.configure(command=lambda: self.logout())

        self.btnBack = tk.Button(top)
        self.btnBack.place(relx=0.017, rely=0.911, height=31, width=60)
        self.btnBack.configure(text='''Back''')
        self.btnBack.configure(cursor="hand1")
        self.btnBack.configure(command=lambda: self.back())

        self.img_Defendr = tk.Label(top)
        self.img_Defendr.place(relx=0.017, rely=0.022, height=131, width=329)
        photo_location = os.path.join(prog_location,"Images/Defendr.png")
        self._img0 = tk.PhotoImage(file=photo_location)
        self.img_Defendr.configure(image=self._img0)
        self.img_Defendr.configure(width=329)

        self.txtbLogs = tk.Text(top)
        self.txtbLogs.place(relx=0.017, rely=0.422, relheight=0.476, relwidth = 0.96)
        self.txtbLogs.configure(background="white")
        self.txtbLogs.configure(font="TkTextFont")
        self.txtbLogs.configure(selectbackground="#c4c4c4")
        self.txtbLogs.configure(width=576)
        self.txtbLogs.configure(wrap="word")

        self.txtSearch = tk.Entry(top)
        self.txtSearch.place(relx=0.55, rely=0.333,height=33, relwidth=0.277)
        self.txtSearch.configure(background="white")
        self.txtSearch.configure(font="TkFixedFont")
        self.txtSearch.configure(width=166)

        self.btnSearch = tk.Button(top)
        self.btnSearch.place(relx=0.867, rely=0.333, height=31, width=72)
        self.btnSearch.configure(text='''Search''')
        self.btnSearch.configure(cursor="hand1")
        self.btnSearch.configure(command=lambda: self.search())

if __name__ == '__main__':
    vp_start_gui()





