#! /bin/bash

# This is for installing the old monoprice wifi dongles Dexter Industries
# sold way back in 2015.  
# We troubleshot this with the community's help: http://www.dexterindustries.com/topic/wifi-driver/
#
# Run this script by running "sudo sh install_rtl8188eu.sh" in the command line.

echo "  _____            _                               ";
echo " |  __ \          | |                              ";
echo " | |  | | _____  _| |_ ___ _ __                    ";
echo " | |  | |/ _ \ \/ / __/ _ \ '__|                   ";
echo " | |__| |  __/>  <| ||  __/ |                      ";
echo " |_____/ \___/_/\_\\__\___|_| _        _           ";
echo " |_   _|         | |         | |      (_)          ";
echo "   | |  _ __   __| |_   _ ___| |_ _ __ _  ___  ___ ";
echo "   | | | '_ \ / _\` | | | / __| __| '__| |/ _ \/ _\ ";
echo "  _| |_| | | | (_| | |_| \__ \ |_| |  | |  __/\__ \ ";
echo "  _____|_| |_| __ _| __ _ ___  __ _    _  ___  ___  ";
echo "                                                   ";
echo "                                                   ";

cd /home/pi/
sudo mkdir wifi
cd wifi
sudo wget https://github.com/DexterInd/Raspbian_For_Robots/raw/master/upd_script/wifi/rtl8188eu.tgz
sudo tar -xzf rtl8188eu.tgz
cd rtl8188eu/
sudo make install

