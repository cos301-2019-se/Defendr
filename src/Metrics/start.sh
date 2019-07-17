#Will need xterm to run
#sudo apt-get install xterm

cd node_exporter
chmod +wrx node_exporter
xterm -hold -e "./node_exporter" &
cd ..
cd Prometheus
chmod +wrx prometheus
xterm -hold -e "./prometheus" &
cd ..
cd Grafana/bin
chmod +wrx grafana-server
xterm -hold -e "./grafana-server" &
