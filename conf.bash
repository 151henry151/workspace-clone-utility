#!/usr/bin/env bash

# check if root
if [[ $UID -ne 0 ]]; then
  printf "This script must be executed with root privileges. Use sudo ./conf.bash or su -c './conf.bash' ."
  echo
  exit
fi

echo

yestoall=false
[[ $1 == -y ]] && yestoall=true

asksure() {
  [[ $yestoall == true ]] && return 0
  printf "(Y/N) "

  while read -rsn 1 answer; do
    case $answer in
    [yY])
      echo
      return 0
      ;;
    [nN])
      echo
      return 1
      ;;
    esac
  done

  return 1
}

printf "Install git?"
echo
if asksure; then
  apt install git -y
fi

echo
printf "Install multitail?"
if asksure; then
  apt install multitail -y
fi
echo

chooseremote() {
if (( yestoall )); then
retval=1
else
printf "Clone from (R)emote or (G)ithub?"
while read -r -n 1 -s answer; do
  if [[ $answer = [RrGg] ]]; then
    [[ $answer = [Rr] ]] && retval=0
    [[ $answer = [Gg] ]] && retval=1
    break
  fi
done
fi
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
  read localuser
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.rootbashrc" -O "/root/.bashrc"
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.bashrc" -O "/home/"$localuser"/.bashrc"
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.vimrc" -O "/home/"$localuser"/.vimrc"
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.vimrc" -O "/root/.vimrc"
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.git-prompt.sh" -O "/home/"$localuser"/.git-prompt.sh" 
fi

if [ -d "/home/"$localuser"/.vim/autoload"  ] && [ -d "/home/"$localuser"/.vim/bundle"  ]; then 
printf "It looks like syntastic might already be installed."
echo
else
mkdir -p "/home/"$localuser"/.vim/autoload" "/home/"$localuser"/.vim/bundle" && \
curl -LSso "/home/"$localuser"/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
cd "/home/"$localuser"/.vim/bundle" && \
git clone https://github.com/vim-syntastic/syntastic.git  
fi


printf "Install gekko and set up a gekko environment?"
echo
if asksure; then
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
echo
printf "Gekko and GekkoGA installed and ready for use. Edit /gekko/web/vue/UIconfig to set headless mode if desired."
echo
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
  adduser $user sudo
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

