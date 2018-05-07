#!/usr/bin/env bash

curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
apt install curl g++ gcc git nodejs build-essential -y
cd /$localuser/
git clone https://github.com/askmike/gekko.git
cd /$localuser/gekko
npm install --only=production
npm install talib tulip tulind
git clone https://github.com/gekkowarez/gekkoga.git
cd gekkoga
npm install
cd /$localuser/gekko
git clone https://github.com/tommiehansen/gekko_tools.git
cp /$localuser/gekko/gekko_tools/strategies/*.js /$localuser/gekko/strategies/
cp /$localuser/gekko/gekko_tools/strategies/*.toml /$localuser/gekko/config/strategies/
git clone https://github.com/Gab0/gekko-extra-indicators.git
cd /$localuser/gekko/gekko-extra-indicators/indicators
cp *.js /$localuser/gekko/strategies/indicators
cd /$localuser/gekko
sed -i 's/127.0.0.1/0.0.0.0/g' /$localuser/gekko/web/vue/UIconfig.js
sed -i 's/localhost/'${ipaddress}'/g' /$localuser/gekko/web/vue/UIconfig.js

printf "Which strategy would you like to run on %s? Strategy filename:" "$ipaddress"
read stratfilename
