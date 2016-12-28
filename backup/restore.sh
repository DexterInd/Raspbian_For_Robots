#!/usr/bin/env bash
restore_path=/home/pi/Desktop/restored_files
mount_path=/mnt/bkp_drive
mkdir -p $restore_path

#Mount the USB drive, copy the backup to desktop and unmount the drive
echo "Mounting USB Drive"
d=$(sudo fdisk -l /dev/sd? |grep -E -o "/dev/sd[a-z][0-9]+")
sudo mkdir -p $mount_path
sudo mount $d $mount_path

#Find the backup files in the USB drive
bkp_array=()
while IFS=  read -r -d $'\n'; do
    bkp_array+=("$REPLY")
done < <(find $mount_path -name "backup_*"|sed 's#.*/##')		#Find the files without the full path

#Print all the backup options
echo ${#bkp_array[@]}" backups found"
echo "->"${bkp_array[*]}
#Find size of backup array
num_backups=${#bkp_array[@]}

# Choose what to do when no backup found, or more than one backup found
if [ $num_backups -eq 0 ]; then
	echo -e "\nExiting"
elif [ $num_backups -eq 1 ]; then
	echo "Restoring: "${bkp_array[0]}
	
	# Copy to the destination	
	cp $mount_path"/"${bkp_array[0]} $restore_path
	
	# Make a directory with the same name as the tar file (http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash)
	mkdir $restore_path"/"$(basename "${bkp_array[0]%.*.*}")
	
	#Untar and save the backup to desktop
	tar -jxvf $restore_path"/"${bkp_array[0]} -C $restore_path"/"$(basename "${bkp_array[0]%.*.*}") > /dev/null 2>&1
else
	echo -e "\nRestoring latest"
	latest_file=( $(ls $mount_path| sort -n -t _ -k 2 | tail -1) )
	echo "->"$latest_file
	
	#Copy to destination
	cp $mount_path"/"$latest_file $restore_path
	
	# Make a directory with the same name as the tar file 
	mkdir $restore_path"/"$(basename "${latest_file%.*.*}")
	tar -jxvf $restore_path"/"$latest_file -C $restore_path"/"$(basename "${latest_file%.*.*}") > /dev/null 2>&1
	echo -e "\nFiles restored to: "$restore_path
fi
sudo umount $mount_path