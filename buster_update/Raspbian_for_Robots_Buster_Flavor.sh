#! /bin/bash
#
# Set some details to fit Rasbpian for Robots
# mainly :
# set the password for user Pi to robots1234
# set samba password to robots1234
# set hostname to dex
# by Nicole Parrot // Dexter Industries
#
###################################################

echo "********** FLAVOR ***********"

echo "WARNING WARNING WARNING"
echo "you will need to manually enter the password for samba"
echo "WARNING WARNING WARNING"

# This script sets up the environment to fit with Raspbian for Robots, but none of the actual Dexter Industries software

# 1. User Name is Pi, Password is robots1234
# 2. Hostname is dex
# 3. Installing Samba


DEFAULT_PWD=robots1234

####################################
# Changing Pi password to robots1234
####################################
echo pi:$DEFAULT_PWD | sudo chpasswd

####################################
# Installing Samba
####################################
echo "********** SAMBA ***********"
sudo apt-get install -y samba samba-common
sudo sed -i 's/read only = yes/read only = no/g' /etc/samba/smb.conf
sudo sed -i 's/create mask = 0700/create mask = 0775/g' /etc/samba/smb.conf
sudo sed -i 's/directory mask = 0700/directory mask = 0775/g' /etc/samba/smb.conf


sudo systemctl restart smbd.service

# set samba password manually

echo "enter samba password"
sudo smbpasswd -a pi


####################################
# Shell in a box
####################################

sudo apt-get install -y shellinabox
# disable requirement for SSL for shellinabox
# adding after line 41, which is approximately where similar arguments are found.
# it could really be anywhere in the file - NP
sudo sed -i '/SHELLINABOX_ARGS=/d' /etc/init.d/shellinabox
sudo sed -i '41 i\SHELLINABOX_ARGS="--disable-ssl"' /etc/init.d/shellinabox


####################################
# set default hostname to dex
####################################
# Re-write /etc/hosts
echo "Editing hosts file"
sudo sed -i 's/raspberrypi/dex/g' /etc/hosts
sudo hostnamectl set-hostname dex

echo "Hostname change will be effective after a reboot"

####################################
# Install autodetecting
####################################

sudo cp /home/pi/di_update/Raspbian_For_Robots/buster_update/auto_detect_robot.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable auto_detect_robot.service


####################################
# override  GPG3 antenna color
####################################

sudo mkdir -p /etc/systemd/system/antenna_wifi.service.d/
sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/antenna_wifi_override.conf /etc/systemd/system/antenna_wifi.service.d/
sudo systemctl daemon-reload
sudo systemctl restart antenna_wifi.service

####################################
# DO MANUALLY
####################################

# 1.
# From the Preferences menu, select recommended software
# install Scratch


# 2.
# open File Manager
# go to Edit / Preferences
# click on `Don't ask options on launch executable file`

# 3.
# in ~/.bashrc, add `xhost + &>/dev/null` as the last line

# 4. change background image and background/text color
