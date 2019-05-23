#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# GUI module generated by PAGE version 4.23
#  in conjunction with Tcl version 8.6
#    May 22, 2019 05:47:56 PM SAST  platform: Linux

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

import Login_support
from controller import controller
import os.path

def vp_start_gui():
    '''Starting point when module is the main routine.'''
    global val, w, root
    global prog_location
    prog_call = sys.argv[0]
    prog_location = os.path.split(prog_call)[0]
    root = tk.Tk()
    top = win_Login (root)
    Login_support.init(root, top)
    c = controller("../../Documents/Defendr/Defendr/src/")
    c.loadXdp()
    root.mainloop()

w = None
def create_win_Login(root, *args, **kwargs):
    '''Starting point when module is imported by another program.'''
    global w, w_win, rt
    global prog_location
    prog_call = sys.argv[0]
    prog_location = os.path.split(prog_call)[0]
    rt = root
    w = tk.Toplevel (root)
    top = win_Login (w)
    Login_support.init(w, top, *args, **kwargs)
    return (w, top)

def destroy_win_Login():
    global w
    w.destroy()
    w = None

class win_Login:

    def cancelLogin(self):
        msg = messagebox.askyesno("Exit", "Are you sure?");
        if(msg):
            exit()

    def loginUser(self):

        users = ["Jeandre", "Muhammed","Sisa","Christiaan","Ruslynn"]
        passwds = ["jPass1","mPass1","sPass1","cPass1","rPass1"]

        user = self.txtUser.get()
        passw = self.txtPass.get()

        for i in range(6):
            if(i < 5):
                if(user == users[i] and passw == passwds[i]):
                    messagebox.showinfo("Login Page", "Success")
                    self.txtUser.delete(0, 'end')
                    self.txtPass.delete(0, 'end')
                    Login_support.createMain()
                    break

                else:
                    if(user != users[i]):
                        continue

                    else:
                        if(passw !=  passwds[i]):
                            self.txtPass.delete(0, 'end')
                            messagebox.showwarning("Login Page", "Incorrect Username or Password")
                            break
            else:
                self.txtPass.delete(0, 'end')
                messagebox.showwarning("Login Page", "Incorrect Username or Password")
                break

    def __init__(self, top=None):
        '''This class configures and populates the toplevel window.
           top is the toplevel containing window.'''
        _bgcolor = '#d9d9d9'  # X11 color: 'gray85'
        _fgcolor = '#000000'  # X11 color: 'black'
        _compcolor = '#d9d9d9' # X11 color: 'gray85'
        _ana1color = '#d9d9d9' # X11 color: 'gray85'
        _ana2color = '#ececec' # Closest X11 color: 'gray92'

        top.geometry("510x222+395+150")
        top.title("Login")
        top.configure(highlightbackground="#1600d8")

        self.Frame1 = tk.Frame(top)
        self.Frame1.place(relx=0.118, rely=0.27, relheight=0.608, relwidth=0.775)

        self.Frame1.configure(relief='groove')
        self.Frame1.configure(borderwidth="2")
        self.Frame1.configure(relief="groove")
        self.Frame1.configure(width=395)

        self.lblUser = tk.Label(self.Frame1)
        self.lblUser.place(relx=0.051, rely=0.148, height=21, width=78)
        self.lblUser.configure(text='''Username:''')

        self.lblPass = tk.Label(self.Frame1)
        self.lblPass.place(relx=0.051, rely=0.444, height=21, width=73)
        self.lblPass.configure(text='''Password:''')

        self.txtUser = tk.Entry(self.Frame1)
        self.txtUser.place(relx=0.532, rely=0.148,height=23, relwidth=0.42)
        self.txtUser.configure(background="white")
        self.txtUser.configure(font="TkFixedFont")

        self.txtPass = tk.Entry(self.Frame1)
        self.txtPass.place(relx=0.532, rely=0.444,height=23, relwidth=0.42)
        self.txtPass.configure(background="white")
        self.txtPass.configure(font="TkFixedFont")
        self.txtPass.configure(show="*")

        self.btnLogin = tk.Button(self.Frame1)
        self.btnLogin.place(relx=0.684, rely=0.667, height=31, width=68)
        self.btnLogin.configure(text='''Login''')
        self.btnLogin.configure(cursor="hand1")
        self.btnLogin.configure(command=lambda: self.loginUser())

        self.btnCancel = tk.Button(self.Frame1)
        self.btnCancel.place(relx=0.127, rely=0.667, height=31, width=76)
        self.btnCancel.configure(text='''Cancel''')
        self.btnCancel.configure(cursor="hand1")
        self.btnCancel.configure(command=lambda: self.cancelLogin())

        self.menubar = tk.Menu(top,font="TkMenuFont",bg=_bgcolor,fg=_fgcolor)
        top.configure(menu = self.menubar)

        self.img_logo = tk.Label(top)
        self.img_logo.place(relx=0.02, rely=0.045, height=51, width=231)
        photo_location = os.path.join(prog_location,"Images/advance.png")
        self._img0 = tk.PhotoImage(file=photo_location)
        self.img_logo.configure(image=self._img0)
        self.img_logo.configure(width=231)

        self.img_defendr = tk.Label(top)
        self.img_defendr.place(relx=0.471, rely=0.045, height=51, width=261)
        self.img_defendr.configure(width=261)

if __name__ == '__main__':
    vp_start_gui()





