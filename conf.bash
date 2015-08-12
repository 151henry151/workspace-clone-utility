#!/usr/bin/env bash

if [[ $UID -ne 0 ]]; then
  printf "This script must be executed with root privileges. If you are not root, execute this script with the command sudo ./conf.bash instead of just ./conf.bash."
fi

chooseremote() {
printf "Clone from (R)emote or (G)ithub?"
while read -r -n 1 -s answer; do
  if [[ $answer = [RrGg] ]]; then
    [[ $answer = [Rr] ]] && retval=0
    [[ $answer = [Gg] ]] && retval=1
    break
  fi
done

echo

return $retval
}

if chooseremote; then
  printf "This option is for remotely cloning the configuration of any machine which is online and is capable of connecting with scp."
  echo
  printf "Which ip address would you like to clone from? IP:"
  read ipaddress

  printf "Which user on %s would you like to clone? User:" "$ipaddress"
  read user

  scp .git-prompt.sh .bashrc .vimrc "$user"@"$ipaddress":~/
else
  printf "Cloning configuration from github"
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.bashrc -O ~/.bashrc
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.vimrc -O ~/.vimrc
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.git-prompt.sh -O ~/.git-prompt.sh
fi

if [ -d ~/.vim/autoload ] && [ -d ~/.vim/bundle ]; then 
printf "It looks like syntastic might already be installed."
else
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle && \
git clone https://github.com/scrooloose/syntastic.git  
fi
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

echo

return $retval
}


if [[ $UID -eq 0 ]]; then
  if asksure; then
    apt-get update
    apt-get upgrade
    apt-get install python-virtualenv

  else
    printf "Don't forget to upgrade and update later, then!"
  fi
else
  echo
  printf "Update and upgrade skipped because you do not have superuser priveliges. Virtualenv not installed."
fi

