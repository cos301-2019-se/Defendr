#! /bin/bash
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
make
sudo chmod +x /Interfaces/Metrics/Prometheus/prometheus
sudo chmod +x /Interfaces/Metrics/Prometheus/node_exporter
sudo chmod +x /Interfaces/Metrics/Prometheus/grafana-server
cd Interfaces
python3 Login.py