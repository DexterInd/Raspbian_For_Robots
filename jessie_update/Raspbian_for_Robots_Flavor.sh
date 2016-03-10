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
echo pi:$DEFAULT_PWD > pipasswd
sudo chpasswd < pipasswd
rm pipasswd

####################################
# set default hostname to dex
####################################
# Re-write /etc/hosts
echo "Editing hosts file"
sed 's/raspberrypi/dex/g' </etc/hosts > hosts
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
# Installing Samba
####################################
# samba is needed to gain access to the drive on Windows
sudo apt-get install -y samba samba-common-bin
echo $DEFAULT_PWD > smbpasswd.txt
echo $DEFAULT_PWD >> smbpasswd.txt

sudo cp /etc/samba/smb.conf .
sed '/s/read only = yes/read only = no/g' < smb.conf > smb.conf
sudo cp smb.conf /etc/samba/smb.conf
sudo service samba restart
sudo smbpasswd -a pi < smbpasswd.txt
rm smbpasswd.txt
sudo rm ./smb.conf -y

####################################
# installing tightvncserver
# many many thanks to Russell Davis for all the hints!
# tightvncserver will only work after a reboot - not done here
####################################
sudo apt-get install tightvncserver expect -y
/usr/bin/expect <<EOF
spawn "/usr/bin/tightvncserver"
expect "Password:"
send "$DEFAULT_PWD\r"
expect "Verify:"
send "$DEFAULT_PWD\r"
expect "(y/n?"
send "n\r"
expect eof
EOF
sudo apt-get remove expect -y

# change cursor
sed 's/grey/grey -cursor_name left_ptr/g' < ./.vnc/xstartup > ./.vnc/xstartup

#install systemd service
wget https://raw.githubusercontent.com/CleoQc/Raspbian_For_Robots/master/jessie_update/tightvncserver.service
sudo cp tightvncserver.service /etc/systemd/system/tighvncservice@.service
sudo systemctl daemon-reload && sudo systemctl enable vncserver@1.service



