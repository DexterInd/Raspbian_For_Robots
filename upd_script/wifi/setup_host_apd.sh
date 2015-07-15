#! /bin/bash
# Setup wifi as an AdHoc Network.
# This will automatically setup wifi to run an adhoc network at start.
# 1. Configures the DNS mask.
# 2. Installs apache server.


sudo apt-get dnsmasq


sudo nano /etc/dnsmasq.conf
interface=wlan0
no-resolv
no-poll
no-hosts
listen-address=192.168.2.1
address=/#/192.168.2.1
dhcp-range=192.168.2.10,192.168.2.70,255.255.255.0,24h


sudo apt-get install apache2 -y

# Follows Dave Conroy's Directions to Bridge the Network
# http://www.daveconroy.com/turn-your-raspberry-pi-into-a-wifi-hotspot-with-edimax-nano-usb-ew-7811un-rtl8188cus-chipset/

# Delete and replace interfaces file
sudo rm /etc/network/interfaces
### COPY INTERFACES HERE


# Modify hostapd.conf

sudo mkdir /etc/hostapd
cd hostapd
sudo nano hostapd.conf

# Copy the hostapd.conf file
sudo cp hostapd.conf /etc/hostapd/




start everything up:
     sudo ifconfig wlan0 192.168.2.1
     sudo iptables -t nat -A PREROUTING -i wlan0 --protocol tcp --match tcp --destination-port 80 -j DNAT --to-destination 192.168.2.1:80
     sudo service dnsmasq start 
     sudo hostapd /etc/hostapd/hostapd.conf


 

echo "End wifi update."