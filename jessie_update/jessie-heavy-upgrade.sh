#! /bin/bash
#
# Add LX Desktop And Raspberry Pi to Jessie Lite
# by John Cole // Dexter Industries
#
###################################################
#
# To Setup and Run:
# cd /home/pi/
# sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/update_backup.sh
# sudo chmod +x update_backup.sh
# sudo ./update_backup.sh
# cd /home/pi/di_update/Raspbian_For_Robots/jessie_update/
# sudo chmod +x jessie-heavy-upgrade.sh
# sudo ./jessie-heavy-upgrade.sh
#
###################################################

###################################################
##
## Take Jessie Lite to Raspbian
##
###################################################

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get dist-upgrade -y
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y
sudo apt-get install raspberrypi-net-mods -y
sudo apt-get install wpagui -y
sudo apt-get install scratch -y

sudo apt-get install avahi-autoipd tightvncserver bc python-imaging python-pexpect python-renderpm python-reportlab python-reportlab-accel python-tk python3-tk idle idle-python2.7 idle3 nodejs nodejs-legacy pypy-setuptools pypy-upstream pypy-upstream-dev pypy-upstream-doc blt bluetooth -y

sudo apt-get remove gnome-mplayer yelp deluge claws-mail iceweasel lxmusic audacious transmission-gtk midori netsurf-gtk dillo -y

sudo apt-get autoremove -y
sudo apt-get clean -y

## Now Custom Modifications for Dexter Industries Raspbian for Robots.  
sudo apt-get install git -y
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/update_backup.sh /home/pi
sudo chmod +x update_backup.sh
sudo ./update_backup.sh

cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GoPiGo.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/GrovePi.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_Python.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/ArduBerry.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_Scratch.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_Python.git
cd /home/pi/Desktop
sudo git clone https://github.com/DexterInd/BrickPi_C.git
cd /home/pi/Desktop

sudo sh /home/pi/di_update/Raspbian_For_Robots/update_master.sh


##################################################################
##
## After you run this run the update software on the Desktop.
##
##################################################################

# Changes by Hand:
# Change Passwords
# Change VNC Passwords
# Change background desktop to white.
# Install TightVNC Server and Set to Run at Boot.  https://learn.adafruit.com/adafruit-raspberry-pi-lesson-7-remote-control-with-vnc/running-vncserver-at-startup
# Setup Autoboot:  http://www.penguintutor.com/raspberrypi/tightvnc
# sudo tightvncserver
# sudo nano /etc/systemd/system/tightvncserver.service
## [Unit]
## Description=TightVNC remote desktop server
## After=sshd.service
##  
## [Service]
## Type=dbus
## ExecStart=/usr/bin/tightvncserver :1
## User=pi
## Type=forking
##  
## [Install]
## WantedBy=multi-user.target
##
# sudo chown root:root /etc/systemd/system/tightvncserver.service
# sudo chmod 755 /etc/systemd/system/tightvncserver.service
# sudo systemctl start tightvncserver.service
# sudo systemctl enable tightvncserver.service



