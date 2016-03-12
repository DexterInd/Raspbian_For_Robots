#! /bin/bash

# Install noVNC

# cd into appropriate directory first.
# I don't know where it's supposed to be
cd /home/pi

git clone git://github.com/kanaka/noVNC

cd ~
sudo wget https://raw.githubusercontent.com/CleoQc/Raspbian_For_Robots/master/jessie_update/novnc.service
sudo cp novnc.service /etc/systemd/system/novnc.service
sudo systemctl daemon-reload
sudo systemctl enable novnc.service
sudo rm novnc.service
# sudo systemctl start novnc.service # not needed
cd ~/noVNC/utils
chmod +x launch.sh
./launch.sh & # must be run in background otherwise the script blocks
