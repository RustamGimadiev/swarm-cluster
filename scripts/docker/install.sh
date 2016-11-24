#! /bin/bash
set -e 

LOCAL_IP=$(ifconfig  eth1 | grep -oP "addr:\K([.0-9]*) "| awk '{print $1}')

docker swarm init --advertise-addr $LOCAL_IP

WORKER_TOKEN=$(docker swarm join-token worker | grep -oP "token \K([^ ]*)")
MANAGER_TOKEN=$(docker swarm join-token manager | grep -oP "token \K([^ ]*)")

curl -X PUT -d $WORKER_TOKEN http://127.0.0.1:8500/v1/kv/swarm/worker
curl -X PUT -d $MANAGER_TOKEN http://127.0.0.1:8500/v1/kv/swarm/manager
