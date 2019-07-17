#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# GUI module generated by PAGE version 4.23
#  in conjunction with Tcl version 8.6
#    May 23, 2019 11:33:27 AM SAST  platform: Linux

import sys

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
    top = win_Home (root)
    Home_support.init(root, top)
    root.mainloop()

w = None

def create_win_Home(root, roll, *args, **kwargs):
    '''Starting point when module is imported by another program.'''
    global w, w_win, rt
    global prog_location
    global usertype
    usertype = roll
    prog_call = sys.argv[0]
    prog_location = os.path.split(prog_call)[0]
    rt = root
    w = tk.Toplevel (root)
    top = win_Home (w)
    Home_support.init(w, top, *args, **kwargs)
    return (w, top)

def destroy_win_Home():
    global w
    w.destroy()
    w = None

class win_Home:

    def logout(self):
        msg = messagebox.askyesno("Logout", "Are you sure?");
        if (msg):
            destroy_win_Home()
            Login_support.root.deiconify()

    def users(self):
        Home_support.createUsers()
        #if(usertype=="user"):
        #    messagebox.showinfo("Home Page", "You are log in as admin")
        #else:
        #    Home_support.createUsers()

    def __init__(self, top=None):
        '''This class configures and populates the toplevel window.
           top is the toplevel containing window.'''
        _bgcolor = '#d9d9d9'  # X11 color: 'gray85'
        _fgcolor = '#000000'  # X11 color: 'black'
        _compcolor = '#d9d9d9' # X11 color: 'gray85'
        _ana1color = '#d9d9d9' # X11 color: 'gray85'
        _ana2color = '#ececec' # Closest X11 color: 'gray92'

        top.geometry("593x335+376+135")
        top.title("Home Page")
        top.configure(highlightcolor="black")

        self.btnListIP = tk.Button(top)
        self.btnListIP.place(relx=0.034, rely=0.448, height=151, width=151)
        self.btnListIP.configure(activebackground="#f9f9f9")
        photo_location = os.path.join(prog_location,"Images/iplist.png")
        self._img0 = tk.PhotoImage(file=photo_location)
        self.btnListIP.configure(image=self._img0)
        self.btnListIP.configure(cursor="hand1")
        self.btnListIP.configure(command=lambda: Home_support.createIPList())

        self.btnLogging = tk.Button(top)
        self.btnLogging.place(relx=0.371, rely=0.448, height=151, width=151)
        self.btnLogging.configure(activebackground="#f9f9f9")
        photo_location = os.path.join(prog_location,"Images/logs.png")
        self._img1 = tk.PhotoImage(file=photo_location)
        self.btnLogging.configure(image=self._img1)
        self.btnLogging.configure(state='active')
        self.btnLogging.configure(width=151)
        self.btnLogging.configure(cursor="hand1")
        self.btnLogging.configure(command=lambda: Home_support.createLogs())

        self.btnMetrics = tk.Button(top)
        self.btnMetrics.place(relx=0.708, rely=0.448, height=151, width=151)
        self.btnMetrics.configure(activebackground="#f9f9f9")
        photo_location = os.path.join(prog_location,"Images/metrics.png")
        self._img2 = tk.PhotoImage(file=photo_location)
        self.btnMetrics.configure(image=self._img2)
        self.btnMetrics.configure(width=151)
        self.btnMetrics.configure(cursor="hand1")

        self.btnLogout = tk.Button(top)
        self.btnLogout.place(relx=0.843, rely=0.06, height=31, width=72)
        self.btnLogout.configure(activebackground="#f9f9f9")
        self.btnLogout.configure(text='''Logout''')
        self.btnLogout.configure(cursor="hand1")
        self.btnLogout.configure(command=lambda: self.logout())

        self.btnUsers = tk.Button(top)
        self.btnUsers.place(relx=0.843, rely=0.18, height=31, width=72)
        self.btnUsers.configure(activebackground="#f9f9f9")
        self.btnUsers.configure(text='''Users''')
        self.btnUsers.configure(cursor="hand1")
        self.btnUsers.configure(command=lambda: self.users())

        self.menubar = tk.Menu(top,font="TkMenuFont",bg=_bgcolor,fg=_fgcolor)
        top.configure(menu = self.menubar)

        self.img_Defendr = tk.Label(top)
        self.img_Defendr.place(relx=-0.051, rely=0.03, height=131, width=429)
        self.img_Defendr.configure(activebackground="#f9f9f9")
        photo_location = os.path.join(prog_location,"Images/Defendr.png")
        self._img3 = tk.PhotoImage(file=photo_location)
        self.img_Defendr.configure(image=self._img3)

        self.lbl_IP = tk.Label(top)
        self.lbl_IP.place(relx=0.118, rely=0.896, height=21, width=43)
        self.lbl_IP.configure(activebackground="#f9f9f9")
        self.lbl_IP.configure(text='''IP List''')

        self.lbl_IP_1 = tk.Label(top)
        self.lbl_IP_1.place(relx=0.438, rely=0.896, height=21, width=63)
        self.lbl_IP_1.configure(activebackground="#f9f9f9")
        self.lbl_IP_1.configure(text='''Logging''')

        self.lblIP_2 = tk.Label(top)
        self.lblIP_2.place(relx=0.776, rely=0.896, height=21, width=63)
        self.lblIP_2.configure(activebackground="#f9f9f9")
        self.lblIP_2.configure(text='''Metrics''')

if __name__ == '__main__':
    vp_start_gui()





