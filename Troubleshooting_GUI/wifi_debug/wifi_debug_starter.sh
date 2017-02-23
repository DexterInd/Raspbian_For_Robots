#!/usr/bin/env bash
# This script is run by the systemd service to run the wifi debug script and create a log in /boot/logs folder
# The script would run every 5 minutes and append to the existing log
PIHOME=/home/pi
DEXTER=Dexter
source $PIHOME/$DEXTER/lib/$DEXTER/script_tools/functions_library.sh

# Check for a logs directory.  If it doesn't exist, create it.
LOGS_DIR=/boot/logs
if folder_exists $LOGS_DIR; then
    echo $LOGS_DIR "Directory Exists"
else
    echo $LOGS_DIR "Directory Created"
    sudo mkdir $LOGS_DIR
fi

pushd /home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/wifi_debug
sudo bash wifi_debug_info.sh
sudo cat wireless-info.txt >> $LOGS_DIR/wireless-info.txt
popd