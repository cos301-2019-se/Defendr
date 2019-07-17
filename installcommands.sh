#! /bin/sh
sudo apt update
sudo apt install clang llvm libelf-dev
sudo apt install linux-tools-$(uname -r)
sudo apt install linux-headers-$(uname -r)
sudo apt install bcc bpfcc-tools
sudo apt install python3
sudo apt install python3-pip
sudo apt install python3-tk
sudo pip3 install pymongo
sudo pip3 install dnspython
sudo apt install gradle
sudo apt install net-tools
sudo apt install apache2
sudo apt-get install libtool
sudo apt-get install autoconf
cd src/IP2Location-C-Library-master
sudo autoreconf -i -v --force
sudo ./configure
sudo make
sudo make install
cd data
sudo perl ip-country.pl
cd ../../../
cd src/Interfaces/
python3 Login.py
