#! /bin/bash
# This script updates the the code repos on Raspbian for Robots.
echo "Start GoPiGo Update."
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
echo "Remove motors from the GoPiGo."
echo "------------------"
sudo chmod +x firmware_update.sh
sudo ./firmware_update.sh

# Rebooting!
# We must reboot for folks.
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

