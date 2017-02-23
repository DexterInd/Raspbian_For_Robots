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

#If the log has data more than the last 20 runs, delete the information for the first 10 runs
NUM_RUNS=$(grep -o '########## wireless info END ############' $LOGS_DIR/wireless-info.txt | wc -l)
LINE_FOR_EACH_RUN=$(grep -n '########## wireless info END ############' $LOGS_DIR/wireless-info.txt | cut -d : -f1)
RUN_NUM_THRESH=20 #if more than RUN_NUM_THRESH runs of the wifi script in the log, delete the first 10 runs from the log

if [ $NUM_RUNS -gt $RUN_NUM_THRESH ] 
then
    echo "Deleting older run "  
    echo "Runs in wifi log" $NUM_RUNS
    set -- $LINE_FOR_EACH_RUN
    sed -i "1,$10 d" $LOGS_DIR/wireless-info.txt #$10 is the line number of 10th run
else
    echo "Not Deleting older runs"
fi

# Save the current data to the log
pushd /home/pi/di_update/Raspbian_For_Robots/Troubleshooting_GUI/wifi_debug
sudo bash wifi_debug_info.sh
sudo cat wireless-info.txt >> $LOGS_DIR/wireless-info.txt
popd