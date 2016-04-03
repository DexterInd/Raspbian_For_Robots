#! /bin/bash

sudo service ntp start
sudo update-rc.d ntp enable
sudo service openvpn start

# sudo openvpn 'US California.ovpn' 
sudo openvpn /etc/openvpn/'US East.ovpn'
