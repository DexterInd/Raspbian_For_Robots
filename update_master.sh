#! /bin/bash
# This is the master script for updating Raspbian for Robots.
# All updates should be run from this script.
# This script should RARELY be changed.

##############################################################################################################
# 0.    Check for internet connection.
echo " "
echo "Check for internet connectivity..."
echo "=================================="
wget -q --tries=2 --timeout=100 http://google.com
if [ $? -eq 0 ];then
	echo "Connected"
else
	echo "Unable to Connect, try again !!!"
	exit 0
fi

##############################################################################################################
# 1.    Github pull on itself.  Pull the Raspbian for robots Github repo and put it in a subdirectory of pi
mkdir /home/pi/di_update
cd /home/pi/di_update
sudo git clone https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots

##############################################################################################################
# 2.    Execute the file update_all.sh
# Make sure we keep a log file.
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh
NOW=$(date +%m-%d-%Y-%H%M%S)
LOG_FILE="log_output.$NOW.txt"
sudo /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh 2>&1 | tee ${LOG_FILE}
# All output and errors should go to a local file.

##############################################################################################################
# 3.    Reboot the Pi.
#               We must reboot for folks.
echo "To finish changes, we will reboot the Pi."
echo "Pi must reboot for changes and updates to take effect."
echo "If you need to abort the reboot, press Ctrl+C.  Otherwise, reboot!"
echo "Rebooting in 5 seconds!"
sleep 1
echo "Rebooting in 4 seconds!"
sleep 1
echo "Rebooting in 3 seconds!"
sleep 1
echo "Rebooting in 2 seconds!"
sleep 1
echo "Rebooting in 1 seconds!"
sleep 1
echo "Rebooting now!  Your Pi wake up with a freshly updated Raspberry Pi!"
sleep 1
sudo reboot
