if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

SCRIPTDIR="$(readlink -f $(dirname $0))"

# check whether cinch is already installed
if [[ ! -f /home/pi/cinch ]]; then
  exit 1
fi

# stopping services
# wifi_log.service is for cinch -> service to run the wifi debug script and creates an appending log in /boot/logs folder
# channel_select.service is for cinch
# hostapd is for cinch -> for configuring the hotspot details (such ssid, channel, PSKs, etc)
# dnsmasq is for cinch -> provides dns, dhcp and network boot functionalities
systemctl stop wifi_log.service
systemctl stop channel_select.service
systemctl stop dnsmasq.service
systemctl stop hostapd.service

# then we need to disable them
systemctl disable wifi_log.service
systemctl disable channel_select.service
# warnings come from here -> it's related to the runlevel from which we stop the service(s)
systemctl disable dnsmasq.service
systemctl disable hostapd.service

# remove configuration files needed for cinch to work
rm -f /etc/systemd/system/wifi_log.service
rm -f /etc/systemd/system/channel_select.service
rm -f /etc/dnsmasq.d/dnsmasq.conf
rm -f /etc/dnsmasq.d/cinch.conf
rm -f /etc/sysctl.d/cinch.conf
rm -f /etc/modprobe.d/cinch-blacklist.conf

# check if a backup was made
if [[ -f /etc/hostapd/hostapd.conf.cinch.bak ]]; then
  # and if so, then rename the backup to the original filename
  mv -f /etc/hostapd/hostapd.conf.cinch.bak /etc/hostapd/hostapd.conf
  rm -f /etc/hostapd/hostapd.conf.cinch.bak
else
  # otherwise, just remove it, since it means that it wasn't there
  # before installing cinch
  rm -f /etc/hostapd/hostapd.conf
fi

# reload the service manager
systemctl daemon-reload
systemctl reset-failed

# and remove dnsmasq package (which deals with the dns, dhcp & network boot functionalities)
# apt-get --purge remove dnsmasq

# reset all the iptables
# basically allowing all trafic in and out
iptables -P INPUT ACCEPT # accept input connections
iptables -P FORWARD ACCEPT # accept forwarding connections
iptables -P OUTPUT ACCEPT # accept all output connections
iptables -t nat -F # erase any NAT settings
iptables -t nat -X
iptables -t mangle -F # erase any modifications brought to packet headers (like TTL, MTU size, etc)
iptables -F # delete all rules
iptables -X

# also remove the iptables for cinch
rm -f /etc/iptables.ipv4.cinch.nat

# check if a backup is present
if [[ -f /etc/network/interfaces.cinch.bak ]]; then
  # if it's so, then give it's original name
  mv -f /etc/network/interfaces.cinch.bak /etc/network/interfaces
  rm -f /etc/network/interfaces.cinch.bak
else
  # otherwise, it means the file didn't even existed before
  # installing cinch
  rm -f /etc/network/interfaces
fi

# flush wlan0
ip addr flush dev wlan0
# and restart the interface
ifdown wlan0
ifup wlan0

# and finally officialize the uninstalling of cinch
# by removing the files that contains the version of the program
rm -f /home/pi/cinch
