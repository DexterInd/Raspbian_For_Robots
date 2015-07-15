#! /bin/bash

# Update the software for Realtek RTL8188CUS 802.11n WLAN Adapter.
echo "Begin wifi update."
sudo apt-get autoremove hostapd
sudo unzip RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip
cd RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911
cd wpa_supplicant_hostapd
sudo tar -xvf wpa_supplicant_hostapd-0.8_rtw_r7475.20130812.tar.gz
cd wpa_supplicant_hostapd-0.8_rtw_r7475.20130812
cd hostapd
sudo make
sudo make install

sudo mv hostapd /usr/sbin/hostapd
sudo chown root.root /usr/sbin/hostapd
sudo chmod 755 /usr/sbin/hostapd

sudo apt-get update
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

Follow Dave Conroy's Directions to Bridge the Network

http://www.daveconroy.com/turn-your-raspberry-pi-into-a-wifi-hotspot-with-edimax-nano-usb-ew-7811un-rtl8188cus-chipset/

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

Modify hostapd.conf

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



# Disable Power Saving.  

echo "End wifi update."