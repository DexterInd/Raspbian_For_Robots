# this script is used to remove unwanted packages from Jessie, in order to create more room for Robotics stuff

# samba is needed to gain access to the drive on Windows
sudo apt-get install -y samba samba-common-bin
sudo smbpasswd -a pi < smbpasswd.txt
