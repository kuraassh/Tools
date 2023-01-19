#!/bin/bash

curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_docker.sh | bash

echo "alias fishing='docker exec fishing ./bin/run'" >> ~/.profile

source ~/.profile

sudo tee <<EOF >/dev/null $HOME/docker-compose.yaml
version: "3.3"
services:
 ironfish:
  container_name: fishing
  image: ghcr.io/iron-fish/ironfish:latest
  restart: always
  entrypoint: sh -c "sed -i 's%REQUEST_BLOCKS_PER_MESSAGE.*%REQUEST_BLOCKS_PER_MESSAGE = 5%' /usr/src/app/node_modules/ironfish/src/syncer.ts && apt update > /dev/null && apt install curl -y > /dev/null; ./bin/run start"
  healthcheck:
   test: "curl -s -H 'Connection: Upgrade' -H 'Upgrade: websocket' http://127.0.0.1:9033 || killall5 -9"
   interval: 180s
   timeout: 180s
   retries: 3
  volumes:
   - $HOME/.fishing:/root/.fishing
EOF

docker-compose pull && docker-compose up -d

fishing wallet:create $NODENAME && fishing wallet:use $NODENAME fishing config:set nodeName $NODENAME && fishing config:set blockGraffiti $NODENAME && fishing config:set minerBatchSize 60000 && fishing config:set enableTelemetry true

