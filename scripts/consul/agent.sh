#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

LOCAL_IP=$(ifconfig  eth1 | grep -oP "addr:\K([.0-9]*) "| awk '{print $1}')

echo "Installing dependencies..."
sudo apt-get update -y &>/dev/null
sudo apt-get install -y unzip

echo "Fetching Consul..."
cd /tmp
curl -s -L -o consul.zip https://releases.hashicorp.com/consul/0.7.1/consul_0.7.1_linux_amd64.zip

echo "Installing Consul..."
unzip consul.zip >/dev/null
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /etc/consul.d /var/lib/consul

START_JOIN=""

for i in `seq 1  ${#@}`
        do
        START_JOIN+="\"${@:$i:1}\""
        if (( $i < ${#@} ))
                then
                START_JOIN+=", "
        fi
done

echo '{
  "data_dir": "/var/lib/consul",
  "client_addr": "0.0.0.0",
  "ui": true,
  "start_join": ['$START_JOIN'],
  "datacenter": "dev",
  "log_level": "INFO",
  "enable_syslog": true,
  "advertise_addr": '"\"$LOCAL_IP\""'
}' | sudo tee /etc/consul.d/server.json

echo "Installing Upstart service..."
sudo cp /vagrant/templates/consul.conf /etc/init/consul.conf

echo "Starting Consul..."
sudo start consul || exit 0
