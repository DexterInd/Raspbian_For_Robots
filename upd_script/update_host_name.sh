#! /bin/bash
# Update the host name.
# We check if the file "hostnames" exists under /boot

if [ ! -f /boot/hostnames ]; then
    echo "File not found!"
	# Copy our own "hostnames" file in
	cp /home/pi/di_update/Raspbian_For_Robots/hostnames/upd_script /boot
fi

