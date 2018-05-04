#! /bin/bash
# This is the master script for updating Raspbian for Robots.
# All updates should be run from this script.
# This script should RARELY be changed.

##############################################################################################################
# 0.    Check for internet connection.
echo " "
echo "Check for internet connectivity..."
echo "=================================="

wget -q --tries=2 --timeout=100 --output-document=/dev/null http://raspberrypi.org
if [ $? -eq 0 ];then
	echo "Connected.  Do not close this window!"
	sleep 1
else
	echo "Unable to Connect, try again !!!"
	echo "Connect your Pi to the internet and try again."
	echo "This window will close in 10 seconds."
	sleep 10
	exit 0
fi
# sudo sh -c "curl -kL dexterindustries.com/update_tools | bash"

PIHOME=/home/pi
DEXTER=Dexter
DEXTER_PATH=$PIHOME/$DEXTER
DEXTER_LIB=lib
DEXTER_LIB_PATH=$DEXTER_PATH/$DEXTER_LIB
DEXTER_SCRIPT_TOOLS=$DEXTER/script_tools
DEXTER_SCRIPT_TOOLS_PATH=$DEXTER_LIB_PATH/$DEXTER_SCRIPT_TOOLS

source $DEXTER_SCRIPT_TOOLS_PATH/functions_library.sh
##############################################################################################################
# 1.    Update the Source Files.  Pull the Raspbian for robots Github repo and put it in a subdirectory of pi.
#		Get the latest update information.

# If the directory exists, delete it.

if [ -d /home/pi/di_update ] ; then
	sudo rm -r /home/pi/di_update
fi

# Make the directory again.  Clone into it.
mkdir /home/pi/di_update
cd /home/pi/di_update
sudo git clone --depth=1 https://github.com/DexterInd/Raspbian_For_Robots/
cd Raspbian_For_Robots
cd /home/pi/di_update/Raspbian_For_Robots/

#
# Take this part out when you're done!
# git checkout develop
#

# Make files executable.
# echo "MAKE FILES EXECUTABLE."
# echo "=============================="
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/update_master.sh
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/raspbian_for_robots_update.py

##############################################################################################################
# 2.	Change all desktop icons around.
#

# Update the Desktop Shortcut for GrovePi and GoPiGo Firmware Update
# sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/desktop_firmware_update.sh
# sudo sh /home/pi/di_update/Raspbian_For_Robots/desktop_firmware_update.sh

##############################################################################################################
# 3.    Execute the file update_all.sh
# Make sure we keep a log file.

sudo apt-get install python-wxgtk3.0 python-wxgtk2.8 build-essential python-psutil python-dev python-pip -y

# Run update_all.sh
NOW=$(date +%m-%d-%Y-%H%M%S)
LOG_FILE="/home/pi/di_update/log_output.$NOW.txt"

# Start raspbian_for_robots_update.py
# This is the GUI that will let you choose to:
# 	1. OS Update
#	2. DI Software Update
#	3. DI Hardware Update

echo "START UPDATE GUI."
echo "=============================="
# sudo python /home/pi/di_update/Raspbian_For_Robots/raspbian_for_robots_update.py
today=`date '+%Y_%m_%d__%H_%M_%S'`;
filename="/home/pi/Desktop/Dexter_Software_Update_log_$today.txt"
script -c 'sudo python /home/pi/di_update/Raspbian_For_Robots/raspbian_for_robots_update.py 2>&1' -f $filename
delete_file /home/pi/index.html*

###
# Old Code John's holding onto as backup.
# sudo /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh 2>&1 | tee ${LOG_FILE}
# sudo /home/pi/di_update/Raspbian_For_Robots/upd_script/update_all.sh

# All output and errors should go to a local file.


##############################################################################################################
# 4.    Reboot the Pi.
#               We must reboot for folks.
echo "To finish any changes, we need to reboot the Pi."
echo "Pi must reboot for changes and updates to take effect."
# echo "Rebooting in 5 seconds!"
# sleep 1
# echo "Rebooting in 4 seconds!"
# sleep 1
# echo "Rebooting in 3 seconds!"
# sleep 1
# echo "Rebooting in 2 seconds!"
# sleep 1
# echo "Rebooting in 1 seconds!"
# sleep 1
# echo "Rebooting now!  Your Pi wake up with a freshly updated Raspberry Pi!"
# sleep 1
# sudo reboot
