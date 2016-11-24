#! /bin/bash
set -e

MANAGER_TOKEN=$(curl -s http://127.0.0.1:8500/v1/kv/swarm/manager?recurse | grep -oP "Value\":\"\K([^\"]*)" | python -m base64 -d)
docker swarm join --token $MANAGER_TOKEN $1:2377
