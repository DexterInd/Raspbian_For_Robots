#! /bin/bash

# Update the software for Realtek RTL8188CUS 802.11n WLAN Adapter.
# 1. Removes any hostapd previously installed.
# 2. Make a directory in home directory for wifi installation.
# 3. Install wifi and setup hostapd

echo "Begin wifi update."
echo "Remove previous versions of hostapd"
sudo apt-get autoremove hostapd

#Make a directory.   If the directory is already there, remove it.
echo "Make a directory for wifi drivers"
sudo rm -r /home/pi/wifi
mkdir /home/pi/wifi

# Install wifi
echo "Install wifi drivers."
sudo mv RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip /home/pi/wifi
cd /home/pi/wifi
sudo unzip RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip
cd RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911
cd wpa_supplicant_hostapd
sudo tar -xvf wpa_supplicant_hostapd-0.8_rtw_r7475.20130812.tar.gz
cd wpa_supplicant_hostapd-0.8_rtw_r7475.20130812
cd hostapd
echo "Compile wifi drivers."
sudo make
sudo make install

#Setup hostapd
echo "Move files into hostapd!"
sudo mv hostapd /usr/sbin/hostapd
sudo chown root.root /usr/sbin/hostapd
sudo chmod 755 /usr/sbin/hostapd

echo "Done installing wifi drivers!"