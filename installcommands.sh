#! /bin/sh
cd src/mongoDriver
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo apt-get install libmongoc-1.0-0
sudo apt-get install libbson-1.0
sudo apt-get install cmake libssl-dev libsasl2-dev
sudo apt-get install pkg-config
sudo apt-get install openssl
tar xzf mongo-c-driver*tar.gz
cd mongo-c-driver*0
mkdir cmake-build
cd cmake-build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
make
sudo make install
cd ../../../../
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
cd src
unzip IP2Location-C-Library-master.zip
cd IP2Location-C-Library-master
sudo autoreconf -i -v --force
sudo ./configure
sudo make
sudo make install
cd data
sudo perl ip-country.pl
cd ../../
make
cd Interfaces/
python3 Login.py