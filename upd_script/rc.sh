#!/bin/bash -e
# This Script updates the hostname by reading it from "/boot/hostname" 

source /home/pi/Dexter/lib/Dexter/script_tools/functions_library.sh


if ! quiet_mode
then
    echo "  _____            _                                ";
    echo " |  __ \          | |                               ";
    echo " | |  | | _____  _| |_ ___ _ __                     ";
    echo " | |  | |/ _ \ \/ / __/ _ \ '__|                    ";
    echo " | |__| |  __/>  <| ||  __/ |                       ";
    echo " |_____/ \___/_/\_\\__\___|_| _        _            ";
    echo " |_   _|         | |         | |      (_)           ";
    echo "   | |  _ __   __| |_   _ ___| |_ _ __ _  ___  ___  ";
    echo "   | | | '_ \ / _    | | |   __| __|  | |/ _ \/ __| ";
    echo "  _| |_| | | | (_| | |_| \__ \ |_| |  | |  __/\__ \ ";
    echo " |_____|_| |_|\__,_|\__,_|___/\__|_|  |_|\___||___/ ";
    echo "                                                    ";
    echo "                                                    ";
    echo " "
fi

THISHOST=$(hostname -f) # Gets current hostname
echo "Current hostname: $THISHOST"

# Leaving this out for now: https://github.com/DexterInd/Raspbian_For_Robots/issues/66
# # Cinch Hostname change.  Check for hostapd, if it's present, we are running Cinch.
# # If we have Cinch, change the value of the WPA name to the value of hostname.

# # To change the Wifi access point name if hostname is changed using GUI
if [[ -f /etc/hostapd/hostapd.conf ]] ; then
  sudo sed -i '/^ssid=/s/ssid=.*/ssid='$THISHOST'/g' /etc/hostapd/hostapd.conf
fi

# Now run the code in rc.local that updates the hostname. 

# if we have a file called hostnames in /boot -> rename it to /boot/hostname
# then default to /boot/hostname for the rest of the script

if [ -f /boot/hostnames ]
then
  sudo mv /boot/hostnames /boot/hostname  
fi


HOSTNAME_IN="/boot/hostname"

if [[ ! -f $HOSTNAME_IN ]] ; then
  echo "no hostname change requested"
  exit
fi

echo "Reading from $HOSTNAME_IN"
read -r NEW_HOST < $HOSTNAME_IN # Gets hostname in file
line=$(head -n 1 $HOSTNAME_IN)
NEW_HOST=$line

echo "New hostname: $NEW_HOST"

if [ "$NEW_HOST" != "$THISHOST" ];  # If the hostname isn't the same as the First line of the filename . . .

    then echo "Host is different name."
    REGEX="^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9]))*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$";
    if [[ "$NEW_HOST" =~ $REGEX ]]; then
        echo $NEW_HOST > /home/pi/Desktop/hostname.log
		if [ -f /home/pi/Desktop/Invalid_hostname.log ] #Remove the Invalid hostname.log, if one exists
		then
			rm /home/pi/Desktop/Invalid_hostname.log 
		fi
        
        echo "Rewriting hostname"

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

        sudo echo $NEW_HOST > /etc/hostname
        echo "New hostname file created."
        
        echo "Commit hostname change."
        sudo /etc/init.d/hostname.sh

        sudo rm $HOSTNAME_IN

        # CINCH: if hostapd exists, ensure that the SSID matches the hostname
        if [[ -f /etc/hostapd/hostapd.conf ]] ; then
			sudo sed -i '/^ssid=/s/ssid=.*/ssid='$NEW_HOST'/g' /etc/hostapd/hostapd.conf
        fi    
        # sudo reboot
    else 

        echo "INVALID HOSTNAME"
                echo $NEW_HOST > /home/pi/Desktop/Invalid_hostname.log

    fi
fi
