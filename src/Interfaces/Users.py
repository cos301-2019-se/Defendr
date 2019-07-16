#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# GUI module generated by PAGE version 4.24
#  in conjunction with Tcl version 8.6
#    Jul 03, 2019 03:49:59 PM SAST  platform: Linux

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

import Users_support
import Home_support
import databaseCon
import os.path

def vp_start_gui():
    '''Starting point when module is the main routine.'''
    global val, w, root
    root = tk.Tk()
    top = managementwindow (root)
    Users_support.init(root, top)
    root.mainloop()

w = None
def create_managementwindow(root, *args, **kwargs):
    '''Starting point when module is imported by another program.'''
    global w, w_win, rt
    rt = root
    w = tk.Toplevel (root)
    top = managementwindow (w)
    Users_support.init(w, top, *args, **kwargs)
    return (w, top)

def destroy_managementwindow():
    global w
    w.destroy()
    w = None

class managementwindow:
    def addUsers(self,db):
        name=self.AddNametxt.get()
        password=self.Psdtxt.get()
        if(self.Repsdtxt.get()!=password):
            messagebox.showwarning("Users Page", "Plaese check the password.")
        else:
            msg = messagebox.askyesno("Roll", "Are "+name+" an admin?")
            roll="user"
            if(msg):
                roll="admin"
            answer=databaseCon.makeNewUser(db,name,password,roll)
            messagebox.showinfo("Users mangement",answer)

    def removeUsers(self,db):
        name=self.RemoveNametxt.get()
        msg = messagebox.askyesno("Remove users", "Are  sure you want to remove "+name+" ?")
        if(msg):
            answer=databaseCon.remove(db,name)
            messagebox.showinfo("Users mangement",answer)
            self.RemoveNametxt.insert(tk.END, "")

    def back(self):
        destroy_managementwindow()
        Home_support.root.deiconify()

    def refeshed(self,db):
        line = databaseCon.printUsers(db)
        self.Userstxt.delete(1.0, tk.END)
        self.Userstxt.insert(tk.END, line)
        line=databaseCon.printUsers(db)
        lineArray = line.split('\n')
        for x in lineArray:
            print(x)
            self.Userstxt.insert(tk.END, x)

    def __init__(self, top=None):
        db = databaseCon.connect()
        '''This class configures and populates the toplevel window.
           top is the toplevel containing window.'''
        _bgcolor = '#d9d9d9'  # X11 color: 'gray85'
        _fgcolor = '#000000'  # X11 color: 'black'
        _compcolor = '#d9d9d9' # X11 color: 'gray85'
        _ana1color = '#d9d9d9' # X11 color: 'gray85'
        _ana2color = '#ececec' # Closest X11 color: 'gray92'
        font11 = "-family {DejaVu Sans} -size 14 -weight bold -slant "  \
            "roman -underline 0 -overstrike 0"
        font13 = "-family {DejaVu Sans} -size 12 -weight normal -slant"  \
            " roman -underline 0 -overstrike 0"
        font9 = "-family {DejaVu Sans} -size 18 -weight bold -slant "  \
            "roman -underline 0 -overstrike 0"

        top.geometry("631x371+378+132")
        top.geometry("531x371+378+132")
        top.title("Users management")

        self.UsersManagementLBL = tk.Label(top)
        self.UsersManagementLBL.place(relx=0.358, rely=0.054, height=33
                , width=262)
        self.UsersManagementLBL.configure(font=font9)
        self.UsersManagementLBL.configure(text='''Users Management''')

        self.AddUsersLbl = tk.Label(top)
        self.AddUsersLbl.place(relx=0.094, rely=0.162, height=27, width=117)
        self.AddUsersLbl.configure(font=font11)
        self.AddUsersLbl.configure(text='''Add Users:''')

        self.NameLbl = tk.Label(top)
        self.NameLbl.place(relx=0.038, rely=0.27, height=23, width=57)
        self.NameLbl.configure(font=font13)
        self.NameLbl.configure(text='''Name:''')

        self.PasswordLbl = tk.Label(top)
        self.PasswordLbl.place(relx=0.038, rely=0.35, height=23, width=85)
        self.PasswordLbl.configure(font=font13)
        self.PasswordLbl.configure(text='''Password:''')

        self.reenterpsdLbl = tk.Label(top)
        self.reenterpsdLbl.place(relx=0.038, rely=0.431, height=23, width=160)
        self.reenterpsdLbl.configure(font=font13)
        self.reenterpsdLbl.configure(text='''Re-enter password:''')

        self.RemoveUsersLbl = tk.Label(top)
        self.RemoveUsersLbl.place(relx=0.075, rely=0.593, height=27, width=161)
        self.RemoveUsersLbl.configure(font=font11)
        self.RemoveUsersLbl.configure(text='''Remove Users:''')

        self.removeNameLbl = tk.Label(top)
        self.removeNameLbl.place(relx=0.038, rely=0.701, height=23, width=57)
        self.removeNameLbl.configure(font=font13)
        self.removeNameLbl.configure(text='''Name:''')

        self.UsersLbl = tk.Label(top)
        self.UsersLbl.place(relx=0.716, rely=0.162, height=27, width=70)
        self.UsersLbl.configure(font=font11)
        self.UsersLbl.configure(text='''Users:''')

        self.AddUserBtn = tk.Button(top)
        self.AddUserBtn.place(relx=0.038, rely=0.836, height=33, width=99)
        self.AddUserBtn.configure(font=font13)
        self.AddUserBtn.configure(text='''Add''')
        self.AddUserBtn.configure(width=99)
        self.AddUserBtn.configure(command=lambda: self.addUsers(db))

        self.removeUserBtn = tk.Button(top)
        self.removeUserBtn.place(relx=0.253, rely=0.836, height=33, width=94)
        self.removeUserBtn.configure(font=font13)
        self.removeUserBtn.configure(text='''Remove''')
        self.removeUserBtn.configure(command=lambda: self.removeUsers(db))

        self.ReloadBtn = tk.Button(top)
        self.ReloadBtn.place(relx=0.621, rely=0.836, height=33, width=83)
        self.ReloadBtn.configure(font=font13)
        self.ReloadBtn.configure(text='''Reload''')
        self.ReloadBtn.configure(command=lambda: self.refeshed(db))

        self.BackBtn = tk.Button(top)
        self.BackBtn.place(relx=0.806, rely=0.836, height=33, width=83)
        self.BackBtn.configure(font=font13)
        self.BackBtn.configure(text='''Back''')
        self.BackBtn.configure(command=lambda: self.back())

        self.Repsdtxt = tk.Entry(top)
        self.Repsdtxt.place(relx=0.358, rely=0.431,height=23, relwidth=0.218)
        self.Repsdtxt.configure(background="white")
        self.Repsdtxt.configure(font="TkFixedFont")
        self.Repsdtxt.configure(width=116)

        self.Userstxt = tk.Text(top)
        self.Userstxt = tk.Entry(top)
        self.Userstxt.place(relx=0.621, rely=0.243,height=213, relwidth=0.331)
        self.Userstxt.configure(background="white")
        self.Userstxt.configure(font="TkFixedFont")
        self.Userstxt.configure(width=176)

        self.Psdtxt = tk.Entry(top)
        self.Psdtxt.place(relx=0.358, rely=0.35,height=23, relwidth=0.218)
        self.Psdtxt.configure(background="white")
        self.Psdtxt.configure(font="TkFixedFont")
        self.Psdtxt.configure(width=116)

        self.AddNametxt = tk.Entry(top)
        self.AddNametxt.place(relx=0.358, rely=0.27,height=23, relwidth=0.218)
        self.AddNametxt.configure(background="white")
        self.AddNametxt.configure(font="TkFixedFont")
        self.AddNametxt.configure(width=116)

        self.RemoveNametxt = tk.Entry(top)
        self.RemoveNametxt.place(relx=0.358, rely=0.701,height=23, relwidth=0.218)
        self.RemoveNametxt.configure(background="white")
        self.RemoveNametxt.configure(font="TkFixedFont")
        self.RemoveNametxt.configure(width=116)

if __name__ == '__main__':
    vp_start_gui()





