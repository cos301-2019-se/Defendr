#! /bin/bash
sudo mount -t bpf bpf /sys/fs/bpf
sudo chmod +x /Interfaces_v2/Metrics/Prometheus/prometheus
sudo chmod +x /Interfaces_v2/Metrics/Prometheus/node_exporter
sudo chmod +x /Interfaces_v2/Metrics/Prometheus/grafana-server
cd src/Interfaces_v2
sudo python3 main.py