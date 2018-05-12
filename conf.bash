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
  chown $localuser:$localuser "/home/"$localuser"/.vimrc"
  wget "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" -O "/root/.git-prompt.sh"
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.vimrc" -O "/root/.vimrc"
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.git-prompt.sh" -O "/home/"$localuser"/.git-prompt.sh"
  wget "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" -O "/home/"$localuser"/.git-prompt.sh"
  chown $localuser:$localuser "/home/"$localuser"/git-prompt.sh" 
fi

if [ -d "/home/"$localuser"/.vim/autoload"  ] && [ -d "/home/"$localuser"/.vim/bundle"  ]; then 
printf "It looks like syntastic might already be installed."
echo
else
echo
printf "Installing syntastic and pathogen for user %s" $localuser
mkdir -p "/home/"$localuser"/.vim/autoload" "/home/"$localuser"/.vim/bundle" && \
curl -LSso "/home/"$localuser"/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
cd "/home/"$localuser"/.vim/bundle" && \
git clone https://github.com/vim-syntastic/syntastic.git  
fi
echo
if [ -d "/root/.vim/autoload"  ] && [ -d "/root/.vim/bundle"  ]; then 
printf "It looks like syntastic is already installed for root as well"
echo
else
echo
printf "Installing syntastic and pathogen for root user"
mkdir -p "/root/.vim/autoload" "/root/.vim/bundle" && \
curl -LSso "/root/.vim/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
cd "/root/.vim/bundle" && \
git clone https://github.com/vim-syntastic/syntastic.git  
fi
printf "Install git?"
echo
if asksure; then
  apt install git -y
fi

echo
printf "Install multitail?"
if asksure; then
  apt install multitail -y
  wget "https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/.multitailrc" -O "/home/"$localuser"/.multitailrc"
fi
echo



cd


printf "Install gekko and set up a gekko environment?"
echo
if asksure; then
printf "What is the IP address of the machine gekko will run on?"
read ipaddress
echo
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
apt install curl g++ gcc git nodejs build-essential -y
cd "/home/"$localuser
git clone https://github.com/askmike/gekko.git
cd "/home/"$localuser"/gekko"
npm install --only=production
npm install talib tulip tulind
git clone https://github.com/gekkowarez/gekkoga.git
cd gekkoga
npm install
cd "/home/"$localuser"/gekko"
git clone https://github.com/tommiehansen/gekko_tools.git
cp -r "/home/"$localuser"/gekko/gekko_tools/strategies/"*.js "/home/"$localuser"/gekko/strategies/"
cp -r "/home/"$localuser"/gekko/gekko_tools/strategies/"*.toml "/home/"$localuser"/gekko/config/strategies/"
git clone https://github.com/Gab0/gekko-extra-indicators.git
cd "/home/"$localuser"/gekko/gekko-extra-indicators/indicators"
cp *.js "/home/"$localuser"/gekko/strategies/indicators/"
cd "/home/"$localuser"/gekko"
sed -i 's/127.0.0.1/0.0.0.0/g' "/home/"$localuser"/gekko/web/vue/UIconfig.js"
sed -i 's/localhost/'${ipaddress}'/g' "/home/"$localuser"/gekko/web/vue/UIconfig.js"
sed -i 's/headless:\ false/headless:\ true/g' "/home/"$localuser"/gekko/web/vue/UIconfig.js"
echo
printf "Gekko and GekkoGA installed and ready for use. Navigate to %s:3000 in your web browser for the UI." $ipaddress
echo
chown -R $localuser:$localuser "/home/"$localuser"/gekko"
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

