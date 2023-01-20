#!/bin/bash

function install {
  wget https://github.com/massalabs/massa/releases/download/TEST.18.0/massa_TEST.18.0_release_linux.tar.gz
  tar zxvf massa_TEST.18.0_release_linux.tar.gz -C $HOME/
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

function delete {
  rm -rf $HOME/massa_TEST.18.0_release_linux.tar.gz
}

function routable_ip {
  sed -i 's/.*routable_ip/# \0/' "$HOME/massa/massa-node/base_config/config.toml"
  sed -i "/\[network\]/a routable_ip=\"$(ifconfig | grep "inet6" | grep "scopeid 0x0<global>" | awk '{ print $2 }')\"" "$HOME/massa/massa-node/base_config/config.toml"
}

function rename {
mv $HOME/massa/massa-client/massa-client $HOME/massa/massa-client/array-client
mv $HOME/massa/massa-client/ $HOME/massa/array-client/

mv $HOME/massa/massa-node/massa-node $HOME/massa/massa-node/array-n
mv $HOME/massa/massa-node $HOME/massa/array-n

mv $HOME/massa/ $HOME/array/
}

function massa_pass {
  if [ ! ${massa_pass} ]; then
  echo "Введите свой пароль для клиента(придумайте)"
  line
  read massa_pass
  fi
  echo "export massa_pass=$massa_pass" >> $HOME/.profile
  source $HOME/.profile
}

function systemd {
  sudo tee <<EOF >/dev/null /etc/systemd/system/array.service
[Unit]
Description=array
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/array/array-n
ExecStart=$HOME/array/array-n/array-n -p "$massa_pass"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable array
sudo systemctl restart array
}

function alias {
  echo "alias client='cd $HOME/array/array-client/ && $HOME/array/array-client/array-client --pwd $massa_pass && cd'" >> ~/.profile
  echo "alias clientw='cd $HOME/array/array-client/ && $HOME/array/array-client/array-client --pwd $massa_pass && cd'" >> ~/.profile
}

line
massa_pass
delete
install
routable_ip
line
systemd
line
alias