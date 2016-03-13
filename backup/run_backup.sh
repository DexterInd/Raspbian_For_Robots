#!/usr/bin/env bash

screen -d -r local
sudo python /home/pi/di_update/Raspbian_For_Robots/backup/backup_gui.py
echo "UPDATE FINISHED."
echo "Please close this window."