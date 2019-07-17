#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# GUI module generated by PAGE version 4.24
#  in conjunction with Tcl version 8.6
#    Jul 15, 2019 11:25:16 AM SAST  platform: Linux

import sys
import re
import databaseCon

try:
    import Tkinter as tk
except ImportError:
    import tkinter as tk

try:
    from tkinter import messagebox
except:
    # Python 2
    import tkMessageBox as messagebox

try:
    import ttk
    py3 = False
except ImportError:
    import tkinter.ttk as ttk
    py3 = True

import register_support
import Login_support

def vp_start_gui():
    '''Starting point when module is the main routine.'''
    global val, w, root
    root = tk.Tk()
    top = register_window (root)
    register_support.init(root, top)
    root.mainloop()

w = None
def create_register_window(root, *args, **kwargs):
    '''Starting point when module is imported by another program.'''
    global w, w_win, rt
    rt = root
    w = tk.Toplevel (root)
    top = register_window (w)
    register_support.init(w, top, *args, **kwargs)
    return (w, top)

def destroy_register_window():
    global w
    w.destroy()
    w = None

class register_window:
    #switch window to the login window
    def login(self):
        register_support.createLogin()

    #closeing the window
    def cancelRegister(self):
        msg = messagebox.askyesno("Exit", "Are you sure?");
        if(msg):
            exit()

    #add the a new user
    def adduser(self):
        name=self.ent_name.get()
        surename = self.ent_Lastname.get()
        email = self.Ent_email.get()
        password = self.Ent_password.get()
        reentered = self.ent_reenter.get()
        if(name==' '):
            messagebox.showwarning("Name","Please enter a name!")
        else:
            if(surename==' '):
                messagebox.showwarning("Surname","Please enter a surname!")
            else:
                if(password!=reentered):
                    messagebox.showwarning("Password","Passwords must match!")
                    self.Ent_password.delete(0, 'end')
                    self.ent_reenter.delete(0, 'end')
                else:
                    if(self.checkPassword(password)):
                        if(self.checkEmail(email)):
                            db = databaseCon.connect()
                            roll="user"
                            if(not databaseCon.checkUsers(db)):
                                roll="admin"
                            answer=databaseCon.makeNewUser(db, name, surename, password, roll, email)
                            if(answer):
                                messagebox.showinfo("Register",name+" Successfully added")
                                self.Ent_password.delete(0, 'end')
                                self.ent_reenter.delete(0, 'end')
                                register_support.createMain(roll)
                            else:
                                messagebox.showwarning("Register","Email already exists")

    #check if the email is correct
    def checkEmail(self, email):
        mail=email
        check = re.search("([a-z]|[A-Z]|[0-9])+\@([a-z]|[A-Z]|[0-9])+((\.(([A-Z]|[a-z]|[0-9])+))+)$",mail)
        if(check):
            return True
        else:
            messagebox.showwarning("Email","Invalid email.")
            self.Ent_email.delete(0, 'end')
            return False

    #check if the email is correct
    def checkPassword(self, psw):
        password=psw
        number = re.findall("[0-9]", password)
        if(not(number)):
            messagebox.showwarning("Password","Your password needs a number.")
            self.Ent_password.delete(0, 'end')
            self.ent_reenter.delete(0, 'end')
            return False
        caps = re.findall("[A-Z]", password)
        if (not (caps)):
            messagebox.showwarning("Password", "Your password needs a uppercase character.")
            self.Ent_password.delete(0, 'end')
            self.ent_reenter.delete(0, 'end')
            return False
        lower = re.findall("[a-z]", password)
        if (not (lower)):
            messagebox.showwarning("Password", "Your password needs a lowercase character.")
            self.Ent_password.delete(0, 'end')
            self.ent_reenter.delete(0, 'end')
            return False
        symbols = re.findall("[!,@,#,$,%,^,&,*,.,?]", password)
        if (not (symbols)):
            messagebox.showwarning("Password", "Your password needs a symbol.")
            self.Ent_password.delete(0, 'end')
            self.ent_reenter.delete(0, 'end')
            return False
        return True

    def __init__(self, top=None):
        '''This class configures and populates the toplevel window.
           top is the toplevel containing window.'''
        _bgcolor = '#d9d9d9'  # X11 color: 'gray85'
        _fgcolor = '#000000'  # X11 color: 'black'
        _compcolor = '#d9d9d9' # X11 color: 'gray85'
        _ana1color = '#d9d9d9' # X11 color: 'gray85'
        _ana2color = '#ececec' # Closest X11 color: 'gray92'
        font11 = "-family {DejaVu Sans} -size 15 -weight normal -slant"  \
            " roman -underline 0 -overstrike 0"
        font14 = "-family {DejaVu Sans} -size 14 -weight normal -slant"  \
            " roman -underline 0 -overstrike 0"
        font9 = "-family {DejaVu Sans} -size 20 -weight bold -slant "  \
            "roman -underline 0 -overstrike 0"

        top.geometry("458x331+213+46")
        top.title("Register")

        self.lbl_Header1 = tk.Label(top)
        self.lbl_Header1.place(relx=0.393, rely=0.06, height=36, width=131)
        self.lbl_Header1.configure(font=font9)
        self.lbl_Header1.configure(text="Register")

        self.btn_register = tk.Button(top)
        self.btn_register.place(relx=0.415, rely=0.816, height=38, width=111)
        self.btn_register.configure(font=font11)
        self.btn_register.configure(text="Register")
        self.btn_register.configure(command=lambda: self.adduser())

        self.btn_Singin = tk.Button(top)
        self.btn_Singin.place(relx=0.098, rely=0.816, height=38, width=89)
        self.btn_Singin.configure(font=font11)
        self.btn_Singin.configure(text="Log In")
        self.btn_Singin.configure(command=lambda: self.login())

        self.btn_close = tk.Button(top)
        self.btn_close.place(relx=0.742, rely=0.801, height=38, width=82)
        self.btn_close.configure(font=font11)
        self.btn_close.configure(text="Close")
        self.btn_close.configure(command=lambda: self.cancelRegister())

        self.lbl_name = tk.Label(top)
        self.lbl_name.place(relx=0.109, rely=0.272, height=28, width=69)
        self.lbl_name.configure(font=font11)
        self.lbl_name.configure(text="Name:")

        self.lbl_lastName = tk.Label(top)
        self.lbl_lastName.place(relx=0.109, rely=0.363, height=27, width=106)
        self.lbl_lastName.configure(font=font11)
        self.lbl_lastName.configure(text="Surname:")

        self.ent_Lastname = tk.Entry(top)
        self.ent_Lastname.place(relx=0.568, rely=0.378, height=23, relwidth=0.362)
        self.ent_Lastname.configure(background="white")
        self.ent_Lastname.configure(font="TkFixedFont")

        self.ent_name = tk.Entry(top)
        self.ent_name.place(relx=0.568, rely=0.272,height=23, relwidth=0.362)
        self.ent_name.configure(background="white")
        self.ent_name.configure(font="TkFixedFont")

        self.Lbl_email = tk.Label(top)
        self.Lbl_email.place(relx=0.109, rely=0.453, height=28, width=67)
        self.Lbl_email.configure(font=font11)
        self.Lbl_email.configure(text="Email:")

        self.Ent_email = tk.Entry(top)
        self.Ent_email.place(relx=0.568, rely=0.468,height=23, relwidth=0.362)
        self.Ent_email.configure(background="white")
        self.Ent_email.configure(font="TkFixedFont")

        self.Lbl_password = tk.Label(top)
        self.Lbl_password.place(relx=0.109, rely=0.544, height=28, width=104)
        self.Lbl_password.configure(font=font11)
        self.Lbl_password.configure(text="Password:")

        self.Ent_password = tk.Entry(top)
        self.Ent_password.place(relx=0.568, rely=0.574, height=23
                , relwidth=0.362)
        self.Ent_password.configure(background="white")
        self.Ent_password.configure(font="TkFixedFont")
        self.Ent_password.configure(show="*")

        self.Lbl_reenter = tk.Label(top)
        self.Lbl_reenter.place(relx=0.109, rely=0.665, height=28, width=196)
        self.Lbl_reenter.configure(font=font11)
        self.Lbl_reenter.configure(text="Re-enter Password:")

        self.ent_reenter = tk.Entry(top)
        self.ent_reenter.place(relx=0.568, rely=0.665,height=23, relwidth=0.362)
        self.ent_reenter.configure(background="white")
        self.ent_reenter.configure(font="TkFixedFont")
        self.ent_reenter.configure(show="*")

if __name__ == '__main__':
    vp_start_gui()





