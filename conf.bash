#!/usr/bin/env bash
echo "This script is for remotely cloning the configuration of any machine which is online and is capable of connecting with scp."

echo -n "Which ip address would you like to clone from? IP:"
read ipaddress

echo -n "Which user on $ipaddress would you like to clone? User:"
read user

scp .git-prompt.sh .bashrc .vimrc $user@$ipaddress:~/

echo "Recommend performing an update, an upgrade, and installing python-virtualenv. Do so automatically?"

asksure() {
echo -n "(Y/N)"
while read -r -n 1 -s answer; do
  if [[ $answer = [YyNn] ]]; then
    [[ $answer = [Yy] ]] && retval=0
    [[ $answer = [Nn] ]] && retval=1
    break
  fi
done

echo

return $retval
}

if asksure; then
  apt-get update
  apt-get upgrade
  apt-get install python-virtualenv

else
  echo "Don't forget to upgrade and update later, then! And if you're going to work with python, you really ought to install virtualenv!"
fi
