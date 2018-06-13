#!/bin/bash
################################################################################
# Original Author:   crombiecrunch
# Fork Author: manfromafar
# Current Author: Xavatar
# Web:     
#
# Program:
#   Install yiimp on Ubuntu 16.04 running Nginx, MariaDB, and php7.0.x
# 
# 
################################################################################
output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}

    
    output " "
    output "Updating system and installing required packages."
    output " "
    sleep 3
    
    
    # update package and upgrade Ubuntu
    sudo apt-get -y update 
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
    
    output " "
    output "Switching to Aptitude"
    output " "
    sleep 3
    
    sudo apt-get -y install aptitude
    


    

    sudo aptitude -y install libgmp3-dev
    sudo aptitude -y install libmysqlclient-dev
    sudo aptitude -y install libcurl4-gnutls-dev
    sudo aptitude -y install libkrb5-dev
    sudo aptitude -y install libldap2-dev
    sudo aptitude -y install libidn11-dev
    sudo aptitude -y install gnutls-dev
    sudo aptitude -y install librtmp-dev
    sudo aptitude -y install mutt
    sudo aptitude -y install git screen
    sudo aptitude -y install pwgen -y


    #Installing Package to compile crypto currency
    output " "
    output "Installing Package to compile crypto currency"
    output " "
    sleep 3
    
    sudo aptitude -y install software-properties-common build-essential
    sudo aptitude -y install libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev libseccomp-dev libcap-dev libminiupnpc-dev
    sudo aptitude -y install libminiupnpc10 libzmq5
    sudo aptitude -y install libcanberra-gtk-module libqrencode-dev libzmq3-dev
    sudo aptitude -y install libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    sudo add-apt-repository -y ppa:bitcoin/bitcoin
    sudo apt-get -y update
    sudo apt-get install -y libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
       

	
    output " "
    output " Installing yiimp"
    output " "
    output "Grabbing yiimp fron Github, building files and setting file structure."
    output " "
    sleep 3
    
    
    #Generating Random Password for stratum
    blckntifypass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    cd ~
    git clone https://github.com/tpruvot/yiimp.git
    cd $HOME/yiimp/blocknotify
    sudo sed -i 's/tu8tu5/'$blckntifypass'/' blocknotify.cpp
    sudo make
    cd $HOME/yiimp/stratum/iniparser
    sudo make
    cd $HOME/yiimp/stratum
    if [[ ("$BTC" == "y" || "$BTC" == "Y") ]]; then
    sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $HOME/yiimp/stratum/Makefile
    sudo make
    fi
    sudo make
    cd $HOME/yiimp
    sudo sed -i 's/AdminRights/'$admin_panel'/' $HOME/yiimp/web/yaamp/modules/site/SiteController.php
    sudo cp -r $HOME/yiimp/web /var/
    sudo mkdir -p /var/stratum
    cd $HOME/yiimp/stratum
    sudo cp -a config.sample/. /var/stratum/config
    sudo cp -r stratum /var/stratum
    sudo cp -r run.sh /var/stratum
    cd $HOME/yiimp
    sudo cp -r $HOME/yiimp/bin/. /bin/
    sudo cp -r $HOME/yiimp/blocknotify/blocknotify /usr/bin/
    sudo cp -r $HOME/yiimp/blocknotify/blocknotify /var/stratum/
    sudo mkdir -p /etc/yiimp
    sudo mkdir -p /$HOME/backup/
    #fixing yiimp
    sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=/var|g" /bin/yiimp
    #fixing run.sh
    sudo rm -r /var/stratum/config/run.sh
	echo '
#!/bin/bash
ulimit -n 65535
ulimit -u 65535
cd /var/stratum
while true; do
        ./stratum /var/stratum/config/$1
        sleep 2
done
exec bash
' | sudo -E tee /var/stratum/config/run.sh >/dev/null 2>&1
sudo chmod +x /var/stratum/config/run.sh



output " "
output "Final Directory permissions"
output " "
sleep 3

whoami=`whoami`
sudo mkdir /root/backup/
#sudo usermod -aG www-data $whoami
#sudo chown -R www-data:www-data /var/log
sudo chown -R www-data:www-data /var/stratum
sudo chown -R www-data:www-data /var/web
sudo touch /var/log/debug.log
sudo chown -R www-data:www-data /var/log/debug.log
sudo chmod -R 775 /var/www/$server_name/html
sudo chmod -R 775 /var/web
sudo chmod -R 775 /var/stratum
sudo chmod -R 775 /var/web/yaamp/runtime
sudo chmod -R 664 /root/backup/
sudo chmod -R 644 /var/log/debug.log
sudo chmod -R 775 /var/web/serverconfig.php
sudo mv $HOME/yiimp/ $HOME/yiimp-install-only-do-not-run-commands-from-this-folder


output " "
output " "
output " "
output " "
output "Whew that was fun, just some reminders. Your mysql information is saved in ~/.my.cnf. this installer did not directly install anything required to build coins."
output " "
output "Please make sure to change your wallet addresses in the /var/web/serverconfig.php file."
output " "
output "Please make sure to add your public and private keys."
output " "
output "TUTO Youtube : https://www.youtube.com/watch?v=vdBCw6_cyig"
output " "
output " "
