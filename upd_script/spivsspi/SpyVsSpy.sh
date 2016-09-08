#! /bin/bash

# This script installs bootup for Spi vs Spy.

cd /home/pi/

sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/Mission1_pythonFile.py
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/SpyVsSpy.sh
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/SpyvsSpy_Startup.py
sudo wget https://raw.githubusercontent.com/DexterInd/Raspbian_For_Robots/master/upd_script/spivsspi/spyvsspi.service

sudo cp spyvsspi.service /etc/systemd/system/spyvsspi.service
sudo chown root:root /etc/systemd/system/spyvsspi.service

echo "############################################################"
sudo systemctl daemon-reload
sudo systemctl enable spyvsspi.service
echo "############################################################"
