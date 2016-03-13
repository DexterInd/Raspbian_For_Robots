#! /bin/bash

# Start on boot script.
# Reset every 12 hours.  Just to keep things fresh.

# sudo ifconfig wlan0 192.168.2.1
# sudo iptables -t nat -A PREROUTING -i wlan0 --protocol tcp --match tcp --destination-port 80 -j DNAT --to-destination 192.168.2.1:80

sudo service ntp start
sudo update-rc.d ntp enable

# NEED TO rewrite /etc/resolv.conf
sudo rm /etc/resolve.conf
sudo rm /home/pi/resolve.conf
sudo echo "domain Home" > /home/pi/resolve.conf
sudo echo "nameserver 8.8.8.8" > /home/pi/resolve.conf
sudo cp resolve.conf /etc/resolve.conf



# sudo openvpn 'US California.ovpn' 
# sudo openvpn /etc/openvpn/'US East.ovpn'
sudo service openvpn start
sudo rm /etc/resolve.conf
sudo cp resolve.conf /etc/resolve.conf
sudo service dnsmasq start 
sudo hostapd /etc/hostapd/hostapd.conf

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward


iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to [ipadres rpi]

########################

sudo service openvpn start
sudo rm /etc/resolv.conf
sudo cp resolv.conf /etc/resolv.conf

sudo iptables -t nat -A INPUT -i eth0 -p udp -m udp --dport 1194 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to-source 192.168.3.104

sudo service dnsmasq start 
sudo hostapd /etc/hostapd/hostapd.conf
########################
# sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to-source ETHERNET-RASPBERRY.PI.IP.ADRESS