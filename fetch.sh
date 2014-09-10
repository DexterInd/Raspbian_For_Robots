#! /bin/bash
echo "GIT UPDATE"
echo "----------"
cd /home/pi/Desktop/GoPiGo
sudo git fetch origin
git reset --hard
sudo git merge origin/master

cd Setup
echo "UPDATING LIBRARIES"
echo "------------------"
sudo chmod +x install.sh
sudo ./install.sh
cd ../Firmware/

echo "UPDATING FIRMWARE"
echo "------------------"
sudo chmod +x firmware_update.sh
sudo ./firmware_update.sh
echo "Please restart the Raspberry Pi for the changes to take effect"

