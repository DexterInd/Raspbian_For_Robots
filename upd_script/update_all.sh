#! /bin/bash
# This script will do the updates.  This script can change all the time!
# This script should OFTEN be changed. 

########################################################################
## These Changes to the image are all mandatory.  If you want to run DI
## Hardware, you're going to need these changes.

sudo apt-get install python3-serial
# sudo apt-get update
# sudo apt-get upgrade
sudo apt-get clean
sudo apt-get install raspberrypi-net-mods -y	# Updates wifi configuration.  Does it wipe out network information?
# Call fetch.sh
# This updates the Github Repositories, installs necessary dependencies.
sudo fetch.sh


########################################################################
## These Changes to the image are all optional.  Some users may not want
## these changes.  They should be offered ala-cart.

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


#Finally, if everything installed correctly, update the version on the Desktop!
cd /home/pi/Desktop
rm Version
cp /home/pi/di_update/Raspbian_For_Robots/Version /home/pi/Desktop

echo "This is just a test script.  And it has run."

