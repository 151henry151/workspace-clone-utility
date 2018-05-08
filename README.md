# workspace-clone-utility
Clones a workspace configuration, either from the files here in this repository, or from another computer, using scp. Includes .vimrc, .bashrc, .git-prompt.sh, and installs syntastic and pathogen. Also asks if you would like to install gekko, and if you do, installs gekko and assorted related tools. To run, simply execute with something like `sudo ./conf.bash` or `su -c './conf.bash'` or `./conf.bash` as root. If you run with `-y` flag, it will automatically clone from github and automatically install a selection of programs.

# Instructions for making a gekko environment:

* First, spin up a fresh VPS with Debian 9. I like vultr and kimsufi, there are many options, choose one you like and to suit your needs. 
* Then, ssh in as root. If you are on windows, you will need to download something like putty. If you're on linux, you'll do something like `ssh root@my.new.vps.ipaddress` 
* Create your user account (in my case, `adduser henry`), and login to your new user account (in my case, `login henry`).
* Download the utility: `wget https://raw.githubusercontent.com/151henry151/workspace-clone-utility/master/conf.bash`
* Make the file executable: `chmod u+x conf.bash`
* Run the script with the "yes to all" flag: `./conf.bash -y`
* Open ~/gekko/web/vue/UIconfig.js with your preferred text editor. Set `headless: true,` on line 7 if you want to use the user interface, or leave it as false if you plan to use gekko from the command line only. Ensure that line 9 has been changed from `host: '127.0.0.1',` to `host: '0.0.0.0',` and that line 15 has been changed from `host: 'localhost',` to your actual IP address, the same one you use to ssh into the server. Save your changes and exit.
* Start a tmux session with `tmux`
* In your tmux session, press ctrl+b and then shift+5 (the % symbol). This will split the tmux screen in two panes.
* On one pane, cd into the gekko directory and run "node gekko --ui"
* On the other pane, navigate to the gekko/gekkoga/ folder (to switch panes, press ctrl+b and then the left or right arrow).
* Open a web browser and navigate to your.ip.addres.here:3000
* In the user interface, go to local data and import any data you want to backtest on, or go to https://github.com/xFFFFF/Gekko-Datasets and acquire datasets from there (automation of this step coming soon!)
* In the gekkoga pane of tmux, copy the config/sample-config.js file `cp config/sample-config.js config/my-new-config.js`
* Modify your config file to determine what data ranges and what strategy the genetic algorithm should work on (make sure you set a valid date range or that if you set it to scan, you only have one continuous dataset for that currency pair on that exchange, no gaps).
* Run gekko genetic algorithm with `run -c config/my-new-config.js`
* Find good parameters for automated trading strategies
* Run them live with lots of money
* Get super wealthy
* Donate a bunch to the church of bitcoin https://churchofbitcoin.org
* Buy a lambo
