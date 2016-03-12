#! /bin/bash

# Install noVNC

# cd into appropriate directory first.
# I don't know where it's supposed to be
cd /home/pi

git clone git://github.com/kanaka/noVNC
cd utils
chmod +x launch.sh
./launch.sh

cd /etc/systesmd/system
sudo wget https://raw.githubusercontent.com/CleoQc/Raspbian_For_Robots/master/jessie_update/novnc.service
sudo systemctl daemon-reload
sudo systemctl enable novnc.service
sudp systemctl start novnc.service
