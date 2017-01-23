#! /bin/bash
# This script will install Samba.
# Reference: http://elinux.org/R-Pi_NAS#Connect_the_RPi_to_a_network
# Reference: http://www.raspians.com/Knowledgebase/how-to-nas-with-samba-and-window/
#

## NOTE: THIS IS NO LONGER UP TO DATE
## NEW VERSION OF SAMBA IS DIFFERENT

sudo DEBIAN_FRONTEND=noninteractive apt-get install samba samba-common-bin -y
echo "Modify Samba configuration."
# Modify samba configuration
sudo sed -i '102s/.*/security = user/' /etc/samba/smb.conf	# Remove the has from security line.
sudo sed -i '250s/.*/read only = no/' /etc/samba/smb.conf		# Enable write to directories.
echo "Restart Samba service"
sudo service samba reload
echo "Set samba password for the default pi user."
sudo echo -e "robots1234\nrobots1234" | (smbpasswd -s pi)
