#! /bin/bash

# To run this: sudo ./cinch_setup.sh

# THIS METHOD WORKS FOR MAKING IT WORK.  IF YOU CONNECT TO THE AP AND TYPE IN 10.10.10.10 it should work.
# 1).  Adhoc is wifi, open.  SSID is "dex"
# 2).  Connect and should get an IP address.
# 3).  Type in "dex.local" in browser.

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 
	exit 1
fi

SCRIPTDIR="$(readlink -f $(dirname $0))"

# Setup dnsmasq for DHCP server
DNSMASQ_CONF_DIR="/etc/dnsmasq.d/"
mkdir -p $DNSMASQ_CONF_DIR
cp $SCRIPTDIR/dnsmasq.conf $DNSMASQ_CONF_DIR/cinch.conf
apt-get install -y dnsmasq

cd ~
wget https://github.com/DexterInd/RTL8188-hostapd/archive/v2.0.tar.gz
tar -zxvf v2.0.tar.gz
cd RTL8188-hostapd-2.0/hostapd
make install

ifdown wlan0

# Copy modprobe /etc/modprobe.d/cinch-blacklist.conf
cp $SCRIPTDIR/modprobe.conf /etc/modprobe.d/cinch-blacklist.conf

# Copy Interfaces /etc/network/interfaces
if [ -f /etc/network/interfaces ]; then
	mv /etc/network/interfaces /etc/network/interfaces.cinch.bak
fi
cp $SCRIPTDIR/interfaces /etc/network/

# Copy Hostapd /etc/hostapd/hostapd.conf
if [ -f /etc/hostapd/hostapd.conf ]; then
	mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.cinch.bak
fi
cp $SCRIPTDIR/hostapd.conf /etc/hostapd/
sed -i 's/ssid=dex/ssid='$(hostname -f)'/g' /etc/hostapd/hostapd.conf

# Setup IP Forwarding
cp $SCRIPTDIR/sysctl.conf /etc/sysctl.d/cinch.conf
sysctl -p
echo 1 > /proc/sys/net/ipv4/ip_forward

# Start the wireless network
ifup wlan0

# Setup IP Tables
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -t nat -A PREROUTING -i wlan0 --protocol tcp --match tcp --destination-port 80 -j DNAT --to-destination 10.10.10.10:80

# Save IP Tables
iptables-save > /etc/iptables.ipv4.cinch.nat

# Set the Cinch flag in /home/pi/cinch file
# This creates a file "cinch" in the home directory.
echo "1" > /home/pi/cinch

# Restart IP Tables
/etc/init.d/networking restart

# Finally: Kickoff dhcp and hostapd:
systemctl start dnsmasq.service
systemctl start hostapd.service

# Setup to Start at Boot
systemctl enable hostapd.service
systemctl enable dnsmasq.service

# Enable Sam wifi channel select on device boot
sudo cp $SCRIPTDIR/channel_select.service /etc/systemd/system/
sudo chmod 755 /etc/systemd/system/channel_select.service
sudo systemctl daemon-reload
sudo systemctl enable channel_select.service 
