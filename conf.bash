#!/usr/bin/env bash

if [[ $UID -ne 0 ]]; then
  printf "This script must be executed with root privileges. Use sudo ./conf.bash or su -c './conf.bash'."
  echo
  exit
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
  
  printf "Which local user would you like to create? User:"
  read localuser

  scp .git-prompt.sh .bashrc lvimrc "$user"@"$ipaddress":$localuser
else
  printf "Cloning configuration from github"
  echo
  printf "Which local user would you like to setup? User:"
  read user
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.rootbashrc -O /root/.bashrc
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.bashrc -O /home/$user/.bashrc
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.vimrc -O /home/$user/.vimrc
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.vimrc -O /root/.vimrc
  wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.git-prompt.sh -O /home/$user/.git-prompt.sh
fi

if [ -d /home/$user/.vim/autoload ] && [ -d /home/$user/.vim/bundle ]; then 
printf "It looks like syntastic might already be installed."
echo
else
mkdir -p /home/$user/.vim/autoload /home/$user/.vim/bundle && \
curl -LSso /home/$user/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd /home/$user/.vim/bundle && \
git clone https://github.com/vim-syntastic/syntastic.git  
fi


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

printf "Install gekko and set up a gekko environment?"
echo
if asksure; then
  ./gekko-install.bash
fi

echo
printf "Install locate?"
echo
if asksure; then
  apt install locate -y
  updatedb
fi

echo
printf "Install tmux?"
echo
if asksure; then
  apt install tmux -y
fi

echo
printf "Install sudo?"
echo
if asksure; then
  apt install sudo -y
fi

echo
printf "Install python?"
echo
if asksure; then
  apt install python -y
fi

echo
printf "Update and upgrade?"
echo

if asksure; then
  apt-get update -y && apt-get upgrade -y

else
  printf "Don't forget to upgrade and update later, then!"
fi

