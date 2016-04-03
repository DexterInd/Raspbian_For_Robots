#!/bin/bash

# Update the software for Realtek RTL8188CUS 802.11n WLAN Adapter.
# 1. Removes any hostapd previously installed.
# 2. Make a directory in home directory for wifi installation.
# 3. Install wifi and setup hostapd
# 4. Disable sleep mode for wifi to prevent dropout.

echo "Begin wifi update."
echo "Remove previous versions of hostapd"

#Make a directory.   If the directory is already there, remove it.
echo "Make a directory for wifi drivers"
sudo rm -r /home/pi/wifi
mkdir /home/pi/wifi

# Install wifi
echo "Install wifi drivers."
sudo cp 0001-RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip /home/pi/wifi
cd /home/pi/wifi
sudo unzip 0001-RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip
cd RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911
cd wpa_supplicant_hostapd
sudo tar -xvf wpa_supplicant_hostapd-0.8_rtw_r7475.20130812.tar.gz
cd wpa_supplicant_hostapd-0.8_rtw_r7475.20130812
cd hostapd
echo "Compile wifi drivers."
sudo make
sudo make install

