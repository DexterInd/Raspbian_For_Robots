#!/usr/bin/env bash
# This file is called to call the backup script with logging.  

today=`date '+%Y_%m_%d__%H_%M_%S'`;
filename="/home/pi/Desktop/Backup_Script_Log_$today.txt" 
script -c 'sudo sh /home/pi/di_update/Raspbian_For_Robots/backup/backup.sh 2>&1' -f $filename