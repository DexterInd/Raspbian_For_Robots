#! /bin/bash

# Update Changes for the Raspberry Pi 3
# These changes were developed by the awesome Brian Dorey.  
# http://www.briandorey.com/post/Raspberry-Pi-3-UART-Overlay-Workaround
# This script was developed by the awesome Dexter Industries.
#
# Note this is called from upd_script/update_all.sh 

sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo rpi-update -y

cd /home/pi/

if grep -q "VERSION_ID=\"8\"" /etc/os-release
then
    #os is Jessie
    sudo sed -i "/dtoverlay=pi3-miniuart-bt-overlay/d" /boot/config.txt
    sudo sed -i "/force_turbo=1/d" /boot/config.txt
    sudo sed -i "/dtoverlay=pi3-miniuart-bt/d" /boot/config.txt
    sudo echo "dtoverlay=pi3-miniuart-bt" >> /boot/config.txt
else
    #os is wheezy
    sudo wget https://github.com/DexterInd/Raspbian_For_Robots/raw/master/pi3/pi3-miniuart-bt-overlay.dtb
    sudo cp pi3-miniuart-bt-overlay.dtb /boot/overlays
    sudo sed -i "/dtoverlay=pi3-miniuart-bt-overlay/d" /boot/config.txt
    sudo sed -i "/force_turbo=1/d" /boot/config.txt
    sudo sed -i "/dtoverlay=pi3-miniuart-bt/d" /boot/config.txt
    sudo echo "dtoverlay=pi3-miniuart-bt-overlay" >> /boot/config.txt
    sudo echo "force_turbo=1" >> /boot/config.txt
fi