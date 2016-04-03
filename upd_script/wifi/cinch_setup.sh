#! /bin/bash

# To run this: sudo sh cinch_setup.sh

# THIS METHOD WORKS FOR MAKING IT WORK.  IF YOU CONNECT TO THE AP AND TYPE IN 10.10.10.10 it should work.
# 1).  Adhoc is wifi, open.  SSID is "dex"
# 2).  Connect and should get an IP address.
# 3).  Type in 10.10.10.10 in browser.  May need to static address into 10.10.10.10:8001, if ethernet is connected.
# 4).  Do NOT connect to Ethernet or you'll have a problem with IP address on noVNC.

sudo apt-get install isc-dhcp-server
cd ~
sudo wget https://github.com/DexterInd/RTL8188-hostapd/archive/v2.0.tar.gz
tar -zxvf v2.0.tar.gz
cd RTL8188-hostapd-2.0/hostapd
sudo make install
sudo service hostapd restart

# Replace /etc/dhcp/dhcpd.conf 
	sudo rm /etc/dhcp/dhcpd.conf
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/dhcpd.conf /etc/dhcp/

# Replace /etc/default/isc-dhcp-server
	sudo rm /etc/default/isc-dhcp-server
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/isc-dhcp-server /etc/default/

sudo ifdown wlan0

# Copy Interfaces /etc/network/interfaces
	sudo rm /etc/network/interfaces
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/interfaces /etc/network/

# Copy Hostapd /etc/hostapd/hostapd.conf
	sudo rm /etc/hostapd/hostapd.conf
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/hostapd.conf /etc/hostapd/

# Copy NAT /etc/sysctl.conf
	sudo rm /etc/sysctl.conf
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/sysctl.conf /etc/

# Setup IP Forward
	sudo sysctl -p
	sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# Start the wireless network
	sudo ifup wlan0

# Setup IP Tables
	sudo iptables -F
	sudo iptables -t nat -F
	sudo iptables -t mangle -F
	sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
	sudo iptables -t nat -A PREROUTING -i wlan0 --protocol tcp --match tcp --destination-port 80 -j DNAT --to-destination 10.10.10.10:80

# Save IP Tables
	sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

# Restart IP Tables
	sudo /etc/init.d/networking restart

# Finally: Kickoff dhcp and hostapd:
	sudo service isc-dhcp-server start
	sudo service hostapd start

# Setup to Start at Boot
	sudo update-rc.d hostapd enable 
	sudo update-rc.d isc-dhcp-server enable

# Copy rc.local
	sudo rm /etc/rc.local
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/wifi/rc.local /etc/
# Change rc.local permissions
	sudo chmod +x /etc/rc.local
		
# Reboot
	sudo reboot