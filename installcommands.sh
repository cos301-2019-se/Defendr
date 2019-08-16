#! /bin/bash
sudo apt-get install -y scite
sudo scite /etc/ld.so.conf
cd src/mongoDriver
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y libcurl4
sudo apt-get install -y cmake
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
sudo make install
cd ../../../../
sudo apt install -y clang llvm libelf-dev
sudo apt install -y linux-tools-$(uname -r)
sudo apt install -y linux-headers-$(uname -r)
sudo apt install -y bcc bpfcc-tools
sudo apt install -y python3
sudo apt install -y python3-pip
sudo apt-get install -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev 
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y libportmidi-dev libswscale-dev libavformat-dev libavcodec-dev zlib1g-dev
sudo apt-get install -y libgles2-mesa-dev
sudo pip3 install pymongo
sudo pip3 install dnspython
sudo pip3 install cefpython3==66.0
sudo pip3 install pygments
sudo pip3 install docutils
sudo pip3 install cython
sudo pip3 install kivy
sudo apt install -y gradle
sudo apt install -y net-tools
sudo apt install -y apache2
sudo apt-get install -y libtool
sudo apt-get install -y autoconf
cd src
sudo rm -r IP2Location-C-Library-master
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
sudo chmod +x /Interfaces/Metrics/Prometheus/prometheus
sudo chmod +x /Interfaces/Metrics/node_exporter/node_exporter
sudo chmod +x /Interfaces/Metrics/Grafana/bin/grafana-server
cd Interfaces_v2
python3 main.py