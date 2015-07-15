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

sudo nano /etc/network/interfaces

#loopback adapter
auto lo
iface lo inet loopback
#wired adapter
iface eth0 inet dhcp
#bridge
auto br0
iface br0 inet dhcp
bridge_ports eth0 wlan0

# Modify hostapd.conf

sudo mkdir /etc/hostapd
cd hostapd
sudo nano hostapd.conf

sudo nano /etc/hostapd/hostapd.conf

interface=wlan0
driver=rtl871xdrv
bridge=br0
ssid=DaveConroyPi
channel=1
wmm_enabled=0
wpa=1
wpa_passphrase=ConroyPi
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
auth_algs=1
macaddr_acl=0


start everything up:
     sudo ifconfig wlan0 192.168.2.1
     sudo iptables -t nat -A PREROUTING -i wlan0 --protocol tcp --match tcp --destination-port 80 -j DNAT --to-destination 192.168.2.1:80
     sudo service dnsmasq start 
     sudo hostapd /etc/hostapd/hostapd.conf


 

echo "End wifi update."