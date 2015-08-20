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
# 1.    Update the Configuration Files.  Pull the Raspbian for robots Github repo and put it in a subdirectory of pi

# If the directory exists, delete it.

if [ -d /home/pi/di_update ] ; then
	sudo rm -r /home/pi/di_update
fi

# Make the directory again.  Clone into it.  
mkdir /home/pi/di_update
cd /home/pi/di_update
sudo git clone https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots

#
#
#
#
#
#
#
#
#
#
#
# Take this part out when you're done!
cd /home/pi/di_update/Raspbian_For_Robots/
git checkout update201507
#
#
#
#
#
#
#
#
#
#
#
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/update_master.sh


##############################################################################################################
# 2.    Execute the file update_all.sh
# Make sure we keep a log file.

echo "START DESKTOP SHORTCUT UPDATE."
echo "=============================="
# Update the Desktop Shortcut for Software Update
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update_start.sh
sudo rm /home/pi/Desktop/desktop_shortcut_update.desktop
sudo cp /home/pi/di_update/Raspbian_For_Robots/desktop_shortcut_update.desktop /home/pi/Desktop
sudo chmod +x /home/pi/Desktop/desktop_shortcut_update.desktop

# Update the Desktop Shortcut for GrovePi and GoPiGo Firmware Update
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/desktop_firmware_update.sh
sudo sh /home/pi/di_update/Raspbian_For_Robots/desktop_firmware_update.sh

# Run update_all.sh
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh
NOW=$(date +%m-%d-%Y-%H%M%S)
LOG_FILE="/home/pi/di_update/log_output.$NOW.txt"

# sudo /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh 2>&1 | tee ${LOG_FILE}
sudo /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh

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
