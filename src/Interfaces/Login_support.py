#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# Support module generated by PAGE version 4.23
#  in conjunction with Tcl version 8.6
#    May 22, 2019 05:47:47 PM SAST  platform: Linux

import sys
import Home

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

def init(top, gui, *args, **kwargs):
    global w, top_level, root
    w = gui
    top_level = top
    root = top

def destroy_window():
    # Function which closes the window.
    global top_level
    top_level.destroy()
    top_level = None

def createMain(roll):
    Home.create_win_Home(root,roll)
    root.withdraw()

if __name__ == '__main__':
    import Login
    Login.vp_start_gui()




