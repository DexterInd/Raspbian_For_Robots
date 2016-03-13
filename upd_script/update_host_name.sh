#! /bin/bash
# INSTALLATION FILE:  This file is called from update_all.sh.  It is not part of the actual updating 
# of the hostname.  That function is called from rc.sh (which this file installs!)

# We check if the file "hostnames" exists under /boot

if [ ! -f /boot/hostnames ]; then
    echo "File not found!"
	sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/hostnames /boot 	# Copy our own "hostnames" file in so there's a file there.
fi

# Copy the new rc.local script in place, set permissions. 
sudo cp /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.local /etc/rc.local
sudo chmod 755 /etc/rc.local	# Change permissions to -rwxr-xr-x
sudo chmod +x /home/pi/di_update/Raspbian_For_Robots/upd_script/rc.sh

# Now run the code in rc.local that updates the hostname.  

THISHOST=$(hostname -f)	# Gets current hostname
echo "This host: "
echo $THISHOST
read -r NEW_HOST < /boot/hostnames 	# Gets hostname in file
# line=$(head -n 1 /boot/hostnames)
# NEW_HOST=$line
echo "New Host: "
echo $NEW_HOST

if [ "$FIRSTLINE" != "$THISHOST" ];	# If the hostname isn't the same as the First line of the filename . . .
	then echo "Host is different name.  Rewriting hosts"
	# Rewrite hosts
	IP="127.0.1.1       $NEW_HOST"
	
	sudo rm /etc/hosts

	sudo sh -c "echo '127.0.0.1     localhost' >> /etc/hosts"
	sudo sh -c "echo '::1           ip6-localhost ip6-loopback' >> /etc/hosts"
	sudo sh -c "echo 'fe00::0       ip6-localnet' >> /etc/hosts"
	sudo sh -c "echo 'ff00::0       ip6-mcastprefix' >> /etc/hosts"
	sudo sh -c "echo 'ff02::1       ip6-allnodes' >> /etc/hosts"
	sudo sh -c "echo 'ff02::2       ip6-allrouters' >> /etc/hosts"
	sudo sh -c "echo ' ' >> /etc/hosts"            # Add that blank line in there.
	sudo sh -c "echo $IP >> /etc/hosts"


	echo "Delete hostname."

	sudo rm /etc/hostname
	echo "Deleted hostname.  Create new hostname."
	sudo echo $NEW_HOST >> /etc/hostname
	echo "New hostname file created."
	
	echo "Commit hostname change."
	sudo sh /etc/init.d/hostname.sh
fi
