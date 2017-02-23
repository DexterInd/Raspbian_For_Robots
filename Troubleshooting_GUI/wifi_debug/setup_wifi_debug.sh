#!/usr/bin/env bash
# This script is tun only once to set up the systemd services for the wifi logging on cinch

sudo cp /home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/wifi_debug/wifi_log.service /etc/systemd/system/
sudo chmod 755 /etc/systemd/system/wifi_log.service
sudo systemctl daemon-reload
sudo systemctl enable wifi_log.service