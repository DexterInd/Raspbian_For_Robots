#! /bin/bash

# Note on dnsmasq: This service, if it's running, has to be stopped, to reach the outside world.  But it needs
# to be restarted if you want to provision web access again after it's installed.  

sudo service dnsmasq stop							# Allows the PI to acces Internet, if this is installed
sudo apt-get install openvpn -y --force-yes
sudo apt-get install network-manager-openvpn -y --force-yes
cd /etc/openvpn
sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip		# This downloads the latest packages.  
sudo unzip openvpn.zip
# sudo service dnsmasq start												# Restart the Pi access to the internet.

sudo nano /etc/openvpn/login.conf

# Todo: add auth.txt file with credentials.
# Todo: Append each ovpn file with "auth-user-pass auth.txt"

sudo chmod 400 /etc/openvpn/login.conf
sudo cp US\ East.ovpn /etc/openvpn/US\ East.conf
sudo nano /etc/openvpn/US\ East.conf

# Echo in auth-user-pass login.conf
# sudo nano /etc/default/openvpn -->  Add in "" AUTOSTART=“US East”

## in each .conf file, added a path.
## Need a script to copy this over on startup.  To 8.8.8.8  /etc/resolv.conf -->  it to the google dns (8.8.8.8) the connection worked via the browser and all seems to be good.

cd ~
mkdir wifi
cd /home/pi/wifi
sudo wget https://github.com/DexterInd/Raspbian_For_Robots/raw/master/upd_script/wifi/0001-RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip
sudo unzip 0001-RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip

cd RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911
cd wpa_supplicant_hostapd
sudo tar -xvf wpa_supplicant_hostapd-0.8_rtw_r7475.20130812.tar.gz
cd wpa_supplicant_hostapd-0.8_rtw_r7475.20130812
cd hostapd
echo "Compile wifi drivers."
sudo make
sudo make install

cd /home/pi/wifi
sudo wget https://github.com/DexterInd/Raspbian_For_Robots/raw/master/upd_script/wifi/hostapd.zip
sudo unzip hostapd.zip
sudo mv hostapd /usr/sbin/hostapd
sudo chown root.root /usr/sbin/hostapd
sudo chmod 755 /usr/sbin/hostapd

sudo wget https://github.com/DexterInd/Raspbian_For_Robots/raw/master/upd_script/wifi/interfaces
# Delete and replace interfaces file
sudo rm /etc/network/interfaces
sudo cp /home/pi/wifi/interfaces /etc/network/interfaces

cd /home/pi/wifi
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/wifi/hostapd.conf

# Modify hostapd.conf
sudo mkdir /etc/hostapd
sudo cp hostapd.conf /etc/

sudo cp hostapd.conf /etc/hostapd/		# Copy the hostapd.conf file

####
# ADD: Auto Start with sudo hostapd /etc/hostapd/hostapd.conf

sudo apt-get install dnsmasq -y

# We will tell our DHCP server that it controls an IP address range between 192.168.0.10 and 192.168.0.200, with our Pi router having the IP of 192.168.0.1. It will be configured as an “authoritative” server acting on the wlan1 device, meaning that it will force clients to discard expired IP addresses.
# $ sudo nano –w /etc/dnsmasq.d/dnsmasq.custom.conf
	interface=wlan1
	dhcp-range=wlan1,192.168.10.10,192.168.10.200,2h
	dhcp-option=3,192.168.10.1 # our router
	dhcp-option=6,192.168.10.1 # our DNS Server
	dhcp-authoritative # force clients to grab a new IP

# Configure the DHCP server to use wlan1 as the device that manages DHCP requests:
sudo nano -w /etc/resolv.conf
	nameserver 192.168.1.1
	nameserver 8.8.8.8
	nameserver 8.8.8.4

# Now configure the wlan1 device to load at boot with a static IP address of 192.168.0.1.
sudo nano -w /etc/network/interfaces