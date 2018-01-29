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
INSTALLER_VERSION="$(cat $SCRIPTDIR/cinch)"

# the next following lines check whether cinch is already installed
# if it's installed it checks if we have a newer VERSION
# if we have a newer version then we uninstall the current one & install the newer one
# if we don't have a newer version, then exit this script
# if it isn't installed then copy the version to /home/pi/cinch
if [[ -f /home/pi/cinch ]]; then
  RPI_VERSION="$(cat /home/pi/cinch)"

	if [[ $RPI_VERSION < $INSTALLER_VERSION ]]; then
		sudo bash ./cinch_uninstaller.sh
	fi
else
	echo $INSTALLER_VERSION > /home/pi/cinch
fi

# Setup dnsmasq for DHCP server
DNSMASQ_CONF_DIR="/etc/dnsmasq.d/"
mkdir -p $DNSMASQ_CONF_DIR
cp $SCRIPTDIR/dnsmasq.conf $DNSMASQ_CONF_DIR/cinch.conf

# NOTE: 2018.01 - We need up update or dnsmasq will throw a 404, and libnl-route-3-200 is not installed in older Jessie.
apt-get update
apt-get install -y dnsmasq libnl-route-3-200

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

# Restart IP Tables
/etc/init.d/networking restart

# Finally: Kickoff dhcp and hostapd:
systemctl start dnsmasq.service
systemctl start hostapd.service

# Setup to Start at Boot
systemctl enable hostapd.service
systemctl enable dnsmasq.service

# Enable wifi channel select on device boot
sudo cp $SCRIPTDIR/channel_select.service /etc/systemd/system/
sudo chmod 755 /etc/systemd/system/channel_select.service
sudo systemctl daemon-reload
sudo systemctl enable channel_select.service

sudo bash /home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/wifi_debug/setup_wifi_debug.sh


# Copy hostapd for rtl wifi adapter and Pi3 wifi adapter
# Copied the binary file-/usr/local/bin/hostapd from cinch image and renamed it to hostapd_rtl_wifi
sudo cp $SCRIPTDIR/hostapd_rtl_wifi /usr/local/bin
# Pi3 wifi adapter was made to work with Raspbian jessie and copied the binary file-/usr/local/bin/hostapd from Raspbian jessie image 
# and renamed it to hostapd_pi3_wifi.
sudo cp $SCRIPTDIR/hostapd_pi3_wifi /usr/local/bin


# Setup the Wifi Interfaces
# This selects which wifi device starts: the USB Device or the Pi3 Wifi
sudo cp $SCRIPTDIR/wifi_interface.service /etc/systemd/system
sudo chmod 644 /etc/systemd/system/wifi_interface.service
sudo systemctl enable wifi_interface.service

echo "Installation complete.  Check errors and reboot to see Cinch network."