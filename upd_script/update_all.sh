#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script will be changed OFTEN! 

########################################################################
## These Changes to the image are all mandatory.  If you want to run DI
## Hardware, you're going to need these changes.

echo "--> Begin Update."
echo "--> ======================================="
sudo dpkg --configure -a
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y	# Get everything updated.  Don't interact with any configuration menus.
							# Referenced from here - http://serverfault.com/questions/227190/how-do-i-ask-apt-get-to-skip-any-interactive-post-install-configuration-steps
echo "Install Specific Libraries."
sudo apt-get --purge remove python-wxgtk2.8 python-wxtools wx2.8-i18n -y	  			# Removed, this can sometimes cause hangups.  
sudo apt-get remove python-wxgtk3.0 -y

echo "Purged wxpython tools"
sudo apt-get install python-wxgtk2.8 python-wxtools wx2.8-i18n --force-yes -y			# Install wx for python for windows / GUI programs.
echo "Installed wxpython tools"
sudo apt-get install python-psutil --force-yes -y
sudo apt-get remove python-wxgtk3.0 -y
echo "Python-PSUtil"

sudo apt-get install python3-serial -y
sudo apt-get install python-serial -y
sudo apt-get install i2c-tools -y

sudo apt-get purge python-rpi.gpio -y
sudo apt-get purge python3-rpi.gpio -y
sudo apt-get install python-rpi.gpio -y
sudo apt-get install python3-rpi.gpio -y
sudo apt-get install python-psutil -y 		# Used in Scratch GUI
sudo apt-get install python-picamera -y
sudo apt-get install python3-picamera -y
sudo apt-get install python3-smbus
sudo apt-get install python-smbus
sudo pip install -U RPi.GPIO -y

sudo apt-get install avahi-daemon avahi-utils -y	# Added to help with avahi issues.  2016.01.03
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y

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
sudo sed -i "/ipv6/d" /etc/modules
sudo echo "ipv6" >> /etc/modules
sudo sed -i "/spi-dev/d" /etc/modules
sudo echo "spi-dev" >> /etc/modules

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

# This is really imprtant for the BrickPi!
sudo sed -i "/init_uart_clock=32000000/d" /boot/config.txt
sudo echo "init_uart_clock=32000000" >> /boot/config.txt

# Disable serial over UART
sudo sed -i 's/console=ttyAMA0,115200//' /boot/cmdline.txt  #disable serial login on older images
sudo sed -i 's/console=serial0,115200//' /boot/cmdline.txt  #disable serial login on the Pi3 
sudo sed -i 's/console=tty1//' /boot/cmdline.txt            #console=tty1 can also be there in the cmdline.txt file so remove that 
sudo sed -i 's/kgbdoc=ttyAMA0,115200//' /boot/cmdline.txt
sudo systemctl stop serial-getty@ttyAMA0.service
sudo systemctl disable serial-getty@ttyAMA0.service

echo "--> End Kernel Updates."

########################################################################
##
# Avahi Updates to Networking Protocols
# Many settings were copied from Google Coder:
# https://github.com/googlecreativelab/coder/blob/master/raspbian-addons/etc/avahi/avahi-daemon.conf
# http://manpages.ubuntu.com/manpages/vivid/man5/avahi-daemon.conf.5.html

sudo rm /etc/avahi/avahi-daemon.conf 														# Remove Avahi Config file.
sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/avahi-daemon.conf /etc/avahi 		# Copy new Avahi Config File.
sudo chmod +x /etc/avahi/avahi-daemon.conf 													# Set permissions for avahi config file.

sudo modprobe ipv6

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
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/wifi_disable_sleep.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/wifi_disable_sleep.sh

# Setup Webpage
echo "--> Setup webpage."
echo "--> ======================================="
echo " "
sudo rm -r /var/www
sudo cp -r /home/pi/di_update/Raspbian_For_Robots/www /var/
sudo chmod +x /var/www/index.php
sudo chmod +x /var/www/css/main.css

## Now, if we are running Jessie, we need to move everything
## into a new subdirectory.
## Get the Debian Version we have installed.
VERSION=$(sed 's/\..*//' /etc/debian_version)
echo "Version: $VERSION"
if [ $VERSION -eq '7' ]; then
  echo "Version 7 found!  You have Wheezy!"
elif [ $VERSION -eq '8' ]; then
  echo "Version 8 found!  You have Jessie!"
  # If we found Jesse, the proper location of the html files is in
  # /var/www/html
  sudo mkdir /var/www/html
  sudo mv -v /var/www/* /var/www/html/
  sudo chmod +x /var/www/html/index.php
  sudo chmod +x /var/www/html/css/main.css  
fi

echo $VERSION


# Setup Shellinabox
echo "--> Setup Shellinabox."
echo "--> ======================================="
echo " "
sudo apt-get install shellinabox -y

# disable requirement for SSL for shellinaboxa 
# adding after line 41, which is approximately where similar arguments are found.
# it could really be anywhere in the file - NP
sudo sed -i '/SHELLINABOX_ARGS=/d' /etc/init.d/shellinabox
sudo sed -i '41 i\SHELLINABOX_ARGS="--disable-ssl"' /etc/init.d/shellinabox


# Setup noVNC
echo "--> Setup screen."
echo "--> ======================================="
echo " "
sudo apt-get install screen -y
echo "--> Setup noVNC"
echo "--> ======================================="
echo " "
cd /usr/local/share/
echo "--> Clone noVNC."
sudo git clone git://github.com/DexterInd/noVNC
cd noVNC
sudo git pull
sudo cp vnc_auto.html index.html


# VNC Start on boot
# reading VERSION again, in case lines get moved, or deleted above.
# better safe
VERSION=$(sed 's/\..*//' /etc/debian_version)
echo "Version: $VERSION"
# setting start-on-boot for Wheezy. Those two scripts are not needed for Jessie
# Wheezy 
if [ $VERSION -eq '7' ]; then
  echo "Version 7 found!  You have Wheezy!"
  cd /etc/init.d/
  sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncboot --no-check-certificate
  sudo chmod 755 vncboot
  sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncproxy --no-check-certificate
  sudo chmod 755 vncproxy 
  # why default 98? I can't find what it's supposed to do - NP
  sudo update-rc.d vncproxy defaults 98
  sudo update-rc.d vncproxy defaults
  sudo update-rc.d vncproxy enable
  sudo update-rc.d vncboot defaults
  sudo update-rc.d vncboot enable
  cd /usr/local/share/noVNC/utils
  sudo ./launch.sh --vnc localhost:5900 &

#jessie
elif [ $VERSION -eq '8' ]; then
  echo "Version 8 found!  You have Jessie!"
  pushd /home/pi

  # if we have a local copy of novnc.service, get rid of it before downloading a new one
  if [ -e /home/pi/novnc.service ]
  then
    sudo rm novnc.service
    echo "removing local copy of novnc.service"
  fi

  sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/novnc.service
  sudo mv novnc.service /etc/systemd/system/novnc.service
  sudo systemctl daemon-reload
  sudo systemctl enable novnc.service
  sudo systemctl start novnc.service
  popd
fi

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
# ensure the Scratch examples are reachable via Scratch GUI
# this is done by using soft links
########################################################################
bash /home/pi/di_update/Raspbian_For_Robots/upd_script/upd_scratch_softlinks.sh

# This pause is placed because we'll overrun the if statement below if we don't wait a few seconds. 
sleep 10

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

# Install Backup
echo "--> Start installing Backup."
echo "--> ======================================="
echo " "
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/backup.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/restore.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/call_backup.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/call_restore.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/run_backup.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/file_list.txt
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/backup/backup_gui.py
echo "--> End installing Backup."

echo "--> Update for RPi3."
# Run the update script for updating overlays for Rpi3.
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/pi3/Pi3.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/pi3/Pi3.sh

# remove wx version 3.0 - which gets pulled in by various other libraries
# it creates graphical issues in our Python GUI
sudo apt-get remove python-wxgtk3.0 -y

echo "--> Begin cleanup."
sudo apt-get clean -y		# Remove any unused packages.
sudo apt-get autoremove -y 	# Remove unused packages.
echo "--> End cleanup."

echo "--> Update version on Desktop."
#Finally, if everything installed correctly, update the version on the Desktop!
cd /home/pi/Desktop
rm Version
rm version.desktop
sudo cp /home/pi/di_update/Raspbian_For_Robots/desktop/version.desktop /home/pi/Desktop
sudo chmod +x /home/pi/Desktop/version.desktop


# edition version file to reflect which Rasbpian flavour
VERSION=$(sed 's/\..*//' /etc/debian_version)
echo "Version: $VERSION"
if [ $VERSION -eq '8' ]; then
  echo "Modifying Version file to reflect Jessie distro"
  sudo sed -i 's/Wheezy/Jessie/g' /home/pi/di_update/Raspbian_For_Robots/Version
fi


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
echo " | |       / _ \  |  _ \  _ \ |  _ \  | |  / _ \ | __|  / _ \ ";
echo " | |____  | (_) | | | | | | | | |_) | | | |  __/ | |_  |  __/ ";
echo "  \_____|  \___/  |_| |_| |_| | .__/  |_|  \___|  \__|  \___| ";
echo "                              | |                            ";
echo "                              |_|                            ";
echo "--> Installation Complete."
echo "--> "
echo "--> "
echo "--> Press the Exit button and the Pi will automatically reboot."
