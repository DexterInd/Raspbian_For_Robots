#!/usr/bin/env bash

#Save files in /tmp so that they are deleted on reboot
mkdir -p /tmp/bkp

fname=/home/pi/di_update/Raspbian_For_Robots/backup/file_list.txt
bkp_path=/tmp/bkp
mount_path=/mnt/bkp_drive

#http://stackoverflow.com/questions/1688999/how-can-i-read-a-list-of-filenames-from-a-file-in-bash
# NOTE: filelist should be in UNIX format and not windows to avoid EOL confusion (/r/n)
cp $fname $bkp_path
OLDIFS=$IFS
IFS="
"
for F in $(cat $fname) ; do
  echo "copying" $F "..."
  cp -r $F $bkp_path 
done
IFS=$OLDIFS

echo "Files copied" 

# today=`date '+%Y_%m_%d__%H_%M_%S'`;
today=`date '+%Y%m%d%H%M%S'`;
bkp_filename=backup_$today.tar.bz2

# tar -zcvf /tmp/$bkp_filename $bkp_path > /dev/null 2>&1
# zip the file without the /tmp path so that it can be easily loo
tar -cjf /tmp/$bkp_filename -C $bkp_path . > /dev/null 2>&1

echo "Backup created" 

#Mount the USB drive, copy the backup and unmount the drive
d=$(sudo fdisk -l /dev/sd? |grep -E -o "/dev/sd[a-z][0-9]+")
sudo mkdir -p $mount_path
sudo mount $d $mount_path
cp /tmp/$bkp_filename $mount_path
sudo umount $mount_path
echo "Backup copied to USB drive"$bkp_filename
