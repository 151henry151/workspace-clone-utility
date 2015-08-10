#!/usr/bin/env bash
printf "This script is for remotely cloning the configuration of any machine which is online and is capable of connecting with scp."

if [[ $UID -ne 0 ]];
  printf "This script must be executed with root privileges. If you are not root, execute this script with the command sudo ./conf.bash instead of just ./conf.bash."
fi

printf "Which ip address would you like to clone from? IP:"
read ipaddress

printf "Which user on %s would you like to clone? User:" "$ipaddress"
read user

scp .git-prompt.sh .bashrc .vimrc "$user"@"$ipaddress":~/

printf "Perform an update, an upgrade, and install python-virtualenv?"

asksure() {
printf "(Y/N)"
while read -r -n 1 -s answer; do
  if [[ $answer = [YyNn] ]]; then
    [[ $answer = [Yy] ]] && retval=0
    [[ $answer = [Nn] ]] && retval=1
    break
  fi
done

printf

return $retval
}


if [[ $UID -eq 0 ]];
  if asksure; then
    apt-get update
    apt-get upgrade
    apt-get install python-virtualenv

  else
    printf "Don't forget to upgrade and update later, then!"
  fi
else
  printf "Update and upgrade skipped because you do not have superuser priveliges. Virtualenv not installed."

