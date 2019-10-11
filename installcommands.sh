#! /bin/bash
sudo chown -R $USER * #Change ownership of files to the current user
sudo apt-get install -y scite
sudo scite /etc/ld.so.conf
cd src/mongoDriver
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y -y mongodb-org
sudo apt-get install -y libmongoc-1.0-0
sudo apt-get install -y libbson-1.0
sudo apt-get install -y cmake libssl-dev libsasl2-dev
sudo apt-get install -y pkg-config
sudo apt-get install -y openssl
tar xzf mongo-c-driver*tar.gz
cd mongo-c-driver*0
mkdir cmake-build
cd cmake-build
cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ..
make
sudo make install -y
cd ../../../../
sudo apt install -y clang llvm libelf-dev
sudo apt install -y linux-tools-$(uname -r)
sudo apt install -y linux-headers-$(uname -r)
sudo apt install -y bcc bpfcc-tools
sudo apt install -y python3
sudo apt install -y python3-pip
sudo apt install -y python3-tk
sudo pip3 install pymongo
sudo pip3 install dnspython
sudo apt install -y gradle
sudo apt install -y net-tools
sudo apt install -y apache2
sudo apt-get install -y libtool
sudo apt-get install -y autoconf
pip3 install prometheus_client
pip3 install flask_prometheus_metrics
pip3 install flask_prometheus_metrics[flask]
cd src
unzip IP2Location-C-Library-master.zip
cd IP2Location-C-Library-master
sudo autoreconf -i -v --force
sudo ./configure
sudo make
sudo make install -y
cd data
sudo perl ip-country.pl
cd ../../
rm IP2Location-C-Library-master.zip
#rm -r IP2Location-C-Library-master
make
sudo chmod +wrx /Interfaces_v2/Metrics/permissions.sh #Changed to new directory location
sudo add-apt-repository ppa:kivy-team/kivy # stable builds repository
sudo apt-get update 
sudo apt-get install python-kivy python3-kivy python-kivy-examples
wget https://github.com/chrislim2888/IP2Location-Python/archive/master.zip #Download IP2Location-Python lib
unzip IP2Location-Python-master.zip
cd IP2Location-Python-master
python3 setup.py build
python3 setup.py install
mv data/IP-*RY.BIN ../Metrics # Move database file from /IP2Location-Python-master to /Metrics
cd .. # return to /src
rm IP2Location-Python-master.zip # Clean-up
rm IP2Location-Python-master # CLean-up
cd Interfaces_v2
sudo python3 main.py #Changed to new file
