#! /bin/bash
# Update the host name.
# We check if the file "hostnames" exists under /boot

if [ ! -f /boot/hostnames ]; then
    echo "File not found!"
	cp /home/pi/di_update/Raspbian_For_Robots/upd_script/hostnames /boot 	# Copy our own "hostnames" file in so there's a file there.
fi

# Copy the new rc.local script in place, set permissions. 
cp /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.local /etc/rc.local
sudo chmod 755 /etc/rc.local	# Change permissions to -rwxr-xr-x
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.sh

# Now run the code in rc.local that updates the hostname.  

THISHOST=$(hostname -f)	# Gets current hostname
echo $THISHOST
read -r NEW_HOST < /boot/hostnames	# Gets hostname in file
echo $NEW_HOST

if [ "$FIRSTLINE" != "$THISHOST" ];	# If the hostname isn't the same as the First line of the filename . . .
	then echo "Host is different name.  Rewriting hosts"
	# Rewrite hosts
	IP="127.0.1.1  		$NEW_HOST"
	sudo sed -i '$ d' /etc/hosts
	sudo echo $IP >> /etc/hosts

	echo "Delete hostname."

	sudo rm /etc/hostname
	echo "Deleted hostname.  Create new hostname."
	sudo echo $NEW_HOST >> /etc/hostname
	echo "New hostname file created."
	
	echo "Commit hostname change."
	sudo /etc/init.d/hostname.sh
fi
