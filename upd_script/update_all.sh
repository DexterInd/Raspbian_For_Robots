#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script should OFTEN be changed. 

########################################################################
## These Changes to the image are all mandatory.  If you want to run DI
## Hardware, you're going to need these changes.

sudo apt-get install python3-serial -y
sudo apt-get install python-serial -y
sudo apt-get install i2c-tools -y
sudo apt-get install python-wxgtk2.8 -y		# Install wx for python for windows / GUI programs.

sudo apt-get purge python-rpi.gpio
sudo apt-get purge python3-rpi.gpio
sudo apt-get install python-rpi.gpio
sudo apt-get install python3-rpi.gpio

# sudo apt-get update	
# sudo apt-get upgrade


# Cleanup the Desktop
sudo rm /home/pi/Desktop/ocr_resources.desktop 		# Not sure how this Icon got here, but let's take it out.
sudo rm /home/pi/Desktop/python-games.desktop 		# Not sure how this Icon got here, but let's take it out.

# Call fetch.sh - This updates the Github Repositories, installs necessary dependencies.
sudo fetch.sh

# Update background image - Change to dilogo.png
# These commands don't work:  sudo rm /etc/alternatives/desktop-background  ;;  sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.jpg /etc/alternatives/
sudo rm /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png
sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.png /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png


########################################################################
## These Changes to the image are all optional.  Some users may not want
## these changes.  They should be offered ala-cart.

# Update Wifi Interface
sudo apt-get install raspberrypi-net-mods -y	# Updates wifi configuration.  Does it wipe out network information?

# Setup Apache
sudo apt-get install apache2 -y
sudo apt-get install php5 libapache2-mod-php5 -y

# Setup Webpage
sudo rm -r /var/www
sudo cp /home/pi/di_update/Raspbian_For_Robots/www /var/

# Setup Shellinabox
sudo apt-get install shellinabox -y

# Setup noVNC
sudo apt-get install screen
echo "Setup noVNC"
cd /usr/local/share/
sudo git clone git://github.com/DexterInd/noVNC
cd noVNC
sudo cp vnc_auto.html index.html
cd /etc/init.d/
sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncboot --no-check-certificate
sudo chmod 755 vncboot
sudo update-rc.d vncboot defaults
sudo wget https://raw.githubusercontent.com/DexterInd/teachers-classroom-guide/master/vncproxy --no-check-certificate
#### CHECK HERE ON LINE 22 - IS THIS WHERE YOU CAN LAUNCH IT IN A FOLDER?
sudo chmod 755 vncproxy 
sudo update-rc.d vncproxy defaults 98

cd /usr/local/share/noVNC/utils
sudo ./launch.sh --vnc localhost:5900
echo "Finished setting up noVNC"

# Update Wifi Drivers
cd wifi
sudo chmod +x setup_wifi.sh
sudo ./setup_wifi.sh
cd ..

# Install Adhoc
cd wifi
sudo chmod +x setup_host_apd.sh
sudo ./setup_host_apd.sh
cd ..

# Setup Hostname Changer
echo "Setup Hostname Changer."
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_host_name.sh		# 1 - Run update_host_name.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/update_host_name.sh			# 2 - Add change to rc.local to new rc.local that checks for hostname on bootup.
echo "End hostname change setup."

# Install Samba
echo "Start installing Samba."
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/install_samba.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/upd_script/install_samba.sh
echo "End installing Samba."

sudo apt-get clean		# Remove any unused packages.
sudo apt-get autoremove # Remove unused packages.

#Finally, if everything installed correctly, update the version on the Desktop!
cd /home/pi/Desktop
rm Version
cp /home/pi/di_update/Raspbian_For_Robots/Version /home/pi/Desktop

echo "Installation Complete."

echo "If this is an update remember to do the following: "

echo "Run BrickPi_Python\Project_Examples\browserStreamingRobot\browser_stream_setup.sh"
echo "Reduce image size."
echo "Midori and web browsers should point to local setup of help files."

