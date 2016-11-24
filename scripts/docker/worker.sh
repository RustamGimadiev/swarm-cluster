#! /bin/bash
set -e

WORKER_TOKEN=$(curl -s http://127.0.0.1:8500/v1/kv/swarm/worker?recurse | grep -oP "Value\":\"\K([^\"]*)" | python -m base64 -d)
docker swarm join --token $WORKER_TOKEN $1:2377
