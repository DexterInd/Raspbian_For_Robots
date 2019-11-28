#! /bin/bash

# this installs websockify, novnc, shellinabox
# assumed already installed: apache2 and tightvncserver


echo "--> install websockify."
echo "--> ======================================="
sudo apt-get install websockify -y

# Install noVNC
# this installation will only work if :
# 1. Apache is already installed
# 2. realvncserver is already installed

# Setup Webpage
echo "--> Setup webpage."
echo "--> ======================================="
echo " "
sudo rm -r /var/www
sudo mkdir -p /var/www/html
sudo cp -rp /home/pi/di_update/Raspbian_For_Robots/www/* /var/www/html
sudo cp /var/www/html/index_buster.php /var/www/html/index.php
sudo ln -s /etc/hostname /var/www/html/hostname


# Setup Shellinabox
echo "--> Setup Shellinabox."
echo "--> ======================================="
echo " "
sudo apt-get install shellinabox -y

#echo "--> Setup screen."
#echo "--> ======================================="
#echo " "
# screen currently installed but not used.
#sudo apt-get install screen -y

# clone noVNC
echo "--> Setup noVNC"
echo "--> ======================================="
echo " "
cd /usr/local/share
echo "--> Clone noVNC."
sudo rm -rf noVNC
sudo git clone git://github.com/DexterInd/noVNC
cd noVNC
# change homepage
sudo cp vnc_auto.html index.html


# install systemd service

sudo cp /home/pi/di_update/Raspbian_For_Robots/buster_update/novnc.service /etc/systemd/system/novnc.service
sudo chown root:root /etc/systemd/system/novnc.service

sudo systemctl daemon-reload && sudo systemctl enable novnc.service

# no idea if this part is needed with Jessie, but it sounds like it is. (NP)
# Change permissions so you can execute from the desktop
####  http://thepiandi.blogspot.ae/2013/10/can-python-script-with-gui-run-from.html
####  http://superuser.com/questions/514688/sudo-x11-application-does-not-work-correctly

echo "Change bash permissions for desktop."
if grep -Fx "xhost +" /home/pi/.bashrc
then
    #Found it, do nothing!
    echo "Found xhost in .bashrc"
else
    echo "xhost + 2> /dev/null" >> /home/pi/.bashrc
fi
