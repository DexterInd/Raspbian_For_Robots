#! /bin/bash
# Setup wifi as an AdHoc Network.
# This will automatically setup wifi to run an adhoc network at start.
# 1. Configures the DNS mask.
# 2. Installs apache server.

sudo apt-get install dnsmasq
sudo apt-get install apache2 -y
sudo apt-get autoremove hostapd

#Setup hostapd
echo "Move files into hostapd!"
cd /home/pi/wifi
sudo mv hostapd /usr/sbin/hostapd
sudo chown root.root /usr/sbin/hostapd
sudo chmod 755 /usr/sbin/hostapd

sudo cp dnsmasq.conf /etc

# Follows Dave Conroy's Directions to Bridge the Network
# http://www.daveconroy.com/turn-your-raspberry-pi-into-a-wifi-hotspot-with-edimax-nano-usb-ew-7811un-rtl8188cus-chipset/

# Delete and replace interfaces file
sudo rm /etc/network/interfaces
sudo cp interfaces /etc/network/interfaces

# Modify hostapd.conf
sudo mkdir /etc/hostapd
sudo cp hostapd.conf /etc/

# Copy the hostapd.conf file
sudo cp hostapd.conf /etc/hostapd/

# Start everything up:

sudo ifconfig wlan0 192.168.2.1
sudo iptables -t nat -A PREROUTING -i wlan0 --protocol tcp --match tcp --destination-port 80 -j DNAT --to-destination 192.168.2.1:80
sudo service dnsmasq start 
sudo hostapd /etc/hostapd/hostapd.conf

echo "End wifi update."

