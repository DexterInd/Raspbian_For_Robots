#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script will be changed OFTEN! 

########################################################################
## These Changes to the image are all mandatory.  If you want to run DI
## Hardware, you're going to need these changes.

echo "--> Begin Update."
echo "--> ======================================="
sudo apt-get update -y

echo "Install Specific Libraries."
sudo dpkg --configure -a
sudo apt-get --purge remove python-wxgtk2.8 python-wxtools wx2.8-i18n -y	  			# Removed, this can sometimes cause hangups.  

echo "Purged wxpython tools"
sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --force-yes			# Install wx for python for windows / GUI programs.
echo "Installed wxpython tools"
sudo apt-get install python-psutil --force-yes
echo "Python-PSUtil"

sudo apt-get install python3-serial -y
sudo apt-get install python-serial -y
sudo apt-get install i2c-tools -y

sudo apt-get purge python-rpi.gpio -y
sudo apt-get purge python3-rpi.gpio -y
sudo apt-get install python-rpi.gpio
sudo apt-get install python3-rpi.gpio
sudo apt-get install python-psutil -y 		# Used in Scratch GUI
sudo apt-get install python-picamera -y
sudo apt-get install python3-picamera -y
sudo pip install -U RPi.GPIO

sudo adduser pi i2c

########################################################################
## Kernel Updates
# Enable I2c and SPI.  
echo "--> Begin Kernel Updates."
echo "--> Start Update /etc/modules."
echo "--> ======================================="
echo " "
sudo sed -i "/i2c-bcm2708/d" /etc/modules
sudo sed -i "/i2c-dev/d" /etc/modules
sudo echo "i2c-bcm2708" >> /etc/modules
sudo echo "i2c-dev" >> /etc/modules
echo "--> Start Update Raspberry Pi Blacklist.conf" 	#blacklist spi-bcm2708 #blacklist i2c-bcm2708
echo "--> ======================================="
echo " "
sudo sed -i "/blacklist spi-bcm2708/d" /etc/modprobe.d/raspi-blacklist.conf
sudo sed -i "/blacklist i2c-bcm2708/d" /etc/modprobe.d/raspi-blacklist.conf
sudo echo "##blacklist spi-bcm2708" >> /etc/modprobe.d/raspi-blacklist.conf
sudo echo "##blacklist i2c-bcm2708" >> /etc/modprobe.d/raspi-blacklist.conf
# For Raspberry Pi 3.18 kernel and up.
echo "--> Update Config.txt file"   #dtparam=i2c_arm=on  #dtparam=spi=on
echo "--> ======================================="
echo " "
sudo sed -i "/dtparam=i2c_arm=on/d" /boot/config.txt
sudo sed -i "/dtparam=spi=on/d" /boot/config.txt
sudo echo "dtparam=spi=on" >> /boot/config.txt
sudo echo "dtparam=i2c_arm=on" >> /boot/config.txt
echo "--> End Kernel Updates."

########################################################################
##
# Cleanup the Desktop
echo "--> Desktop cleanup."
echo "--> ======================================="
echo " "
sudo rm /home/pi/Desktop/ocr_resources.desktop 		# Not sure how this Icon got here, but let's take it out.
sudo rm /home/pi/Desktop/python-games.desktop 		# Not sure how this Icon got here, but let's take it out.


# Call fetch.sh - This updates the Github Repositories, installs necessary dependencies.
echo "--> Begin Update Dexter Industries Software Packages."
echo "--> ======================================="
echo " "
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/fetch.sh


# Enable LRC Infrared Control on Pi.
echo "--> Enable LRC Infrared Control on Pi."
echo "--> ======================================="
echo " "
sudo sh /home/pi/Desktop/GoPiGo/Software/Python/ir_remote_control/script/ir_install.sh


# Update background image - Change to dilogo.png
# These commands don't work:  sudo rm /etc/alternatives/desktop-background  ;;  sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.jpg /etc/alternatives/
echo "--> Update the background image on LXE Desktop."
echo "--> ======================================="
echo " "
sudo rm /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png
sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.png /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png


########################################################################
## These Changes to the image are all optional.  Some users may not want
## these changes.  They should be offered ala-cart.

# Update Wifi Interface
echo "--> Update wifi interface."
echo "--> ======================================="
echo " "
sudo apt-get install raspberrypi-net-mods -y	# Updates wifi configuration.  Does it wipe out network information?

# Setup Apache
echo "--> Install Apache. and PHP"
echo "--> ======================================="
echo " "
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y

# Setup Webpage
echo "--> Setup webpage."
echo "--> ======================================="
echo " "
sudo rm -r /var/www
sudo cp -r /home/pi/di_update/Raspbian_For_Robots/www /var/
sudo chmod +x /var/www/index.php

# Setup Shellinabox
echo "--> Setup Shellinabox."
echo "--> ======================================="
echo " "
sudo apt-get install shellinabox -y

# Setup noVNC
echo "--> Setup screen."
echo "--> ======================================="
echo " "
sudo apt-get install screen
echo "--> Setup noVNC"
echo "--> ======================================="
echo " "
cd /usr/local/share/
echo "--> Clone noVNC."
sudo git clone git://github.com/DexterInd/noVNC
cd noVNC
sudo cp vnc_auto.html index.html
cd /etc/init.d/
sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncboot --no-check-certificate
sudo chmod 755 vncboot
sudo update-rc.d vncboot defaults
sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncproxy --no-check-certificate
sudo chmod 755 vncproxy 
sudo update-rc.d vncproxy defaults 98

cd /usr/local/share/noVNC/utils
sudo ./launch.sh --vnc localhost:5900 &

# Change permissions so you can execute from the desktop
####  http://thepiandi.blogspot.ae/2013/10/can-python-script-with-gui-run-from.html
####  http://superuser.com/questions/514688/sudo-x11-application-does-not-work-correctly

echo "Change bash permissions for desktop."
if grep -Fxq "xhost +" /home/pi/.bashrc
then
	#Found it, do nothing!
	echo "Found xhost in .bashrc"
else
	sudo echo "xhost +" >> /home/pi/.bashrc
fi

echo "--> Finished setting up noVNC"
echo "--> ======================================="
echo "--> !"
echo "--> !"
echo "--> !"
echo "--> ======================================="
echo " "

########################################################################
## Install Wifi Adhoc
## Sometimes we may not want to do this.  To make it easy, 
## Put it inside an if statement

# This pause is placed because we'll overrun the if statement below if we don't wait a few seconds. 
sleep 10
:'

echo -n "Install Wifi Adhoc? " -r
read ANSWER
if echo "$ANSWER" | grep -iq "^y" ;then
	# Update Wifi Drivers
	echo "--> Update Wifi Drivers"
	echo "--> ======================================="
	cd wifi
	sudo chmod +x setup_wifi.sh
	sudo ./setup_wifi.sh
	cd ..

	# Install Adhoc
	echo "--> Install Adhoc setup."
	echo "--> ======================================="
	cd wifi
	sudo chmod +x setup_host_apd.sh
	sudo ./setup_host_apd.sh
	cd ..
fi
'

########################################################################
## Last bit of house cleaning.

# Setup Hostname Changer
echo "--> Setup Hostname Changer."
echo "--> ======================================="
echo " "
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_host_name.sh		# 1 - Run update_host_name.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/update_host_name.sh			# 2 - Add change to rc.local to new rc.local that checks for hostname on bootup.
echo "--> End hostname change setup."

# Install Samba
echo "--> Start installing Samba."
echo "--> ======================================="
echo " "
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/install_samba.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/install_samba.sh
echo "--> End installing Samba."

echo "--> Begin cleanup."
sudo apt-get clean -y		# Remove any unused packages.
sudo apt-get autoremove -y 	# Remove unused packages.
echo "--> End cleanup."

echo "--> Update version on Desktop."
#Finally, if everything installed correctly, update the version on the Desktop!
cd /home/pi/Desktop
rm Version
cp /home/pi/di_update/Raspbian_For_Robots/Version /home/pi/Desktop

echo "--> ======================================="
echo "--> ======================================="
echo "  _    _               _           _                         ";
echo " | |  | |             | |         | |                        ";
echo " | |  | |  _ __     __| |   __ _  | |_    ___                ";
echo " | |  | | | '_ \   / _\ |  / _\ | | __|  / _ \               ";
echo " | |__| | | |_) | | (_| | | (_| | | |_  |  __/               ";
echo "  \____/  | .__/   \__,_|  \__,_|  \__|_ \___|    _          ";
echo "  / ____| | |                         | |        | |         ";
echo " | |      |_|__    _ __ ___    _ __   | |   ___  | |_    ___ ";
echo " | |       / _ \  |  _ \  _ \ |  _ \  | |  / _ \ | __|  / _ \";
echo " | |____  | (_) | | | | | | | | |_) | | | |  __/ | |_  |  __/";
echo "  \_____|  \___/  |_| |_| |_| | .__/  |_|  \___|  \__|  \___|";
echo "                              | |                            ";
echo "                              |_|                            ";
echo "--> Installation Complete."
echo "--> If this is an update remember to do the following: "
echo "--> Run BrickPi_Python\Project_Examples\browserStreamingRobot\browser_stream_setup.sh"
echo "--> Reduce image size."
echo "--> Midori and web browsers should point to local setup of help files."