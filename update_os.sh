#! /bin/bash
# This script will update the operating system.  
# This script will be changed not so often! 

echo "--> Begin Update."
echo "--> ======================================="
sudo apt-get update -y
echo "--> End Update."
echo "--> ======================================="

echo "--> Begin Upgrade."
echo "--> ======================================="
sudo apt-get upgrade -y
echo "--> End Upgrade."
echo "--> ======================================="

echo "--> Firmware Upgrade."
echo "--> ======================================="
# Commenting out the rpi-update.  
# Note:  https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=137546
# rpi-update is for experimentation only ... or if you like to take risks.
# apt-get dist-upgrade is only useful if you change the distribution, for example from wheezy to jessie.
# sudo apt-get dist-upgrade -y
# sudo rpi-update -y
echo "--> End Firmware Upgrade."
echo "--> ======================================="

echo "--> Begin Cleanup."
echo "--> ======================================="
sudo apt-get clean		# Remove any unused packages.
sudo apt-get autoremove -y # Remove unused packages.
echo "--> End Cleanup."
echo "--> ======================================="

# Update background image - Change to dilogo.png
# These commands don't work:  sudo rm /etc/alternatives/desktop-background  ;;  sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.jpg /etc/alternatives/
echo "--> Update the background image on LXE Desktop."
echo "--> ======================================="
echo " "
sudo rm /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png
sudo cp /home/pi/di_update/Raspbian_For_Robots/dexter_industries_logo.png /usr/share/raspberrypi-artwork/raspberry-pi-logo-small.png
echo "--> End update the background image on LXE Desktop."
echo "--> ======================================="


echo "--> ======================================="
echo "--> ======================================="
echo " Update Raspbian Complete! " 
echo "--> ======================================="
echo "--> ======================================="
