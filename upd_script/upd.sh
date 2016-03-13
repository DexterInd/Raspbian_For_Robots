#! /bin/bash

# Only time this should be called is when updating from the old 2015.03. 
# First we destroy any remnants of the previous Raspbian for Robots.
sudo rm -r /tmp/di_update
sudo rm -r /home/pi/Desktop/Raspbian_For_Robots/

mkdir /home/pi/di_update
cd /home/pi/di_update
git clone https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots

sudo sh update_master.sh

echo " █████╗ ██╗     ███████╗██████╗ ████████╗";
echo "██╔══██╗██║     ██╔════╝██╔══██╗╚══██╔══╝";
echo "███████║██║     █████╗  ██████╔╝   ██║   ";
echo "██╔══██║██║     ██╔══╝  ██╔══██╗   ██║   ";
echo "██║  ██║███████╗███████╗██║  ██║   ██║   ";
echo "╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ";
echo "                                         ";
echo "VERY IMPORTANT TO NOTE:  ";
echo "This will change your hostname from";
echo "raspberrypi to dex";  
echo "To logon, use pi@dex.local";

echo "Press Enter to EXIT"
read