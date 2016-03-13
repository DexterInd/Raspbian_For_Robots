#! /bin/bash
# This script disables wifi sleep mode of the Dexter Industries Wifi Dongle
#Create and edit a new file /etc/modprobe.d/8192cu.conf
#Paste the following in:
## Disable power saving
## options 8192cu rtw_power_mgnt=0 rtw_enusbss=1 rtw_ips_mode=1

sudo rm /etc/modprobe.d/8192cu.conf
sudo cat <<EOF > /etc/modprobe.d/8192cu.conf
# Disable power saving
options 8192cu rtw_power_mgnt=0 rtw_enusbss=0 rtw_ips_mode=1

EOF