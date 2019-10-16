#! /bin/bash
sudo mount -t bpf bpf /sys/fs/bpf
cd src/Interfaces_v2/Metrics/node_exporter
sudo chmod +wrx node_exporter
cd ../Prometheus
sudo chmod +wrx prometheus
cd ../Grafana/bin
sudo chmod +wrx grafana-server
cd ../../../../eureka_jars/monitoring/src/main/resources
sudo chmod +wrx node_exporter
cd ../../../../../Interfaces_v2
sudo python3 main.py