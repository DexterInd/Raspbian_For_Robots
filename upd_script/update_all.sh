#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script should OFTEN be changed. 

########################################################################
## These Changes to the image are all mandatory.  If you want to run DI
## Hardware, you're going to need these changes.

sudo apt-get install python3-serial
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

# Install PHP
if [ -f $PHP ];then echo ""
else
   echo "$PHP command is not installed."
   echo "Running sudo apt-get install php"
   sudo apt-get install -y php5
   TEMPVAR = "1";
fi

########################################################################
## These Changes to the image are all optional.  Some users may not want
## these changes.  They should be offered ala-cart.

# Update Wifi Interface
sudo apt-get install raspberrypi-net-mods -y	# Updates wifi configuration.  Does it wipe out network information?

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

sudo apt-get clean	# Remove any unused packages.

#Finally, if everything installed correctly, update the version on the Desktop!
cd /home/pi/Desktop
rm Version
cp /home/pi/di_update/Raspbian_For_Robots/Version /home/pi/Desktop

echo "This is just a test script.  And it has run."

