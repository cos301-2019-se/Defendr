#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk as gtk

gi.require_version('WebKit2', '4.0')
from gi.repository import WebKit2 as webkit

win = gtk.Window()
win.connect('destroy', lambda w: gtk.main_quit())

box1 = gtk.VBox()
win.add(box1)

scroller = gtk.ScrolledWindow()
box1.pack_start(scroller)

web = webkit.webView()
scroller.add(web)

web.open("http://localhost:3000/d/L7frhkNWk/defendr-system-load?orgId=1");

win.show_all()

gtk.main()
