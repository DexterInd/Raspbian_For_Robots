#! /bin/bash

# This script installs bootup for Spi vs Spy.

cd /home/pi/

# sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/jessie_update/novnc.service
sudo cp spyvsspi.service /etc/systemd/system/spyvsspi.service
sudo chown root:root /etc/systemd/system/spyvsspi.service

echo "############################################################"
#sudo systemctl daemon-reload
#sudo systemctl enable spyvsspi.service
echo "############################################################"
