#!/bin/bash

function apt {
  sudo apt update && sudo apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/main.sh) && bash <(curl -s https://raw.githubusercontent.com/DOUBLE-TOP/tools/main/docker.sh)
}

function  install {
  docker run -d -e minima_mdspassword=qwerty123 -e minima_server=true -v ~/maximadocker19001:/home/maxima/data -p 19001-19004:9001-9004 --restart unless-stopped --name maxima minimaglobal/minima:latest
}

function  watchtower {
docker run -d --restart unless-stopped --name watchtower -e WATCHTOWER_CLEANUP=true -e WATCHTOWER_TIMEOUT=60s -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
}

apt
install
watchtower