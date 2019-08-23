#! /bin/bash
sudo mount -t bpf bpf /sys/fs/bpf
sudo chmod +x /Interfaces/Metrics/Prometheus/prometheus
sudo chmod +x /Interfaces/Metrics/Prometheus/node_exporter
sudo chmod +x /Interfaces/Metrics/Prometheus/grafana-server
cd src/Interfaces
python3 Login.py