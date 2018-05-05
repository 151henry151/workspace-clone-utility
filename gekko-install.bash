#!/usr/bin/env bash


printf "This script installs gekko, related tools, and dependencies. It does require sudo and apt. This script was built for Debian 9."
sudo apt-get install -y tmux
sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y gcc
sudo apt-get install -y git
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
cd ~/
git clone https://github.com/askmike/gekko.git
cd ~/gekko
npm install --only=production
npm install talib
npm install tulip
npm install tulind
git clone https://github.com/gekkowarez/gekkoga.git
cd gekkoga
npm install
cd ~/gekko
git clone https://github.com/tommiehansen/gekko_tools.git
cp ~/gekko/gekko_tools/strategies/*.js ~/gekko/strategies/
cp ~/gekko/gekko_tools/strategies/*.toml ~/gekko/config/strategies/
git clone https://github.com/Gab0/gekko-extra-indicators.git
cd ~/gekko/gekko-extra-indicators/indicators
cp *.js ~/gekko/strategies/indicators
cd ~/gekko

