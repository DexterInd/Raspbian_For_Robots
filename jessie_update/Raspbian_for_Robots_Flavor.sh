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

# This script sets up the environment to fit with Raspbian for Robots, but none of the actual Dexter Industries software

# 1. User Name is Pi, Password is robots1234
# 2. Hostname is dex
# 3. Installing Samba
# 4. Installing tighvncserver

DEFAULT_PWD=robots1234

####################################
# Changing Pi password to robots1234
####################################
echo pi:$DEFAULT_PWD | sudo chpasswd 

####################################
# Installing Samba
####################################

sudo apt-get install -y samba samba-common
sudo cp /etc/samba/smb.conf .
sudo chown pi:pi smb.conf
sudo sed -i 's/read only = yes/read only = no/g' smb.conf

# the security = user line is needed if we want to password protect the SD card
sudo echo 'security = user' >> smb.conf

sudo chown root:root smb.conf
sudo cp smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd.service

# smbpasswd won't take a redirection of the type 
# echo $1\r$1| smbpassd -a pi
# so we do it the long way
echo $DEFAULT_PWD > smbpasswd.txt
echo $DEFAULT_PWD >> smbpasswd.txt
sudo smbpasswd -a pi < smbpasswd.txt
sudo rm smbpasswd.txt # sudo not needed, it's there to be consistent and look pretty
sudo rm smb.conf


####################################
# set default hostname to dex
####################################
# Re-write /etc/hosts
echo "Editing hosts file"
sudo sed 's/raspberrypi/dex/g' </etc/hosts > hosts
sudo cp hosts /etc/hosts
rm hosts

echo "Create new hostname."
echo 'dex' > ./hostname
sudo cp ./hostname /etc/hostname
rm ./hostname
echo "New hostname file created."

echo "Commit hostname change."
sudo /etc/init.d/hostname.sh

echo "Hostname change will be effective after a reboot"


####################################
# installing tightvncserver
# many many thanks to Russell Davis for all the hints!
# tightvncserver will only work after a reboot - not done here
####################################
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/tightvncserver.sh
sudo chmod +x tightvncserver.sh
./tightvncserver.sh $DEFAULT_PWD
sudo rm tightvncserver.sh

####################################
# install noNVC
# this is not yet according to the Dexter Industries way, 
# and still being developed and looked at
# it's being downloaded in the wrong place, for starter
####################################

wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/novnc.sh
chmod +x novnc.sh
./novnc.sh
sudo rm novnc.sh
