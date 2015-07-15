#! /bin/bash
# This is the master script for updating Raspbian for Robots.
# All updates should be run from this script.
# This script should RARELY be changed. 

##############################################################################################################
# 0.  	Check for internet connection.

##############################################################################################################
# 1.  	Github pull on itself.  Pull the Raspbian for robots Github repo and put it in a subdirectory of pi
mkdir /home/pi/di_update
sudo git clone https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots

##############################################################################################################
# 2.  	Execute the file update_all.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh
sudo /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh

##############################################################################################################
# 3.  	Reboot the Pi.
# 		We must reboot for folks.
echo "Rebooting in 5 seconds!"
sleep 1
echo "Rebooting in 4 seconds!"
sleep 1
echo "Rebooting in 3 seconds!"
sleep 1
echo "Rebooting in 2 seconds!"
sleep 1
echo "Rebooting in 1 seconds!"
sleep 1
echo "Rebooting now!  Your Pi wake up with a freshly updated Raspberry Pi!"
sleep 1
sudo reboot

