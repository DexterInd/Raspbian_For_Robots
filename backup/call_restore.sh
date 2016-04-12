#!/usr/bin/env bash
# This file is called to call the restore script with logging.  

today=`date '+%Y_%m_%d__%H_%M_%S'`;
filename="/home/pi/Desktop/Restore_Script_Log_$today.txt" 
script -c 'sudo bash /home/pi/di_update/Raspbian_For_Robots/backup/restore.sh 2>&1' -f $filename
