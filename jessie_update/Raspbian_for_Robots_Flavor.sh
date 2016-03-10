# This script sets up the environment to fit with Raspbian for Robots, but none of the actual Dexter Industries software

# 1. User Name is Pi, Password is robots1234
# 2. Hostname is dex
# 3. Installing Samba

DEFAULT_PWD=robots1234

####################################
# Changing Pi password to robots1234
####################################
echo pi:$DEFAULT_PWD > pipasswd
sudo chpasswd < pipasswd

####################################
# set default hostname to dex
####################################
# Re-write /etc/hosts
sed 's/raspberrypi/dex/g' </etc/hosts > hosts
sudo cp hosts /etc/hosts
rm hosts

sudo rm /etc/hostname
echo "Deleted hostname.  Create new hostname."
sudo echo 'dex' >> /etc/hostname
echo "New hostname file created."

echo "Commit hostname change."
sudo /etc/init.d/hostname.sh

####################################
# Installing Samba
####################################
# samba is needed to gain access to the drive on Windows
sudo apt-get install -y samba samba-common-bin
echo #DEFAULT_PWD >> smbpasswd.txt
echo #DEFAULT_PWD >> smbpasswd.txt

sudo cp /etc/samba/smb.conf .
sed '/s/read only = yes/read only = no/g' < smb.conf > smb.conf
sudo cp smb.conf /etc/samba/smb.conf
sudo service samba restart
sudo smbpasswd -a pi < smbpasswd.txt
